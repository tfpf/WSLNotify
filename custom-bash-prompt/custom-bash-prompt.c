#define _POSIX_C_SOURCE 199309L

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

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
void report_status(int exit_status, char const *last_command, long long begin)
{
    // Allocate enough space to write the command and some additional
    // information.
    char *report = malloc(strlen(last_command) + 32);
    char *report_ptr = report;

    last_command = strstr(last_command, "]") + 2;
    report_ptr += sprintf(report_ptr, "%s ", last_command);

    if (exit_status == 0)
    {
        report_ptr += sprintf(report_ptr, "✓ ");
    }
    else
    {
        report_ptr += sprintf(report_ptr, "✗ ");
    }

    printf("%s\n", report);

    // long long end = get_time_info();
    // long long delay = end - begin;
    // int milliseconds = delay % 1000;
    // int seconds = (delay /= 1000) % 60;
    // int minutes = (delay /= 60) % 60;
    // int hours = delay / 60;
    // static char delay_info[MAX_INFO_LEN];
    // char *delay_info_ptr = delay_info;
    // if (hours > 0)
    // {
    //     delay_info_ptr += sprintf(delay_info_ptr, "%d h ", hours);
    // }
    // if (hours > 0 || minutes > 0)
    // {
    //     delay_info_ptr += sprintf(delay_info_ptr, "%d m ", minutes);
    // }
    // sprintf(delay_info_ptr, "%d.%03d s", seconds, milliseconds);

    // char const *status_info = "YO";
    // if(exit_status != 0){
    //     status_info = "NO";
    // }

    // printf("%s %s %s\n", last_command, status_info, delay_info);
}

int main(int const argc, char const *argv[])
{
    if (argc <= 1)
    {
        printf("%lld\n", get_time_info());
        return EXIT_SUCCESS;
    }

    report_status(atoi(argv[1]), argv[2], atoll(argv[3]));

    // If Linux, send notification from here as well!

    // static char git_info[MAX_INFO_LEN] = "";
    // get_git_info(git_info);
}
