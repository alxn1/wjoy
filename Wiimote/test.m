#import "WiimoteDevice.h"
#import "WiimoteDevicesWatchdog.h"

@interface Test : NSObject<WiimoteDeviceDelegate>
{
    @private
        WiimoteDevice *m_Device;
}

- (void)run;

@end

@implementation Test

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                   selector:@selector(onDeviceFinded:)
                                       name:WiimoteDeviceConnectedNotification
                                     object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_Device disconnect];
    [super dealloc];
}

- (void)onDeviceFinded:(NSNotification*)notification
{
    [m_Device disconnect];
    m_Device = [notification object];

    NSLog(@"Connected: %@", [m_Device addressString]);

    [m_Device setDelegate:self];
    [m_Device setHighlightedLEDMask:WiimoteLEDOne];
}

- (void)run
{
    if(![WiimoteDevice isBluetoothEnabled])
    {
        NSLog(@"Please, enable bluetooth!");
        return;
    }

    [[WiimoteDevicesWatchdog sharedWatchdog] setEnabled:YES];
    [WiimoteDevice beginDiscovery];
    [[NSRunLoop currentRunLoop] run];
}

- (void)wiimoteDevice:(WiimoteDevice*)device buttonPressed:(WiimoteButtonType)button
{
    NSLog(@"Button %i pressed", button);
}

- (void)wiimoteDevice:(WiimoteDevice*)device buttonReleased:(WiimoteButtonType)button
{
    NSLog(@"Button %i released", button);
}

- (void)wiimoteDevice:(WiimoteDevice*)device highlightedLEDMaskChanged:(NSUInteger)mask
{
    NSLog(@"highlightedLEDMaskChanged: %i", mask);
}

- (void)wiimoteDevice:(WiimoteDevice*)device vibrationStateChanged:(BOOL)isVibrationEnabled
{
}

- (void)wiimoteDevice:(WiimoteDevice*)device batteryLevelUpdated:(double)batteryLevel isLow:(BOOL)isLow
{
    NSLog(@"battery level: %lf, isLow: %@",
            batteryLevel, ((isLow)?(@"YES"):(@"NO")));
}

- (void)wiimoteDevice:(WiimoteDevice*)device extensionConnected:(WiimoteDeviceExtension*)extension
{
	NSLog(@"Connected");
}

- (void)wiimoteDevice:(WiimoteDevice*)device extensionDisconnected:(WiimoteDeviceExtension*)extension
{
	NSLog(@"Disconnected");
}

- (void)wiimoteDeviceDisconnected:(WiimoteDevice*)device
{
    m_Device = nil;
    NSLog(@"Disconnected");
}

@end

int main (int argc, const char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    Test              *t    = [[[Test alloc] init] autorelease];

    [t run];
    [pool release];
    return 0;
}
