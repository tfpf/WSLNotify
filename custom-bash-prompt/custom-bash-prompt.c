#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#if defined __APPLE__
#define OPERATING_SYSTEM_ICON " "
#elif defined __linux__
#define OPERATING_SYSTEM_ICON " "
#elif defined _WIN32
#define OPERATING_SYSTEM_ICON " "
#else
#define OPERATING_SYSTEM_ICON ""
#endif

#define START_OF_HEADING "\x01"
#define START_OF_TEXT "\x02"
#define BELL "\x07"
#define ESCAPE "\x1B"
#define LEFT_SQUARE_BRACKET "\x5B"
#define RIGHT_SQUARE_BRACKET "\x5D"

// Bold, bright and italic.
#define bbiyellow START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "1;3;93m" START_OF_TEXT

// Bold and bright.
#define bbcyan START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "1;96m" START_OF_TEXT
#define bbgreen START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "1;92m" START_OF_TEXT

// Bright.
#define bblue START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "94m" START_OF_TEXT
#define bgreen START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "92m" START_OF_TEXT
#define bred START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "91m" START_OF_TEXT

// Dark.
#define dcyan START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "36m" START_OF_TEXT

// Reset.
#define rst START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "m" START_OF_TEXT

// #undef NDEBUG  // TODO Remove once this program is completed.
#ifndef NDEBUG
#define LOG(fmt, ...) fprintf(stderr, dcyan "%s:%d" rst " " fmt "\n", __FILE__, __LINE__ __VA_OPT__(, ) __VA_ARGS__)
#else
#define LOG(fmt, ...)
#endif

/******************************************************************************
 * Get the current timestamp.
 *
 * @return Time in milliseconds since a fixed but unspecified reference point.
 *****************************************************************************/
long long get_timestamp(void)
{
    struct timespec now;
    timespec_get(&now, TIME_UTC);
    return now.tv_sec * 1000LL + now.tv_nsec / 1000000LL;
}

/******************************************************************************
 * Show how long it took to run a command, given the timestamp it was started
 * at.
 *
 * @param last_command Most-recently run command.
 * @param exit_code Code with which the command exited.
 * @param begin Timestamp of the instant the command was started at.
 *
 * @return Success code if the command ran for a long time, else failure code.
 *****************************************************************************/
int report_command_status(char const *last_command, int exit_code, long long begin)
{
    long long end = get_timestamp();
    long long delay = end - begin;
    int this_exit_code = delay > 10000 ? EXIT_SUCCESS : EXIT_FAILURE;
    LOG("Command '%s' exited with code %d in %lld ms.", last_command, exit_code, delay);
    if (delay <= 5000)
    {
        return this_exit_code;
    }

    // Remove the initial part (index and timestamp) of the command. Then
    // allocate enough space to write it and some additional information.
    last_command = strstr(last_command, RIGHT_SQUARE_BRACKET) + 2;
    char *report = malloc((strlen(last_command) + 32) * sizeof *report);
    char *report_ptr = report;

    report_ptr += sprintf(report_ptr, "%s ", last_command);
    if (exit_code == 0)
    {
        report_ptr += sprintf(report_ptr, bgreen "✓" rst " ");
    }
    else
    {
        report_ptr += sprintf(report_ptr, bred "✗" rst " ");
    }
    int milliseconds = delay % 1000;
    int seconds = (delay /= 1000) % 60;
    int minutes = (delay /= 60) % 60;
    int hours = delay / 60;
    LOG("Calculated delay is %d h %d m %d s %d ms.", hours, minutes, seconds, milliseconds);
    if (hours > 0)
    {
        report_ptr += sprintf(report_ptr, "%d h ", hours);
    }
    if (hours > 0 || minutes > 0)
    {
        report_ptr += sprintf(report_ptr, "%d m ", minutes);
    }
    sprintf(report_ptr, "%d.%03d s", seconds, milliseconds);

    // Ensure that the text is right-aligned even if it spans multiple lines.
    // Since there are non-printable characters in the string, compensate for
    // the width.
    int report_len = (int)strlen(report);
    int columns = atoi(getenv("COLUMNS"));
    columns = columns - report_len % columns + report_len + 14;
    LOG("Padding report of length %d to %d columns (adjusted).", report_len, columns);
    fprintf(stderr, "%*s\n", columns, report);

    return this_exit_code;
}

/******************************************************************************
 * Update the title of the current terminal window. This should also
 * automatically update the title of the current terminal tab.
 *
 * @param pwd Current working directory.
 *****************************************************************************/
void update_terminal_title(char const *pwd)
{
    char const *short_pwd = strrchr(pwd, '/') + 1;
    fprintf(stderr, ESCAPE RIGHT_SQUARE_BRACKET "0;%s/" BELL, short_pwd);
}

/******************************************************************************
 * Show the primary prompt for Bash.
 *
 * @param git_info Description of the status of the current Git repository.
 * @param venv Name of the current Python virtual environment.
 *****************************************************************************/
void display_primary_prompt(char const *git_info, char const *venv)
{
    LOG("Showing primary prompt.");
    printf("\n┌[" bbgreen "\\u" rst " " bbiyellow OPERATING_SYSTEM_ICON "\\h" rst " " bbcyan "\\w" rst "]");
    if (git_info != NULL)
    {
        printf("%s", git_info);
    }
    if (venv != NULL)
    {
        printf("  " bblue "%s" rst, venv);
    }
    printf("\n└─\\$ \n");
}

int main(int const argc, char const *argv[])
{
    if (argc <= 1)
    {
        printf("%lld\n", get_timestamp());
        return EXIT_SUCCESS;
    }

    // For better accuracy, do this first.
    int this_exit_code = report_command_status(argv[1], atoi(argv[2]), atoll(argv[3]));

    char const *venv = getenv("VIRTUAL_ENV_PROMPT");
    LOG("Current Python virtual environment is '%s'.", venv);
    display_primary_prompt(argv[4], venv);

    char const *pwd = getenv("PWD");
    LOG("Current directory is '%s'.", pwd);
    update_terminal_title(pwd);

    return this_exit_code;
}
