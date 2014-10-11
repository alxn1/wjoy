//
//  WiimoteEventSystem+ClassicController.m
//  Wiimote
//
//  Created by alxn1 on 10.03.14.
//

#import "WiimoteEventSystem+ClassicController.h"

@implementation WiimoteEventSystem (ClassicController)

+ (void)load
{
    [WiimoteEventSystem
            registerNotification:WiimoteClassicControllerButtonPressedNotification
                        selector:@selector(wiimoteClassicControllerButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteClassicControllerButtonReleasedNotification
                        selector:@selector(wiimoteClassicControllerButtonReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteClassicControllerStickPositionChangedNotification
                        selector:@selector(wiimoteClassicControllerStickPositionChangedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteClassicControllerAnalogShiftPositionChangedNotification
                        selector:@selector(wiimoteClassicControllerAnalogShiftPositionChangedNotification:)];
}

- (NSString*)pathForClassicControllerButton:(NSDictionary*)userInfo
{
    static NSString *result[] =
    {
        @"Button.A",
        @"Button.B",
        @"Button.Minus",
        @"Button.Home",
        @"Button.Plus",
        @"Button.X",
        @"Button.Y",
        @"Button.Up",
        @"Button.Down",
        @"Button.Left",
        @"Button.Right",
        @"Button.L",
        @"Button.R",
        @"Button.ZL",
        @"Button.ZR"
    };

    WiimoteClassicControllerButtonType type = [[userInfo objectForKey:WiimoteClassicControllerButtonKey] integerValue];

    return result[type];
}

- (void)wiimoteClassicControllerButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExtension:[notification object]
                                  path:[self pathForClassicControllerButton:[notification userInfo]]
                                 value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteClassicControllerButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExtension:[notification object]
                                  path:[self pathForClassicControllerButton:[notification userInfo]]
                                 value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)wiimoteClassicControllerStickPositionChangedNotification:(NSNotification*)notification
{
    WiimoteClassicControllerStickType type      = [[[notification userInfo] objectForKey:WiimoteClassicControllerStickKey] integerValue];
    NSPoint                           position  = [[[notification userInfo] objectForKey:WiimoteClassicControllerStickPositionKey] pointValue];

    switch(type) {
        case WiimoteClassicControllerStickTypeLeft: {
            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Left.Stick.X"
                                         value:position.x];

            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Left.Stick.Y"
                                         value:position.y];
            break;
        }

        case WiimoteClassicControllerStickTypeRight: {
            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Right.Stick.X"
                                         value:position.x];

            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Right.Stick.Y"
                                         value:position.y];
            break;
        }
    }
}

- (void)wiimoteClassicControllerAnalogShiftPositionChangedNotification:(NSNotification*)notification
{
    WiimoteClassicControllerAnalogShiftType type        = [[[notification userInfo] objectForKey:WiimoteClassicControllerAnalogShiftKey] integerValue];
    CGFloat                                 position    = [[[notification userInfo] objectForKey:WiimoteClassicControllerAnalogShiftPositionKey] doubleValue];

    switch(type) {
        case WiimoteClassicControllerStickTypeLeft: {
            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Left.Shift"
                                         value:position];
            break;
        }

        case WiimoteClassicControllerStickTypeRight: {
            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Right.Shift"
                                         value:position];
            break;
        }
    }
}

@end
