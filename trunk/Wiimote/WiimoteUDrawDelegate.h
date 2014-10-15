//
//  WiimoteUDrawDelegate.h
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *WiimoteUDrawPenPressedNotification;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenReleasedNotification;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenPositionChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenButtonPressedNotification;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenButtonReleasedNotification;

FOUNDATION_EXPORT NSString *WiimoteUDrawPenPositionKey;
FOUNDATION_EXPORT NSString *WiimoteUDrawPenPressureKey;

@class Wiimote;
@class WiimoteExtension;

@protocol WiimoteUDrawProtocol

- (BOOL)isPenPressed;
- (NSPoint)penPosition;
- (CGFloat)penPressure;
- (BOOL)isPenButtonPressed;

@end

typedef WiimoteExtension<WiimoteUDrawProtocol> WiimoteUDrawExtension;

@interface NSObject (WiimoteUDrawDelegate)

- (void)        wiimote:(Wiimote*)wiimote
        uDrawPenPressed:(WiimoteUDrawExtension*)uDraw;

- (void)        wiimote:(Wiimote*)wiimote
       uDrawPenReleased:(WiimoteUDrawExtension*)uDraw;

- (void)        wiimote:(Wiimote*)wiimote
                  uDraw:(WiimoteUDrawExtension*)uDraw
     penPositionChanged:(NSPoint)position
               pressure:(CGFloat)pressure;

- (void)        wiimote:(Wiimote*)wiimote
  uDrawPenButtonPressed:(WiimoteUDrawExtension*)uDraw;

- (void)        wiimote:(Wiimote*)wiimote
 uDrawPenButtonReleased:(WiimoteUDrawExtension*)uDraw;

@end
