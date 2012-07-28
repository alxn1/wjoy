//
//  WiimoteDevice.m
//  Wiimote
//
//  Created by alxn1 on 25.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice+Hardware.h"
#import "WiimoteDevice+Extension.h"
#import "WiimoteDevice+Notification.h"
#import "WiimoteDevice+ConnectedTracking.h"

#import "WiimoteDeviceInquiry.h"

NSString *WiimoteDeviceBeginDiscoveryNotification               = @"WiimoteDeviceBeginDiscoveryNotification";
NSString *WiimoteDeviceEndDiscoveryNotification                 = @"WiimoteDeviceEndDiscoveryNotification";

NSString *WiimoteDeviceConnectedNotification                    = @"WiimoteDeviceConnectedNotification";
NSString *WiimoteDeviceButtonPresedNotification                 = @"WiimoteDeviceButtonPresedNotification";
NSString *WiimoteDeviceButtonReleasedNotification               = @"WiimoteDeviceButtonReleasedNotification";
NSString *WiimoteDeviceHighlightedLEDMaskChangedNotification    = @"WiimoteDeviceHighlightedLEDMaskChangedNotification";
NSString *WiimoteDeviceVibrationStateChangedNotification        = @"WiimoteDeviceVibrationStateChangedNotification";
NSString *WiimoteDeviceBatteryLevelUpdatedNotification          = @"WiimoteDeviceBatteryLevelUpdatedNotification";
NSString *WiimoteDeviceExtensionConnectedNotification			= @"WiimoteDeviceExtensionConnectedNotification";
NSString *WiimoteDeviceExtensionDisconnectedNotification			= @"WiimoteDeviceExtensionDisconnectedNotification";
NSString *WiimoteDeviceDisconnectedNotification                 = @"WiimoteDeviceDisconnectedNotification";

NSString *WiimoteDeviceButtonKey                                = @"WiimoteDeviceButtonKey";
NSString *WiimoteDeviceHighlightedLEDMaskKey                    = @"WiimoteDeviceHighlightedLEDMaskKey";
NSString *WiimoteDeviceVibrationStateKey                        = @"WiimoteDeviceVibrationStateKey";
NSString *WiimoteDeviceBatteryLevelKey                          = @"WiimoteDeviceBatteryLevelKey";
NSString *WiimoteDeviceIsBatteryLevelLowKey                     = @"WiimoteDeviceIsBatteryLevelLowKey";
NSString *WiimoteDeviceExtensionKey								= @"WiimoteDeviceExtensionKey";

@implementation WiimoteDevice

+ (BOOL)isBluetoothEnabled
{
    return [WiimoteDeviceInquiry isBluetoothEnabled];
}

+ (BOOL)isDiscovering
{
    return [[WiimoteDeviceInquiry sharedInquiry] isStarted];
}

+ (BOOL)beginDiscovery;
{
    if([[WiimoteDeviceInquiry sharedInquiry]
                                    startWithTarget:self
                                       didEndAction:@selector(onEndDiscovery)])
    {
        [self onBeginDiscovery];
        return YES;
    }

    return NO;
}

+ (NSArray*)connectedDevices
{
    return [WiimoteDevice allConnectedDevices];
}

- (BOOL)isConnected
{
    return (m_Device != nil);
}

- (void)disconnect
{
    if(![self isConnected])
        return;

    [m_ControlChannel setDelegate:nil];
	[m_DataChannel setDelegate:nil];

	[m_ControlChannel closeChannel];
	[m_DataChannel closeChannel];
	[m_Device closeConnection];

	[m_ControlChannel release];
	[m_DataChannel release];
	[m_Device release];

    m_IsUpdateStateStarted  = NO;
    m_BatteryLevel          = -1.0;
    m_IsBatteryLevelLow     = NO;
	m_ControlChannel        = nil;
	m_DataChannel           = nil;
	m_Device                = nil;

    m_HighlightedLEDMask    = 0;
    m_IsVibrationEnabled    = NO;

    memset(m_ButtonState, 0, sizeof(m_ButtonState));

    if(m_IsInitialiased)
    {
		[self releaseExtensionDevice];
        [self onDisconnected];
        [WiimoteDevice removeConnectedDevice:self];
    }
}

- (NSData*)address
{
    if(m_Device == nil)
        return nil;

    const BluetoothDeviceAddress *address = [m_Device getAddress];
    if(address == NULL)
        return nil;

    return [NSData dataWithBytes:address->data
                          length:sizeof(address->data)];
}

- (NSString*)addressString
{
    return [m_Device getAddressString];
}

- (NSUInteger)highlightedLEDMask
{
    return m_HighlightedLEDMask;
}

- (void)setHighlightedLEDMask:(NSUInteger)mask
{
    if(m_HighlightedLEDMask == mask)
        return;

    m_HighlightedLEDMask = mask;
    if(![self updateLEDStates])
    {
        [self disconnect];
        return;
    }

    [self onHighlightedLEDMaskChanged:m_HighlightedLEDMask];
}

- (BOOL)isVibrationEnabled
{
    return m_IsVibrationEnabled;
}

- (void)setVibrationEnabled:(BOOL)enabled
{
    if(m_IsVibrationEnabled == enabled)
        return;

    m_IsVibrationEnabled = enabled;

    // эта команда так же обновляет и состояние вибры :)
    if(![self updateLEDStates])
    {
        [self disconnect];
        return;
    }

    [self onVibrationStateChanged:m_IsVibrationEnabled];
}

- (BOOL)isButtonPressed:(WiimoteButtonType)button
{
    return m_ButtonState[button];
}

- (double)batteryLevel
{
    return m_BatteryLevel;
}

- (BOOL)isBatteryLevelLow
{
    return m_IsBatteryLevelLow;
}

- (void)updateState
{
    m_IsUpdateStateStarted = YES;
    if(![self beginUpdateState])
    {
        m_IsUpdateStateStarted = NO;
        [self disconnect];
    }
}

- (BOOL)isStateChangeNotificationsEnabled
{
    return m_IsStateChangeNotificationsEnabled;
}

- (void)setStateChangeNotificationsEnabled:(BOOL)enabled
{
    m_IsStateChangeNotificationsEnabled = enabled;
}

- (NSDictionary*)userInfo
{
    return [[m_UserInfo retain] autorelease];
}

- (void)setUserInfo:(NSDictionary*)userInfo
{
    if(m_UserInfo == userInfo)
        return;

    [m_UserInfo release];
    m_UserInfo = [userInfo retain];
}

- (id<WiimoteDeviceDelegate>)delegate
{
    return m_Delegate;
}

- (void)setDelegate:(id<WiimoteDeviceDelegate>)delegate
{
    m_Delegate = delegate;
}

@end
