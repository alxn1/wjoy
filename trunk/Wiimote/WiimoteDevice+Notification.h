//
//  WiimoteDevice+Notification.h
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"

@interface WiimoteDevice (Notification)

+ (void)onBeginDiscovery;
+ (void)onEndDiscovery;

- (void)onConnected;
- (void)onButtonPressed:(WiimoteButtonType)button;
- (void)onButtonReleased:(WiimoteButtonType)button;
- (void)onHighlightedLEDMaskChanged:(NSUInteger)mask;
- (void)onVibrationStateChanged:(BOOL)isVibrationEnabled;
- (void)onBatteryLevelUpdated:(double)batteryLevel isLow:(BOOL)isLow;
- (void)onExtensionConnected:(WiimoteDeviceExtension*)extension;
- (void)onExtensionDisconnected:(WiimoteDeviceExtension*)extension;
- (void)onDisconnected;

- (void)setButton:(WiimoteButtonType)button pressed:(BOOL)pressed;

@end
