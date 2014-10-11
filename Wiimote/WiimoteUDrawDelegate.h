//
//  WiimoteUDrawDelegate.h
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *WiimoteUDrawPenStateChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenButtonPressedNotification;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenButtonReleasedNotification;

FOUNDATION_EXPORT NSString *WiimoteUDrawPenTouchingKey;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenPositionKey;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenPressureKey;

@class Wiimote;
@class WiimoteExtension;

@protocol WiimoteUDrawProtocol

- (BOOL)isPenTouching;
- (NSPoint)penPosition;
- (CGFloat)penPressure;
- (BOOL)isPenButtonPressed;

@end

typedef WiimoteExtension<WiimoteUDrawProtocol> WiimoteUDrawExtension;

@interface NSObject (WiimoteUDrawDelegate)

- (void)     wiimote:(Wiimote*)wiimote
   uDrawStateChanged:(WiimoteUDrawExtension*)uDraw
         penTouching:(BOOL)touching
         penPosition:(NSPoint)position
         penPressure:(CGFloat)pressure;

- (void)     wiimote:(Wiimote*)wiimote
  uDrawButtonPressed:(WiimoteUDrawExtension*)uDraw;

- (void)     wiimote:(Wiimote*)wiimote
 uDrawButtonReleased:(WiimoteUDrawExtension*)uDraw;

@end
