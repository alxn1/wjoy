//
//  WiimoteEventDispatcher+Nunchuck.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher.h"
#import "WiimoteNunchuckDelegate.h"

@interface WiimoteEventDispatcher (Nunchuck)

- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button;
- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button;
- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position;
- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerEnabledStateChanged:(BOOL)enabled;
- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerChangedGravityX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerChangedPitch:(CGFloat)pitch roll:(CGFloat)roll;

@end
