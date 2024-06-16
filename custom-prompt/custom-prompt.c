#undef NDEBUG
#include <ctype.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#if defined __APPLE__
#define OPERATING_SYSTEM_ICON ""
#elif defined __linux__
#define OPERATING_SYSTEM_ICON ""
#elif defined _WIN32
#define OPERATING_SYSTEM_ICON ""
#else
#error "unknown OS"
#endif

#if defined BASH
#define BEGIN_INVISIBLE "\x01"
#define END_INVISIBLE "\x02"
#define USER "\\u"
#define HOST "\\h"
#define DIRECTORY "\\w"
#define PROMPT_SYMBOL "\\$"
#elif defined ZSH
#define BEGIN_INVISIBLE "%%\x7B"
#define END_INVISIBLE "%%\x7D"
#define USER "%%n"
#define HOST "%%m"
#define DIRECTORY "%%~"
#define PROMPT_SYMBOL "%%#"
#else
#error "unknown shell"
#endif

#define BELL "\x07"
#define ESCAPE "\x1B"
#define LEFT_SQUARE_BRACKET "\x5B"
#define RIGHT_SQUARE_BRACKET "\x5D"

// Bold, bright and italic.
#define bbiyellow BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "1;3;93m" END_INVISIBLE

// Bold and bright.
#define bbcyan BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "1;96m" END_INVISIBLE
#define bbgreen BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "1;92m" END_INVISIBLE

// Bright.
#define bblue BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "94m" END_INVISIBLE
#define bgreen_raw ESCAPE LEFT_SQUARE_BRACKET "92m"
#define bgrey_raw ESCAPE LEFT_SQUARE_BRACKET "90m"
#define bred_raw ESCAPE LEFT_SQUARE_BRACKET "91m"

// Dark.
#define dcyan_raw ESCAPE LEFT_SQUARE_BRACKET "36m"

// Reset.
#define rst BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "m" END_INVISIBLE
#define rst_raw ESCAPE LEFT_SQUARE_BRACKET "m"

#ifndef NDEBUG
#define LOG_DEBUG(fmt, ...) log_debug(__FILE__, __func__, __LINE__, fmt __VA_OPT__(, ) __VA_ARGS__)
#else
#define LOG_DEBUG(fmt, ...)
#endif

long long unsigned get_active_window_id(void);

/******************************************************************************
 * Write a debugging message.
 *
 * @param file_name
 * @param function_name
 * @param line_number
 * @param fmt Format string. Arguments after it will be used to format it.
 *****************************************************************************/
void log_debug(char const *file_name, char const *function_name, int line_number, char const *fmt, ...)
{
    time_t now = time(NULL);
    static char timebuf[64];
    strftime(timebuf, sizeof timebuf / sizeof *timebuf, "%FT%T%z", localtime(&now));
    fprintf(stderr, bgrey_raw "%s" rst_raw " ", timebuf);
    fprintf(stderr, dcyan_raw "%s" rst_raw ":", file_name);
    fprintf(stderr, dcyan_raw "%s" rst_raw ":", function_name);
    fprintf(stderr, dcyan_raw "%d" rst_raw " ", line_number);
    va_list ap;
    va_start(ap, fmt);
    vfprintf(stderr, fmt, ap);
    va_end(ap);
    fprintf(stderr, "\n");
}

/******************************************************************************
 * Get the current timestamp.
 *
 * @return Time in nanoseconds since a fixed but unspecified reference point.
 *****************************************************************************/
long long get_timestamp(void)
{
    struct timespec now;
    timespec_get(&now, TIME_UTC);
    LOG_DEBUG("Current time is %lld.%09ld.", (long long)now.tv_sec, now.tv_nsec);
    return now.tv_sec * 1000000000LL + now.tv_nsec;
}

/******************************************************************************
 * Show how long it took to run a command, given the timestamp it was started
 * at.
 *
 * @param last_command Most-recently run command.
 * @param exit_code Code with which the command exited.
 * @param begin Timestamp of the instant the command was started at.
 * @param end Timestamp of the instant the command exited at.
 *
 * @return Success code if the command ran for a long time, else failure code.
 *****************************************************************************/
int report_command_status(char *last_command, int exit_code, long long begin, long long end)
{
    long long delay = end - begin;
    LOG_DEBUG("Command '%s' exited with code %d in %lld ns.", last_command, exit_code, delay);
    if (delay <= 5000000000LL)
    {
        return EXIT_FAILURE;
    }

#ifdef BASH
    // Remove the initial part (index and timestamp) of the command.
    last_command = strchr(last_command, RIGHT_SQUARE_BRACKET[0]) + 2;
#endif
    // Remove trailing whitespace characters, if any. Then allocate enough
    // space to write what remains and some additional information.
    size_t last_command_len = strlen(last_command);
    while (isspace(last_command[--last_command_len]) != 0)
    {
    }
    last_command[++last_command_len] = '\0';
    LOG_DEBUG("Command is of length %zu.", last_command_len);
    char *report = malloc((last_command_len + 64) * sizeof *report);
    char *report_ptr = report;

    int columns = atoi(getenv("COLUMNS"));
    LOG_DEBUG("Terminal width is %d columns.", columns);
    int left_piece_len = columns * 3 / 8;
    int right_piece_len = left_piece_len;
    if (last_command_len <= (size_t)(left_piece_len + right_piece_len) + 5)
    {
        report_ptr += sprintf(report_ptr, " %s ", last_command);
    }
    else
    {
        LOG_DEBUG("Breaking command into pieces of lengths %d and %d.", left_piece_len, right_piece_len);
        report_ptr += sprintf(report_ptr, " %.*s ... ", left_piece_len, last_command);
        report_ptr += sprintf(report_ptr, "%s ", last_command + last_command_len - right_piece_len);
    }
    if (exit_code == 0)
    {
        report_ptr += sprintf(report_ptr, bgreen_raw "" rst_raw " ");
    }
    else
    {
        report_ptr += sprintf(report_ptr, bred_raw "" rst_raw " ");
    }
    int this_exit_code = delay > 10000000000LL ? EXIT_SUCCESS : EXIT_FAILURE;
    int milliseconds = (delay /= 1000000LL) % 1000;
    int seconds = (delay /= 1000) % 60;
    int minutes = (delay /= 60) % 60;
    int hours = delay / 60;
    LOG_DEBUG("Calculated delay is %d h %d m %d s %d ms.", hours, minutes, seconds, milliseconds);
    if (hours > 0)
    {
        report_ptr += sprintf(report_ptr, "%02d:", hours);
    }
    report_ptr += sprintf(report_ptr, "%02d:%02d.%03d", minutes, seconds, milliseconds);

    // Ensure that the text is right-aligned. Since there are non-printable
    // characters in the string, compensate for the width.
    int width = columns + 12;
    LOG_DEBUG("Padding report of length %ld to %d characters.", report_ptr - report, width);
    fprintf(stderr, "\r%*s\n", width, report);

    free(report);
    return this_exit_code;
}

/******************************************************************************
 * Update the title of the current terminal window. This should also
 * automatically update the title of the current terminal tab.
 *****************************************************************************/
void update_terminal_title(void)
{
    char const *pwd = getenv("PWD");
    LOG_DEBUG("Current directory is '%s'.", pwd);
    char const *short_pwd = strrchr(pwd, '/') + 1;
    LOG_DEBUG("Setting terminal window title to '%s/'.", short_pwd);
    fprintf(stderr, ESCAPE RIGHT_SQUARE_BRACKET "0;%s/" BELL, short_pwd);
}

/******************************************************************************
 * Show the primary prompt.
 *
 * @param git_info Description of the status of the current Git repository.
 *****************************************************************************/
void display_primary_prompt(char const *git_info)
{
    char const *venv = getenv("VIRTUAL_ENV_PROMPT");
    LOG_DEBUG("Current Python virtual environment is '%s'.", venv);
    LOG_DEBUG("Showing primary prompt.");
    printf("\n┌[" bbgreen USER rst " " bbiyellow OPERATING_SYSTEM_ICON " " HOST rst " " bbcyan DIRECTORY rst "]");
    if (git_info != NULL)
    {
        printf("%s", git_info);
    }
    if (venv != NULL)
    {
        printf("  " bblue "%s" rst, venv);
    }
    printf("\n└─" PROMPT_SYMBOL " \n");
}

int main(int const argc, char const *argv[])
{
    LOG_DEBUG("Active window ID is %llu.", get_active_window_id());
    long long ts = get_timestamp();
    if (argc <= 1)
    {
        printf("%lld\n", ts);
        return EXIT_SUCCESS;
    }

    // For more accurate timing, run the timer function first. It is
    // permissible to modify the command line arguments in C, so mark the first
    // as mutable: this avoids copying the string in the function.
    int this_exit_code = report_command_status((char *)argv[1], atoi(argv[2]), atoll(argv[3]), ts);
    display_primary_prompt(argv[4]);
    update_terminal_title();

    return this_exit_code;
}
