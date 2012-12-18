//
//  WiimoteDelegate.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDelegate.h"

NSString *WiimoteConnectedNotification                              = @"WiimoteConnectedNotification";
NSString *WiimoteDisconnectedNotification                           = @"WiimoteDisconnectedNotification";
NSString *WiimoteButtonPresedNotification                           = @"WiimoteButtonPresedNotification";
NSString *WiimoteButtonReleasedNotification                         = @"WiimoteButtonReleasedNotification";
NSString *WiimoteVibrationStateChangedNotification                  = @"WiimoteVibrationStateChangedNotification";
NSString *WiimoteHighlightedLEDMaskChangedNotification              = @"WiimoteHighlightedLEDMaskChangedNotification";
NSString *WiimoteBatteryLevelUpdatedNotification                    = @"WiimoteBatteryLevelUpdatedNotification";
NSString *WiimoteIREnabledStateChangedNotification                  = @"WiimoteIREnabledStateChangedNotification";
NSString *WiimoteIRPointPositionChangedNotification                 = @"WiimoteIRPointPositionChangedNotification";
NSString *WiimoteAccelerometerEnabledStateChangedNotification       = @"WiimoteAccelerometerEnabledStateChangedNotification";
NSString *WiimoteAccelerometerGravityChangedNotification            = @"WiimoteAccelerometerGravityChangedNotification";
NSString *WiimoteAccelerometerAnglesChangedNotification				= @"WiimoteAccelerometerAnglesChangedNotification";
NSString *WiimoteExtensionConnectedNotification                     = @"WiimoteExtensionConnectedNotification";
NSString *WiimoteExtensionDisconnectedNotification                  = @"WiimoteExtensionDisconnectedNotification";

NSString *WiimoteButtonKey                                          = @"WiimoteButtonKey";
NSString *WiimoteVibrationStateKey                                  = @"WiimoteVibrationStateKey";
NSString *WiimoteHighlightedLEDMaskKey                              = @"WiimoteHighlightedLEDMaskKey";
NSString *WiimoteBatteryLevelKey                                    = @"WiimoteBatteryLevelKey";
NSString *WiimoteIsBatteryLevelLowKey                               = @"WiimoteIsBatteryLevelLowKey";
NSString *WiimoteIREnabledStateKey                                  = @"WiimoteIREnabledStateKey";
NSString *WiimoteIRPointKey                                         = @"WiimoteIRPointKey";
NSString *WiimoteAccelerometerEnabledStateKey                       = @"WiimoteAccelerometerEnabledStateKey";
NSString *WiimoteAccelerometerGravityXKey                           = @"WiimoteAccelerometerGravityXKey";
NSString *WiimoteAccelerometerGravityYKey                           = @"WiimoteAccelerometerGravityYKey";
NSString *WiimoteAccelerometerGravityZKey                           = @"WiimoteAccelerometerGravityZKey";
NSString *WiimoteAccelerometerPitchKey                              = @"WiimoteAccelerometerPitchKey";
NSString *WiimoteAccelerometerRollKey                               = @"WiimoteAccelerometerRollKey";
NSString *WiimoteExtensionKey                                       = @"WiimoteExtensionKey";

@implementation NSObject (WiimoteDelegate)

- (void)wiimote:(Wiimote*)wiimote buttonPressed:(WiimoteButtonType)button
{
}

- (void)wiimote:(Wiimote*)wiimote buttonReleased:(WiimoteButtonType)button
{
}

- (void)wiimote:(Wiimote*)wiimote vibrationStateChanged:(BOOL)isVibrationEnabled
{
}

- (void)wiimote:(Wiimote*)wiimote highlightedLEDMaskChanged:(NSUInteger)mask
{
}

- (void)wiimote:(Wiimote*)wiimote batteryLevelUpdated:(double)batteryLevel isLow:(BOOL)isLow
{
}

- (void)wiimote:(Wiimote*)wiimote irEnabledStateChanged:(BOOL)enabled
{
}

- (void)wiimote:(Wiimote*)wiimote irPointPositionChanged:(WiimoteIRPoint*)point
{
}

- (void)wiimote:(Wiimote*)wiimote accelerometerEnabledStateChanged:(BOOL)enabled
{
}

- (void)wiimote:(Wiimote*)wiimote accelerometerChangedGravityX:(double)x y:(double)y z:(double)z
{
}

- (void)wiimote:(Wiimote*)wiimote accelerometerChangedPitch:(double)pitch roll:(double)roll
{
}

- (void)wiimote:(Wiimote*)wiimote extensionConnected:(WiimoteExtension*)extension
{
}

- (void)wiimote:(Wiimote*)wiimote extensionDisconnected:(WiimoteExtension*)extension
{
}

- (void)wiimoteDisconnected:(Wiimote*)wiimote
{
}

@end
