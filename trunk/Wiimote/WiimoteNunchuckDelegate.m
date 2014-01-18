//
//  WiimoteNunchuckDelegate.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteNunchuckDelegate.h"

NSString *WiimoteNunchuckButtonPressedNotification                      = @"WiimoteNunchuckButtonPressedNotification";
NSString *WiimoteNunchuckButtonReleasedNotification                     = @"WiimoteNunchuckButtonReleasedNotification";
NSString *WiimoteNunchuckStickPositionChangedNotification               = @"WiimoteNunchuckStickPositionChangedNotification";
NSString *WiimoteNunchuckAccelerometerEnabledStateChangedNotification   = @"WiimoteNunchuckAccelerometerEnabledStateChangedNotification";
NSString *WiimoteNunchuckAccelerometerGravityChangedNotification        = @"WiimoteNunchuckAccelerometerGravityChangedNotification";
NSString *WiimoteNunchuckAccelerometerAnglesChangedNotification         = @"WiimoteNunchuckAccelerometerAnglesChangedNotification";

NSString *WiimoteNunchuckButtonKey                                      = @"WiimoteNunchuckButtonKey";
NSString *WiimoteNunchuckStickPositionKey                               = @"WiimoteNunchuckStickPositionKey";
NSString *WiimoteNunchuckAccelerometerEnabledStateKey                   = @"WiimoteNunchuckAccelerometerEnabledStateKey";
NSString *WiimoteNunchuckAccelerometerGravityXKey                       = @"WiimoteNunchuckAccelerometerGravityXKey";
NSString *WiimoteNunchuckAccelerometerGravityYKey                       = @"WiimoteNunchuckAccelerometerGravityYKey";
NSString *WiimoteNunchuckAccelerometerGravityZKey                       = @"WiimoteNunchuckAccelerometerGravityZKey";
NSString *WiimoteNunchuckAccelerometerPitchKey                          = @"WiimoteNunchuckAccelerometerPitchKey";
NSString *WiimoteNunchuckAccelerometerRollKey                           = @"WiimoteNunchuckAccelerometerRollKey";

@implementation NSObject (WiimoteNunchuckDelegate)

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button
{
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button
{
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position
{
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerEnabledStateChanged:(BOOL)enabled
{
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerChangedGravityX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerChangedPitch:(CGFloat)pitch roll:(CGFloat)roll
{
}

@end
