#ifdef __APPLE__
#include <stddef.h>
#include <time.h>

long long unsigned get_active_window_id(void)
{
    // TODO Figure out how to do this.
    return time(NULL);
}
#endif
