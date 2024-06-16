#ifdef __linux__
#include <X11/Xatom.h>
#include <X11/Xlib.h>
#include <stddef.h>

long long unsigned get_active_window_id(void)
{
    Display *display = XOpenDisplay(NULL);
    Window root_window = DefaultRootWindow(display);
    Atom property = XInternAtom(display, "_NET_ACTIVE_WINDOW", False);

    Atom actual_type_return;
    int actual_format_return;
    long unsigned nitems_return;
    long unsigned bytes_after_return;
    char unsigned *prop_return;
    XGetWindowProperty(display, root_window, property, 0, 1, False, XA_WINDOW, &actual_type_return,
        &actual_format_return, &nitems_return, &bytes_after_return, &prop_return);

    Window active_window_id = *(Window *)prop_return;
    XFree(prop_return);
    XCloseDisplay(display);
    return active_window_id;
}
#endif
