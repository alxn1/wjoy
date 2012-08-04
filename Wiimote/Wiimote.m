//
//  Wiimote.m
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "Wiimote.h"
#import "Wiimote+Tracking.h"
#import "WiimoteDevice.h"
#import "WiimotePartSet.h"
#import "WiimoteInquiry.h"

#import "WiimoteLEDPart.h"
#import "WiimoteButtonPart.h"
#import "WiimoteBatteryPart.h"
#import "WiimoteVibrationPart.h"
#import "WiimoteAccelerometerPart.h"
#import "WiimoteExtensionPart.h"

NSString *WiimoteBeginDiscoveryNotification     = @"WiimoteBeginDiscoveryNotification";
NSString *WiimoteEndDiscoveryNotification       = @"WiimoteEndDiscoveryNotification";

@implementation Wiimote

+ (NSNotificationCenter*)notificationCenter
{
    return [WiimoteEventDispatcher notificationCenter];
}

+ (BOOL)isBluetoothEnabled
{
    return [WiimoteInquiry isBluetoothEnabled];
}

+ (NSArray*)supportedModelNames
{
    return [WiimoteInquiry supportedModelNames];
}

+ (BOOL)isDiscovering
{
    return [[WiimoteInquiry sharedInquiry] isStarted];
}

+ (BOOL)beginDiscovery
{
    if(![[WiimoteInquiry sharedInquiry]
                                startWithTarget:self
                                   didEndAction:@selector(discoveryFinished)])
    {
        return NO;
    }

    [[Wiimote notificationCenter]
                            postNotificationName:WiimoteBeginDiscoveryNotification
                                          object:self];

    return YES;
}

+ (void)discoveryFinished
{
    [[Wiimote notificationCenter]
                            postNotificationName:WiimoteEndDiscoveryNotification
                                          object:self];
}

+ (NSArray*)connectedDevices
{
    return [Wiimote connectedWiimotes];
}

- (BOOL)isConnected
{
    return [m_Device isConnected];
}

- (void)disconnect
{
    [m_Device disconnect];
}

- (NSData*)address
{
    return [m_Device address];
}

- (NSString*)addressString
{
    return [m_Device addressString];
}

- (NSString*)modelName
{
    return [[m_ModelName retain] autorelease];
}

- (void)playConnectEffect
{
    [self setVibrationEnabled:YES];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.35]];
    [self setVibrationEnabled:NO];
}

- (NSUInteger)highlightedLEDMask
{
    return [m_LEDPart highlightedLEDMask];
}

- (void)setHighlightedLEDMask:(NSUInteger)mask
{
    [m_LEDPart setHighlightedLEDMask:mask];
}

- (BOOL)isVibrationEnabled
{
    return [m_VibrationPart isVibrationEnabled];
}

- (void)setVibrationEnabled:(BOOL)enabled
{
    [m_VibrationPart setVibrationEnabled:enabled];
}

- (BOOL)isAccelerometerEnabled
{
    return [m_AccelerometerPart isEnabled];
}

- (void)setAccelerometerEnabled:(BOOL)enabled
{
    [m_AccelerometerPart setEnabled:enabled];
}

- (double)accelerometerPitch
{
    return [m_AccelerometerPart pitch];
}

- (double)accelerometerRoll
{
    return [m_AccelerometerPart roll];
}

- (BOOL)isButtonPressed:(WiimoteButtonType)button
{
    return [m_ButtonPart isButtonPressed:button];
}

- (double)batteryLevel
{
    return [m_BatteryPart batteryLevel];
}

- (BOOL)isBatteryLevelLow
{
    return [m_BatteryPart isBatteryLevelLow];
}

- (WiimoteExtension*)connectedExtension
{
    return [m_ExtensionPart connectedExtension];
}

- (void)disconnectExtension
{
    [m_ExtensionPart disconnectExtension];
}

- (void)requestUpdateState
{
    [m_Device requestStateReport];
}

- (BOOL)isStateChangeNotificationsEnabled
{
    return [[m_PartSet eventDispatcher] isStateNotificationsEnabled];
}

- (void)setStateChangeNotificationsEnabled:(BOOL)enabled
{
    [[m_PartSet eventDispatcher] setStateNotificationsEnabled:enabled];
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

- (id)delegate
{
    return [[m_PartSet eventDispatcher] delegate];
}

- (void)setDelegate:(id)delegate
{
    [[m_PartSet eventDispatcher] setDelegate:delegate];
}

@end
