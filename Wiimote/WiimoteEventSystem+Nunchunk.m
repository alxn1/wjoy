//
//  WiimoteEventSystem+Nunchunk.m
//  Wiimote
//
//  Created by alxn1 on 10.03.14.
//
//

#import "WiimoteEventSystem+Nunchunk.h"

@implementation WiimoteEventSystem (Nunchunk)

+ (void)load
{
    [WiimoteEventSystem
            registerNotification:WiimoteNunchuckButtonPressedNotification
                        selector:@selector(wiimoteNunchuckButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteNunchuckButtonReleasedNotification
                        selector:@selector(wiimoteNunchuckButtonReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteNunchuckStickPositionChangedNotification
                        selector:@selector(wiimoteNunchuckStickPositionChangedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteNunchuckAccelerometerAnglesChangedNotification
                        selector:@selector(wiimoteNunchuckAccelerometerAnglesChangedNotification:)];
}

- (NSString*)pathForNunchuckButton:(NSDictionary*)userInfo
{
    static NSString *result[] =
    {
        @"Button.C",
        @"Button.Z"
    };

    WiimoteNunchuckButtonType type = [[userInfo objectForKey:WiimoteNunchuckButtonKey] integerValue];

    return result[type];
}

- (void)wiimoteNunchuckButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExceptions:[notification object]
                                   path:[self pathForNunchuckButton:[notification userInfo]]
                                  value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteNunchuckButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExceptions:[notification object]
                                   path:[self pathForNunchuckButton:[notification userInfo]]
                                  value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)wiimoteNunchuckStickPositionChangedNotification:(NSNotification*)notification
{
    NSPoint position = [[[notification userInfo] objectForKey:WiimoteNunchuckStickPositionKey] pointValue];

    [self postEventForWiimoteExceptions:[notification object]
                                   path:@"Stick.X"
                                  value:position.x];

    [self postEventForWiimoteExceptions:[notification object]
                                   path:@"Stick.Y"
                                  value:position.y];
}

- (void)wiimoteNunchuckAccelerometerAnglesChangedNotification:(NSNotification*)notification
{
    CGFloat pitch = [[[notification userInfo] objectForKey:WiimoteNunchuckAccelerometerPitchKey] doubleValue];
    CGFloat roll  = [[[notification userInfo] objectForKey:WiimoteNunchuckAccelerometerRollKey] doubleValue];

    [self postEventForWiimoteExceptions:[notification object] path:@"Accelerometer.Pitch" value:pitch];
    [self postEventForWiimoteExceptions:[notification object] path:@"Accelerometer.Roll" value:roll];
}

@end
