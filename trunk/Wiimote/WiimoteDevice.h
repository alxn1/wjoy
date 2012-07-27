//
//  WiimoteDevice.h
//  Wiimote
//
//  Created by alxn1 on 25.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WiimoteButtonCount 11

typedef enum
{
    WiimoteButtonTypeLeft       =  0,
    WiimoteButtonTypeRight      =  1,
    WiimoteButtonTypeUp         =  2,
    WiimoteButtonTypeDown       =  3,
    WiimoteButtonTypeA          =  4,
    WiimoteButtonTypeB          =  5,
    WiimoteButtonTypePlus       =  6,
    WiimoteButtonTypeMinus      =  7,
    WiimoteButtonTypeHome       =  8,
    WiimoteButtonTypeOne        =  9,
    WiimoteButtonTypeTwo        = 10
} WiimoteButtonType;

typedef enum
{
    WiimoteLEDOne               =  1,
    WiimoteLEDTwo               =  2,
    WiimoteLEDThree             =  4,
    WiimoteLEDFour              =  8
} WiimoteLED;

FOUNDATION_EXPORT NSString *WiimoteDeviceBeginDiscoveryNotification;
FOUNDATION_EXPORT NSString *WiimoteDeviceEndDiscoveryNotification;

FOUNDATION_EXPORT NSString *WiimoteDeviceConnectedNotification;
FOUNDATION_EXPORT NSString *WiimoteDeviceButtonPresedNotification;
FOUNDATION_EXPORT NSString *WiimoteDeviceButtonReleasedNotification;
FOUNDATION_EXPORT NSString *WiimoteDeviceHighlightedLEDMaskChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteDeviceVibrationStateChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteDeviceBatteryLevelUpdatedNotification;
FOUNDATION_EXPORT NSString *WiimoteDeviceDisconnectedNotification;

FOUNDATION_EXPORT NSString *WiimoteDeviceButtonKey;
FOUNDATION_EXPORT NSString *WiimoteDeviceHighlightedLEDMaskKey;
FOUNDATION_EXPORT NSString *WiimoteDeviceVibrationStateKey;
FOUNDATION_EXPORT NSString *WiimoteDeviceBatteryLevelKey;
FOUNDATION_EXPORT NSString *WiimoteDeviceIsBatteryLevelLowKey;

@class IOBluetoothDevice;
@class IOBluetoothL2CAPChannel;
@class WiimoteDevice;

@protocol WiimoteDeviceDelegate

- (void)wiimoteDevice:(WiimoteDevice*)device buttonPressed:(WiimoteButtonType)button;
- (void)wiimoteDevice:(WiimoteDevice*)device buttonReleased:(WiimoteButtonType)button;
- (void)wiimoteDevice:(WiimoteDevice*)device highlightedLEDMaskChanged:(NSUInteger)mask;
- (void)wiimoteDevice:(WiimoteDevice*)device vibrationStateChanged:(BOOL)isVibrationEnabled;
- (void)wiimoteDevice:(WiimoteDevice*)device batteryLevelUpdated:(double)batteryLevel isLow:(BOOL)isLow;
- (void)wiimoteDeviceDisconnected:(WiimoteDevice*)device;

@end

@interface WiimoteDevice : NSObject
{
    @private
        IOBluetoothDevice           *m_Device;
        IOBluetoothL2CAPChannel     *m_DataChannel;
        IOBluetoothL2CAPChannel     *m_ControlChannel;

        BOOL                         m_IsStateChangeNotificationsEnabled;

        NSUInteger                   m_HighlightedLEDMask;
        BOOL                         m_IsVibrationEnabled;
        BOOL                         m_IsInitialiased;

        BOOL                         m_ButtonState[WiimoteButtonCount];

        double                       m_BatteryLevel;
        BOOL                         m_IsBatteryLevelLow;
        BOOL                         m_IsUpdateStateStarted;

        NSDictionary                *m_UserInfo;

        id<WiimoteDeviceDelegate>    m_Delegate;
}

+ (BOOL)isBluetoothEnabled;

+ (BOOL)isDiscovering;
+ (BOOL)beginDiscovery;

+ (NSArray*)connectedDevices;

- (BOOL)isConnected;
- (void)disconnect;

- (NSData*)address;
- (NSString*)addressString;

// or'ed WiimoteLED flags
- (NSUInteger)highlightedLEDMask;
- (void)setHighlightedLEDMask:(NSUInteger)mask;

- (BOOL)isVibrationEnabled;
- (void)setVibrationEnabled:(BOOL)enabled;

- (BOOL)isButtonPressed:(WiimoteButtonType)button;

- (double)batteryLevel; // 0.0 - 100.0 %, or -1 if undefined
- (BOOL)isBatteryLevelLow;
- (void)updateState;

// disable all notifications, except begin/end discovery and connect/disconnect
- (BOOL)isStateChangeNotificationsEnabled;
- (void)setStateChangeNotificationsEnabled:(BOOL)enabled;

- (NSDictionary*)userInfo;
- (void)setUserInfo:(NSDictionary*)userInfo;

- (id<WiimoteDeviceDelegate>)delegate;
- (void)setDelegate:(id<WiimoteDeviceDelegate>)delegate;

@end
