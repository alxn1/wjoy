//
//  Wiimote.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDelegate.h"
#import "WiimoteExtension.h"
#import "WiimoteWatchdog.h"

FOUNDATION_EXPORT NSString *WiimoteBeginDiscoveryNotification;
FOUNDATION_EXPORT NSString *WiimoteEndDiscoveryNotification;

// internal classes
@class WiimotePart;
@class WiimoteLEDPart;
@class WiimoteButtonPart;
@class WiimoteBatteryPart;
@class WiimoteVibrationPart;
@class WiimoteExtensionPart;
@class WiimotePartSet;
@class WiimoteDevice;

@interface Wiimote : NSObject
{
	@private
		WiimoteDevice           *m_Device;
        WiimotePartSet          *m_PartSet;

        WiimoteLEDPart          *m_LEDPart;
        WiimoteButtonPart       *m_ButtonPart;
        WiimoteBatteryPart      *m_BatteryPart;
        WiimoteVibrationPart    *m_VibrationPart;
        WiimoteExtensionPart    *m_ExtensionPart;

		NSDictionary            *m_UserInfo;
}

+ (NSNotificationCenter*)notificationCenter;

+ (BOOL)isBluetoothEnabled;

+ (BOOL)isDiscovering;
+ (BOOL)beginDiscovery;

+ (NSArray*)connectedDevices;

- (BOOL)isConnected;
- (void)disconnect;

- (NSData*)address;
- (NSString*)addressString;

- (void)playConnectEffect;

// or'ed WiimoteLED flags
- (NSUInteger)highlightedLEDMask;
- (void)setHighlightedLEDMask:(NSUInteger)mask;

- (BOOL)isVibrationEnabled;
- (void)setVibrationEnabled:(BOOL)enabled;

- (BOOL)isButtonPressed:(WiimoteButtonType)button;

// 0.0 - 100.0 %, or -1 if undefined
- (double)batteryLevel;
- (BOOL)isBatteryLevelLow;

- (WiimoteExtension*)connectedExtension;
- (void)disconnectExtension;

- (void)requestUpdateState;
- (void)deviceConfigurationChanged;

// disable all notifications, except begin/end discovery,
// battery level, extensions connect/disconnec and wiimote connect/disconnect
- (BOOL)isStateChangeNotificationsEnabled;
- (void)setStateChangeNotificationsEnabled:(BOOL)enabled;

- (NSDictionary*)userInfo;
- (void)setUserInfo:(NSDictionary*)userInfo;

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (WiimotePart*)partWithClass:(Class)cls;

@end
