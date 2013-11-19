#import <Cocoa/Cocoa.h>

#import "mach_inject/mach_inject_bundle/mach_inject_bundle.h"

@interface Dock2D : NSObject

- (void)run;

@end

@implementation Dock2D

- (void)makeDock2D:(NSRunningApplication*)application
{
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"D2D.bundle"];

    mach_inject_bundle_pid(
        [bundlePath fileSystemRepresentation],
        [application processIdentifier]);
}

- (void)makeLaunchedDock2D
{
    NSArray *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.dock"];

    for(NSRunningApplication *app in apps)
        [self makeDock2D:app];
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    [self makeLaunchedDock2D];

    [[NSDistributedNotificationCenter defaultCenter]
                                                addObserver:self
                                                   selector:@selector(dockLaunchedNotification:)
                                                       name:@"com.apple.desktop.ready"
                                                     object:nil];

    return self;
}

- (void)dealloc
{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)dockLaunchedNotification:(NSNotification*)notification
{
    [self makeLaunchedDock2D];
}

- (void)run
{
    [[NSRunLoop currentRunLoop] run];
}

@end

int main(int argc, const char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Dock2D            *app  = [[[Dock2D alloc] init] autorelease];

    [app run];

    [pool release];
    return 0;
}
