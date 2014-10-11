//
//  WiimoteEventDispatcher+UDraw.m
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import "WiimoteEventDispatcher+UDraw.h"

@implementation WiimoteEventDispatcher (UDraw)

- (void)postUDrawStateChanged:(WiimoteUDrawExtension*)uDraw
                  penTouching:(BOOL)touching
                  penPosition:(NSPoint)position
                  penPressure:(CGFloat)pressure
{
    [[self delegate] wiimote:[self owner]
           uDrawStateChanged:uDraw
                 penTouching:touching
                 penPosition:position
                 penPressure:pressure];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSValue valueWithPoint:position],      WiimoteUDrawPenPositionKey,
                                    [NSNumber numberWithBool:touching],     WiimoteUDrawPenTouchingKey,
                                    [NSNumber numberWithDouble:pressure],   WiimoteUDrawPenPressureKey,
                                    nil];

        [self postNotification:WiimoteUDrawPenStateChangedNotification
                        params:params];
    }
}

- (void)postUDrawButtonPressed:(WiimoteUDrawExtension*)uDraw
{
    [[self delegate] wiimote:[self owner] uDrawButtonPressed:uDraw];

    if([self isStateNotificationsEnabled])
        [self postNotification:WiimoteUDrawPenButtonPressedNotification];
}

- (void)postUDrawButtonReleased:(WiimoteUDrawExtension*)uDraw
{
    [[self delegate] wiimote:[self owner] uDrawButtonReleased:uDraw];

    if([self isStateNotificationsEnabled])
        [self postNotification:WiimoteUDrawPenButtonReleasedNotification];
}

@end
