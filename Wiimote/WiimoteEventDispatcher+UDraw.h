//
//  WiimoteEventDispatcher+UDraw.h
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import "WiimoteEventDispatcher.h"
#import "WiimoteUDrawDelegate.h"

@interface WiimoteEventDispatcher (UDraw)

- (void)postUDrawStateChanged:(WiimoteUDrawExtension*)uDraw
                  penTouching:(BOOL)touching
                  penPosition:(NSPoint)position
                  penPressure:(CGFloat)pressure;

- (void)postUDrawButtonPressed:(WiimoteUDrawExtension*)uDraw;
- (void)postUDrawButtonReleased:(WiimoteUDrawExtension*)uDraw;

@end
