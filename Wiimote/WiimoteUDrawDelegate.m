//
//  WiimoteUDrawDelegate.m
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import "WiimoteUDrawDelegate.h"

NSString *WiimoteUDrawPenPressedNotification            = @"WiimoteUDrawPenPressedNotification";
NSString *WiimoteUDrawPenReleasedNotification           = @"WiimoteUDrawPenReleasedNotification";
NSString *WiimoteUDrawPenPositionChangedNotification    = @"WiimoteUDrawPenPositionChangedNotification";
NSString *WiimoteUDrawPenButtonPressedNotification      = @"WiimoteUDrawPenButtonPressedNotification";
NSString *WiimoteUDrawPenButtonReleasedNotification     = @"WiimoteUDrawPenButtonReleasedNotification";

NSString *WiimoteUDrawPenPositionKey                    = @"WiimoteUDrawPenPositionKey";
NSString *WiimoteUDrawPenPressureKey                    = @"WiimoteUDrawPenPressureKey";

@implementation NSObject (WiimoteUDrawDelegate)

- (void)        wiimote:(Wiimote*)wiimote
        uDrawPenPressed:(WiimoteUDrawExtension*)uDraw
{
}

- (void)        wiimote:(Wiimote*)wiimote
       uDrawPenReleased:(WiimoteUDrawExtension*)uDraw
{
}

- (void)        wiimote:(Wiimote*)wiimote
                  uDraw:(WiimoteUDrawExtension*)uDraw
     penPositionChanged:(NSPoint)position
               pressure:(CGFloat)pressure
{
}

- (void)        wiimote:(Wiimote*)wiimote
  uDrawPenButtonPressed:(WiimoteUDrawExtension*)uDraw
{
}

- (void)        wiimote:(Wiimote*)wiimote
 uDrawPenButtonReleased:(WiimoteUDrawExtension*)uDraw
{
}

@end
