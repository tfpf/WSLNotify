#include <ctype.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef __linux__
#include <libnotify/notify.h>
#endif

struct Interval
{
    unsigned hours;
    unsigned minutes;
    unsigned seconds;
    unsigned milliseconds;
};

long long unsigned get_active_window_id(void);

#if defined __APPLE__
#define HOST_ICON ""
#elif defined __linux__
#define HOST_ICON ""
#elif defined _WIN32
#define HOST_ICON ""
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

#define ESCAPE "\x1B"
#define LEFT_SQUARE_BRACKET "\x5B"
#define BACKSLASH "\x5C"
#define RIGHT_SQUARE_BRACKET "\x5D"

// Bold, bright and italic.
#define BBI_YELLOW BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "1;3;93m" END_INVISIBLE

// Bold and bright.
#define BB_CYAN BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "1;96m" END_INVISIBLE
#define BB_GREEN BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "1;92m" END_INVISIBLE

// Bright.
#define B_BLUE BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "94m" END_INVISIBLE
#define B_GREEN_RAW ESCAPE LEFT_SQUARE_BRACKET "92m"
#define B_GREY_RAW ESCAPE LEFT_SQUARE_BRACKET "90m"
#define B_RED_RAW ESCAPE LEFT_SQUARE_BRACKET "91m"

// Dark.
#define D_CYAN_RAW ESCAPE LEFT_SQUARE_BRACKET "36m"

// No formatting.
#define RESET BEGIN_INVISIBLE ESCAPE LEFT_SQUARE_BRACKET "m" END_INVISIBLE
#define RESET_RAW ESCAPE LEFT_SQUARE_BRACKET "m"

#ifndef NDEBUG
#define LOG_DEBUG(fmt, ...) log_debug(__FILE__, __func__, __LINE__, fmt __VA_OPT__(, ) __VA_ARGS__)
#else
#define LOG_DEBUG(fmt, ...)
#endif

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
    fprintf(stderr, B_GREY_RAW "%s" RESET_RAW " ", timebuf);
    fprintf(stderr, D_CYAN_RAW "%s" RESET_RAW ":", file_name);
    fprintf(stderr, D_CYAN_RAW "%s" RESET_RAW ":", function_name);
    fprintf(stderr, D_CYAN_RAW "%d" RESET_RAW " ", line_number);
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
long long unsigned get_timestamp(void)
{
    struct timespec now;
    timespec_get(&now, TIME_UTC);
    LOG_DEBUG("Current time is %lld.%09ld.", (long long)now.tv_sec, now.tv_nsec);
    return now.tv_sec * 1000000000ULL + now.tv_nsec;
}

/******************************************************************************
 * Represent an amount of time in human-readable form.
 *
 * @param delay Time measured in nanoseconds.
 * @param interval Time measured in a easier-to-understand units.
 *****************************************************************************/
void delay_to_interval(long long unsigned delay, struct Interval *interval)
{
    interval->milliseconds = (delay /= 1000000ULL) % 1000;
    interval->seconds = (delay /= 1000) % 60;
    interval->minutes = (delay /= 60) % 60;
    interval->hours = delay / 60;
    LOG_DEBUG("Calculated interval is %u h %u m %u s %u ms.", interval->hours, interval->minutes, interval->seconds,
        interval->milliseconds);
}

/******************************************************************************
 * Show information about the running time of a command with a desktop
 * notification.
 *
 * @param last_command Most-recently run command.
 *****************************************************************************/
void notify_desktop(char const *last_command)
{
#if defined __APPLE__ || defined _WIN32
    // Use OSC 777, which is supported on the terminals I use on these systems:
    // Kitty, iTerm2 and WezTerm.
    fprintf(stderr, ESCAPE RIGHT_SQUARE_BRACKET "777;notify;CLI Ready;%s" ESCAPE BACKSLASH, last_command);
#else
    // Xfce Terminal (the best terminal) does not support OSC 777. Do it the
    // hard way.
    notify_init(__FILE__);
    NotifyNotification *notification = notify_notification_new("CLI Ready", last_command, NULL);
    notify_notification_show(notification, NULL);
    // notify_uninit();
#endif
}

/******************************************************************************
 * Show information about the running time of a command textually.
 *
 * @param last_command Most-recently run command.
 * @param last_command_len Length of the command.
 * @param exit_code Code with which the command exited.
 * @param interval Running time of the command.
 * @param columns Width of the terminal window.
 *****************************************************************************/
void write_report(
    char const *last_command, size_t last_command_len, int exit_code, struct Interval const *interval, int columns)
{
    char *report = malloc((last_command_len + 64) * sizeof *report);
    char *report_ptr = report;

    LOG_DEBUG("Terminal width is %d.", columns);
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
        report_ptr += sprintf(report_ptr, B_GREEN_RAW "" RESET_RAW " ");
    }
    else
    {
        report_ptr += sprintf(report_ptr, B_RED_RAW "" RESET_RAW " ");
    }

    if (interval->hours > 0)
    {
        report_ptr += sprintf(report_ptr, "%02u:", interval->hours);
    }
    report_ptr += sprintf(report_ptr, "%02u:%02u.%03u", interval->minutes, interval->seconds, interval->milliseconds);

    // Ensure that the text is right-aligned. Since there are non-printable
    // characters in the string, compensate for the width.
    int width = columns + 12;
    LOG_DEBUG("Report length is %ld.", report_ptr - report);
    LOG_DEBUG("Padding report to %d characters.", width);
    fprintf(stderr, "\r%*s\n", width, report);

    // free(report);
}

/******************************************************************************
 * Show information about the running time of a command if it ran for long.
 *
 * @param last_command Most-recently run command.
 * @param exit_code Code with which the command exited.
 * @param delay Running time of the command in nanoseconds.
 * @param active_window_id ID of the focused window when the command started.
 * @param columns Width of the terminal window.
 *****************************************************************************/
void report_command_status(
    char *last_command, int exit_code, long long unsigned delay, long long unsigned active_window_id, int columns)
{
    LOG_DEBUG("Command '%s' exited with code %d in %llu ns.", last_command, exit_code, delay);
    if (delay <= 5000000000ULL)
    {
        return;
    }

    struct Interval interval;
    delay_to_interval(delay, &interval);

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
    LOG_DEBUG("Command length is %zu.", last_command_len);

    write_report(last_command, last_command_len, exit_code, &interval, columns);
    if (delay > 10000000000ULL && active_window_id != get_active_window_id())
    {
        notify_desktop(last_command);
    }
}

/******************************************************************************
 * Update the title of the current terminal window. This should also
 * automatically update the title of the current terminal tab.
 *
 * @param pwd Current directory.
 *****************************************************************************/
void update_terminal_title(char const *pwd)
{
    LOG_DEBUG("Current directory is '%s'.", pwd);
    char const *short_pwd = strrchr(pwd, '/') + 1;
    LOG_DEBUG("Setting terminal window title to '%s/'.", short_pwd);
    fprintf(stderr, ESCAPE RIGHT_SQUARE_BRACKET "0;%s/" ESCAPE BACKSLASH, short_pwd);
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
    printf("\n┌[" BB_GREEN USER RESET " " BBI_YELLOW HOST_ICON " " HOST RESET " " BB_CYAN DIRECTORY RESET "]");
    if (git_info[0] != '\0')
    {
        printf("   %s", git_info);
    }
    if (venv != NULL)
    {
        printf("  " B_BLUE "%s" RESET, venv);
    }
    printf("\n└─" PROMPT_SYMBOL " ");
}

int main(int const argc, char const *argv[])
{
    long long unsigned ts = get_timestamp();
    if (argc <= 1)
    {
        printf("%llu %llu\n", ts, get_active_window_id());
        return EXIT_SUCCESS;
    }

    // Allow the first argument to be modified (this is allowed in C) in order
    // to avoid copying it in the function which receives it.
    char *last_command = (char *)argv[1];
    int exit_code = strtol(argv[2], NULL, 10);
    long long unsigned delay = ts - strtoll(argv[3], NULL, 10);
    long long unsigned active_window_id = strtoull(argv[4], NULL, 10);
    int columns = strtol(argv[5], NULL, 10);
    char const *git_info = argv[6];
    char const *pwd = argv[7];

    report_command_status(last_command, exit_code, delay, active_window_id, columns);
    display_primary_prompt(git_info);
    update_terminal_title(pwd);

    return EXIT_SUCCESS;
}
