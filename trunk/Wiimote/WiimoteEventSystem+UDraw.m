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
            registerNotification:WiimoteUDrawPenStateChangedNotification
                        selector:@selector(wiimoteUDrawPenStateChangedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUDrawPenButtonPressedNotification
                        selector:@selector(wiimoteUDrawPenButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUDrawPenButtonReleasedNotification
                        selector:@selector(wiimoteUDrawPenButtonReleasedNotification:)];
}

- (void)wiimoteUDrawPenStateChangedNotification:(NSNotification*)notification
{
    BOOL    touching = [[[notification userInfo] objectForKey:WiimoteUDrawPenTouchingKey] boolValue];
    NSPoint position = [[[notification userInfo] objectForKey:WiimoteUDrawPenPositionKey] pointValue];
    CGFloat pressure = [[[notification userInfo] objectForKey:WiimoteUDrawPenPressureKey] doubleValue];
    CGFloat touchingValue = ((touching)?
                (WIIMOTE_EVENT_VALUE_PRESS):(WIIMOTE_EVENT_VALUE_RELEASE));

    [self postEventForWiimoteExtension:[notification object] path:@"Pen.Touching"   value:touchingValue];
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
