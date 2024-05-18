#define _POSIX_C_SOURCE 199309L

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define log(...)                                                                                                      \
    fprintf(stderr, "%s:%d ", __FILE__, __LINE__);                                                                    \
    fprintf(stderr, __VA_ARGS__)

#define START_OF_HEADING "\x01"
#define START_OF_TEXT "\x02"
#define ESCAPE "\x1B"
#define LEFT_SQUARE_BRACKET "\x5B"
#define RIGHT_SQUARE_BRACKET "\x5D"

char const *bright_red = START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "91m" START_OF_TEXT;
char const *bright_green = START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "92m" START_OF_TEXT;
char const *reset_colour = START_OF_HEADING ESCAPE LEFT_SQUARE_BRACKET "m" START_OF_TEXT;

enum
{
    MAX_INFO_LEN = 64
};

/******************************************************************************
 * Get the current timestamp.
 *
 * @return Time in milliseconds since a fixed but unspecified reference point.
 *****************************************************************************/
long long get_time_info(void)
{
    struct timespec now;
    timespec_get(&now, TIME_UTC);
    return now.tv_sec * 1000LL + now.tv_nsec / 1000000LL;
}

/******************************************************************************
 * Show how long it took to run a command, given the timestamp it was started
 * at.
 *
 * @param begin Timestamp of the instant the command was started at.
 *****************************************************************************/
void report_status(int exit_status, char const *last_command, long long begin, int columns)
{
    long long end = get_time_info();
    long long delay = end - begin;
    if (delay <= 5000)
    {
        return;
    }

    // Allocate enough space to write the command and some additional
    // information.
    char *report = malloc(strlen(last_command) + 32);
    char *report_ptr = report;

    // I have configured Bash to store the date and time in square brackets
    // before the command in the history. To extract the command, skip to a
    // closing square bracket.
    last_command = strstr(last_command, RIGHT_SQUARE_BRACKET) + 2;
    report_ptr += sprintf(report_ptr, "%s ", last_command);
    if (exit_status == 0)
    {
        report_ptr += sprintf(report_ptr, "%s✓%s ", bright_green, reset_colour);
    }
    else
    {
        report_ptr += sprintf(report_ptr, "%s✗%s ", bright_red, reset_colour);
    }
    int milliseconds = delay % 1000;
    int seconds = (delay /= 1000) % 60;
    int minutes = (delay /= 60) % 60;
    int hours = delay / 60;
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
    columns = columns - report_len % columns + report_len + 14;
    printf("%*s\n", columns, report);
}

int main(int const argc, char const *argv[])
{
    if (argc <= 1)
    {
        printf("%lld\n", get_time_info());
        return EXIT_SUCCESS;
    }

    report_status(atoi(argv[1]), argv[2], atoll(argv[3]), atoi(argv[4]));

    // If Linux, send notification from here as well!

    // static char git_info[MAX_INFO_LEN] = "";
    // get_git_info(git_info);
}
