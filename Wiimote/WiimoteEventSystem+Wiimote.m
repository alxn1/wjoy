//
//  WiimoteEventSystem+Wiimote.m
//  Wiimote
//
//  Created by alxn1 on 10.03.14.
//

#import "WiimoteEventSystem+Wiimote.h"

@implementation WiimoteEventSystem (Wiimote)

+ (void)load
{
    [WiimoteEventSystem
            registerNotification:WiimoteConnectedNotification
                        selector:@selector(wiimoteConnectedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteExtensionConnectedNotification
                        selector:@selector(wiimoteExtensionConnectedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteExtensionDisconnectedNotification
                        selector:@selector(wiimoteExtensionDisconnectedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteDisconnectedNotification
                        selector:@selector(wiimoteDisconnectedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteButtonPresedNotification
                        selector:@selector(wiimoteButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteButtonReleasedNotification
                        selector:@selector(wiimoteButtonReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteAccelerometerAnglesChangedNotification
                        selector:@selector(wiimoteAccelerometerAnglesChangedNotification:)];
}

- (NSString*)pathForWiimoteButton:(NSDictionary*)userInfo
{
    static NSString *result[] =
    {
        @"Button.Left",
        @"Button.Right",
        @"Button.Up",
        @"Button.Down",
        @"Button.A",
        @"Button.B",
        @"Button.Plus",
        @"Button.Minus",
        @"Button.Home",
        @"Button.One",
        @"Button.Two"
    };

    WiimoteButtonType type = [[userInfo objectForKey:WiimoteButtonKey] integerValue];

    return result[type];
}

- (void)wiimoteConnectedNotification:(NSNotification*)notification
{
    [self postEventForWiimote:[notification object]
                         path:@"Connect"
                        value:WIIMOTE_EVENT_VALUE_CONNECT];
}

- (void)wiimoteExtensionConnectedNotification:(NSNotification*)notification
{
    WiimoteExtension *extension = [[notification userInfo] objectForKey:WiimoteExtensionKey];

    [self postEventForWiimoteExtension:extension
                                  path:@"Connect"
                                 value:WIIMOTE_EVENT_VALUE_CONNECT];
}

- (void)wiimoteExtensionDisconnectedNotification:(NSNotification*)notification
{
    WiimoteExtension *extension = [[notification userInfo] objectForKey:WiimoteExtensionKey];

    [self postEventForWiimoteExtension:extension
                                  path:@"Disconnect"
                                 value:WIIMOTE_EVENT_VALUE_DISCONNECT];
}

- (void)wiimoteDisconnectedNotification:(NSNotification*)notification
{
    [self postEventForWiimote:[notification object]
                         path:@"Disconnect"
                        value:WIIMOTE_EVENT_VALUE_DISCONNECT];
}

- (void)wiimoteButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimote:[notification object]
                         path:[self pathForWiimoteButton:[notification userInfo]]
                        value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimote:[notification object]
                         path:[self pathForWiimoteButton:[notification userInfo]]
                        value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)wiimoteAccelerometerAnglesChangedNotification:(NSNotification*)notification
{
    CGFloat pitch = [[[notification userInfo] objectForKey:WiimoteAccelerometerPitchKey] doubleValue];
    CGFloat roll  = [[[notification userInfo] objectForKey:WiimoteAccelerometerRollKey] doubleValue];

    [self postEventForWiimote:[notification object] path:@"Accelerometer.Pitch" value:pitch];
    [self postEventForWiimote:[notification object] path:@"Accelerometer.Roll" value:roll];
}

@end
