//
//  WiimoteEventDispatcher+UDraw.h
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import "WiimoteEventDispatcher.h"
#import "WiimoteUDrawDelegate.h"

@interface WiimoteEventDispatcher (UDraw)

- (void)postUDrawPenPressed:(WiimoteUDrawExtension*)uDraw;
- (void)postUDrawPenReleased:(WiimoteUDrawExtension*)uDraw;

-   (void)postUDraw:(WiimoteUDrawExtension*)uDraw
 penPositionChanged:(NSPoint)position
           pressure:(CGFloat)pressure;

- (void)postUDrawPenButtonPressed:(WiimoteUDrawExtension*)uDraw;
- (void)postUDrawPenButtonReleased:(WiimoteUDrawExtension*)uDraw;

@end
