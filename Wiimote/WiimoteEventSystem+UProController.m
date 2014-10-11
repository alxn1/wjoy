//
//  WiimoteEventSystem+UProController.m
//  Wiimote
//
//  Created by alxn1 on 10.03.14.
//

#import "WiimoteEventSystem+UProController.h"

@implementation WiimoteEventSystem (UProController)

+ (void)load
{
    [WiimoteEventSystem
            registerNotification:WiimoteUProControllerButtonPressedNotification
                        selector:@selector(wiimoteUProControllerButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUProControllerButtonReleasedNotification
                        selector:@selector(wiimoteUProControllerButtonReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUProControllerStickPositionChangedNotification
                        selector:@selector(wiimoteUProControllerStickPositionChangedNotification:)];
}

- (NSString*)pathForWiiUProControllerButton:(NSDictionary*)userInfo
{
    static NSString *result[] =
    {
        @"Button.Up",
        @"Button.Down",
        @"Button.Left",
        @"Button.Right",
        @"Button.A",
        @"Button.B",
        @"Button.X",
        @"Button.Y",
        @"Button.L",
        @"Button.R",
        @"Button.ZL",
        @"Button.ZR",
        @"Button.Left.Stick",
        @"Button.Right.Stick"
    };

    WiimoteUProControllerButtonType type = [[userInfo objectForKey:WiimoteUProControllerButtonKey] integerValue];

    return result[type];
}

- (void)wiimoteUProControllerButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExtension:[notification object]
                                  path:[self pathForWiiUProControllerButton:[notification userInfo]]
                                 value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteUProControllerButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExtension:[notification object]
                                  path:[self pathForWiiUProControllerButton:[notification userInfo]]
                                 value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)wiimoteUProControllerStickPositionChangedNotification:(NSNotification*)notification
{
    WiimoteUProControllerStickType  type      = [[[notification userInfo] objectForKey:WiimoteUProControllerStickKey] integerValue];
    NSPoint                         position  = [[[notification userInfo] objectForKey:WiimoteUProControllerStickPositionKey] pointValue];

    switch(type) {
        case WiimoteUProControllerStickTypeLeft:
            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Left.Stick.X"
                                         value:position.x];

            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Left.Stick.Y"
                                         value:position.y];
            break;

        case WiimoteUProControllerStickTypeRight:
            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Right.Stick.X"
                                         value:position.x];

            [self postEventForWiimoteExtension:[notification object]
                                          path:@"Right.Stick.Y"
                                         value:position.y];
            break;
    }
}

@end
