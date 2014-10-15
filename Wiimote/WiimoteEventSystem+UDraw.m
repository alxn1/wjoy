//
//  WiimoteEventSystem+UDraw.m
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import "WiimoteEventSystem+UDraw.h"

@implementation WiimoteEventSystem (UDraw)

+ (void)load
{
    [WiimoteEventSystem
            registerNotification:WiimoteUDrawPenPressedNotification
                        selector:@selector(wiimoteUDrawPenPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUDrawPenReleasedNotification
                        selector:@selector(wiimoteUDrawPenReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUDrawPenPositionChangedNotification
                        selector:@selector(wiimoteUDrawPenPositionChangedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUDrawPenButtonPressedNotification
                        selector:@selector(wiimoteUDrawPenButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUDrawPenButtonReleasedNotification
                        selector:@selector(wiimoteUDrawPenButtonReleasedNotification:)];
}

- (void)WiimoteUDrawPenPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExtension:[notification object]
                                  path:@"Pen"
                                 value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)WiimoteUDrawPenReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExtension:[notification object]
                                  path:@"Pen"
                                 value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)WiimoteUDrawPenPositionChangedNotification:(NSNotification*)notification
{
    NSPoint position = [[[notification userInfo] objectForKey:WiimoteUDrawPenPositionKey] pointValue];
    CGFloat pressure = [[[notification userInfo] objectForKey:WiimoteUDrawPenPressureKey] doubleValue];

    [self postEventForWiimoteExtension:[notification object] path:@"Pen.Position.X" value:position.x];
    [self postEventForWiimoteExtension:[notification object] path:@"Pen.Position.Y" value:position.y];
    [self postEventForWiimoteExtension:[notification object] path:@"Pen.Pressure"   value:pressure];
}

- (void)wiimoteUDrawPenButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExtension:[notification object]
                                  path:@"Pen.Button"
                                 value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteUDrawPenButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExtension:[notification object]
                                  path:@"Pen.Button"
                                 value:WIIMOTE_EVENT_VALUE_RELEASE];
}

@end
