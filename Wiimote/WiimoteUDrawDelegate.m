//
//  WiimoteUDrawDelegate.m
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import "WiimoteUDrawDelegate.h"

NSString *WiimoteUDrawPenStateChangedNotification   = @"WiimoteUDrawPenStateChangedNotification";
NSString *WiimoteUDrawPenButtonPressedNotification  = @"WiimoteUDrawPenButtonPressedNotification";
NSString *WiimoteUDrawPenButtonReleasedNotification = @"WiimoteUDrawPenButtonReleasedNotification";

NSString *WiimoteUDrawPenTouchingKey                = @"WiimoteUDrawPenTouchingKey";
NSString *WiimoteUDrawPenPositionKey                = @"WiimoteUDrawPenPositionKey";
NSString *WiimoteUDrawPenPressureKey                = @"WiimoteUDrawPenPressureKey";

@implementation NSObject (WiimoteUDrawDelegate)

- (void)     wiimote:(Wiimote*)wiimote
   uDrawStateChanged:(WiimoteUDrawExtension*)uDraw
         penTouching:(BOOL)touching
         penPosition:(NSPoint)position
         penPressure:(CGFloat)pressure
{
}

- (void)     wiimote:(Wiimote*)wiimote
  uDrawButtonPressed:(WiimoteUDrawExtension*)uDraw
{
}

- (void)     wiimote:(Wiimote*)wiimote
 uDrawButtonReleased:(WiimoteUDrawExtension*)uDraw
{
}

@end
