//
//  Wiimote.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import <Wiimote/WiimoteDelegate.h>
#import <Wiimote/WiimoteExtension.h>
#import <Wiimote/WiimoteAccelerometer.h>
#import <Wiimote/WiimoteWatchdog.h>

FOUNDATION_EXPORT NSString *WiimoteBeginDiscoveryNotification;
FOUNDATION_EXPORT NSString *WiimoteEndDiscoveryNotification;

FOUNDATION_EXPORT NSString *WiimoteUseOneButtonClickConnectionChangedNotification;

FOUNDATION_EXPORT NSString *WiimoteUseOneButtonClickConnectionKey;

@class WiimoteDevice;
@class WiimotePartSet;
@class WiimoteIRPart;
@class WiimoteLEDPart;
@class WiimoteButtonPart;
@class WiimoteBatteryPart;
@class WiimoteVibrationPart;
@class WiimoteAccelerometerPart;
@class WiimoteExtensionPart;

@interface Wiimote : NSObject
{
	@private
		WiimoteDevice               *m_Device;
        WiimotePartSet              *m_PartSet;
        NSString                    *m_ModelName;

        WiimoteIRPart               *m_IRPart;
        WiimoteLEDPart              *m_LEDPart;
        WiimoteButtonPart           *m_ButtonPart;
        WiimoteBatteryPart          *m_BatteryPart;
        WiimoteVibrationPart        *m_VibrationPart;
        WiimoteAccelerometerPart    *m_AccelerometerPart;
        WiimoteExtensionPart        *m_ExtensionPart;

		NSDictionary                *m_UserInfo;
}

+ (BOOL)isBluetoothEnabled;

+ (NSArray*)supportedModelNames;

+ (BOOL)isUseOneButtonClickConnection;
+ (void)setUseOneButtonClickConnection:(BOOL)useOneButtonClickConnection;

+ (BOOL)isDiscovering;
+ (BOOL)beginDiscovery;

+ (NSArray*)connectedDevices;

- (BOOL)isConnected;
- (void)disconnect;

- (BOOL)isWiiUProController;

- (NSData*)address;
- (NSString*)addressString;
- (NSString*)modelName;

- (void)playConnectEffect;

// or'ed WiimoteLED flags
- (NSUInteger)highlightedLEDMask;
- (void)setHighlightedLEDMask:(NSUInteger)mask;

- (BOOL)isVibrationEnabled;
- (void)setVibrationEnabled:(BOOL)enabled;

- (BOOL)isButtonPressed:(WiimoteButtonType)button;

// 0.0 - 100.0 %, or -1 if undefined
- (CGFloat)batteryLevel;
- (BOOL)isBatteryLevelLow;

- (BOOL)isIREnabled;
- (void)setIREnabled:(BOOL)enabled;

- (WiimoteIRPoint*)irPoint:(NSUInteger)index;

- (WiimoteAccelerometer*)accelerometer;

- (WiimoteExtension*)connectedExtension;

- (void)detectMotionPlus;
- (void)reconnectExtension;
- (void)disconnectExtension;

- (void)requestUpdateState;

// disable all notifications, except begin/end discovery,
// battery level, extensions connect/disconnect and wiimote connect/disconnect
- (BOOL)isStateChangeNotificationsEnabled;
- (void)setStateChangeNotificationsEnabled:(BOOL)enabled;

- (NSDictionary*)userInfo;
- (void)setUserInfo:(NSDictionary*)userInfo;

- (id)delegate;
- (void)setDelegate:(id)delegate;

@end
