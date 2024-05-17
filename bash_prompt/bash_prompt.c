#define _POSIX_C_SOURCE 199309L

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

enum
{
    MAX_INFO_LEN = 64
};

/******************************************************************************
 * Get the current time with respect an unspecified reference point, which is
 * considered zero time.
 *
 * @return Time in milliseconds.
 *****************************************************************************/
long long get_time_info(void)
{
    struct timespec now;
    clock_gettime(CLOCK_REALTIME, &now);
    return now.tv_sec * 1000LL + now.tv_nsec / 1000000LL;
}

int main(int const argc, char const *argv[])
{
    if (argc <= 1)
    {
        printf("%lld\n", get_time_info());
        return EXIT_SUCCESS;
    }

    long long begin = atoll(argv[1]);
    // If Linux, send notification from here as well!

    static char git_info[MAX_INFO_LEN] = "";
    // get_git_info(git_info);
}
