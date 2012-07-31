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

@class WiimotePart;
@class WiimotePartSet;
@class WiimoteDevice;

@interface Wiimote : NSObject
{
	@private
		WiimoteDevice		*m_Device;
        WiimotePartSet      *m_Parts;
		NSDictionary		*m_UserInfo;
}

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

- (double)batteryLevel; // 0.0 - 100.0 %, or -1 if undefined
- (BOOL)isBatteryLevelLow;

- (WiimoteExtension*)connectedExtension;

- (void)requestUpdateState;
- (void)deviceConfigurationChanged;

// disable all notifications, except begin/end discovery, battery level and connect/disconnect
- (BOOL)isStateChangeNotificationsEnabled;
- (void)setStateChangeNotificationsEnabled:(BOOL)enabled;

- (NSDictionary*)userInfo;
- (void)setUserInfo:(NSDictionary*)userInfo;

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (WiimotePart*)partWithClass:(Class)cls;

@end
