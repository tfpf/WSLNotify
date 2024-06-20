#ifdef __APPLE__
#include <Cocoa/Cocoa.h>
#include <CoreGraphics/CGWindow.h>

long long unsigned activeWindow(void)
{
    NSArray *windows = (NSArray *)CGWindowListCopyWindowInfo(kCGWindowListExcludeDesktopElements|kCGWindowListOptionOnScreenOnly,kCGNullWindowID);
    for(NSDictionary *window in windows){
        int WindowLayer = [[window objectForKey:(NSString *)kCGWindowLayer] intValue];
        if (WindowLayer == 0) {
            return [[window objectForKey:(NSString *)kCGWindowNumber] intValue];
        }
    }
    return 0;
}
#endif
