//
//  WiimoteEventDispatcher+UDraw.m
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import "WiimoteEventDispatcher+UDraw.h"

@implementation WiimoteEventDispatcher (UDraw)

- (void)postUDrawPenPressed:(WiimoteUDrawExtension*)uDraw
{
    [[self delegate] wiimote:[self owner] uDrawPenPressed:uDraw];

    if([self isStateNotificationsEnabled])
        [self postNotification:WiimoteUDrawPenPressedNotification];
}

- (void)postUDrawPenReleased:(WiimoteUDrawExtension*)uDraw
{
    [[self delegate] wiimote:[self owner] uDrawPenReleased:uDraw];

    if([self isStateNotificationsEnabled])
        [self postNotification:WiimoteUDrawPenReleasedNotification];
}

-   (void)postUDraw:(WiimoteUDrawExtension*)uDraw
 penPositionChanged:(NSPoint)position
           pressure:(CGFloat)pressure
{
    [[self delegate]
                wiimote:[self owner]
                  uDraw:uDraw
     penPositionChanged:position
               pressure:pressure];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSValue valueWithPoint:position],      WiimoteUDrawPenPositionKey,
                                    [NSNumber numberWithDouble:pressure],   WiimoteUDrawPenPressureKey,
                                    nil];

        [self postNotification:WiimoteUDrawPenPositionChangedNotification
                        params:params];
    }
}

- (void)postUDrawPenButtonPressed:(WiimoteUDrawExtension*)uDraw
{
    [[self delegate] wiimote:[self owner] uDrawPenButtonPressed:uDraw];

    if([self isStateNotificationsEnabled])
        [self postNotification:WiimoteUDrawPenButtonPressedNotification];
}

- (void)postUDrawPenButtonReleased:(WiimoteUDrawExtension*)uDraw
{
    [[self delegate] wiimote:[self owner] uDrawPenButtonReleased:uDraw];

    if([self isStateNotificationsEnabled])
        [self postNotification:WiimoteUDrawPenButtonReleasedNotification];
}

@end
