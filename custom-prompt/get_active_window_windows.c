#ifdef _WIN32
#include <windows.h>

long long unsigned get_active_window_id(void)
{
    return (long long unsigned)GetForegroundWindow();
}
#endif
