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

- (void)requestUpdateState
{
    [m_Device requestStateReportWithVibrationState:[self isVibrationEnabled]];
}

- (void)deviceConfigurationChanged
{
    WiimoteDeviceSetReportTypeParams params;

    params.flags        = 0;
    params.reportType   = [m_PartSet bestReportType];

    [m_Device postCommand:WiimoteDeviceCommandTypeSetReportType
                     data:[NSData dataWithBytes:&params length:sizeof(params)]
           vibrationState:[self isVibrationEnabled]];
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

- (WiimotePart*)partWithClass:(Class)cls
{
    return [m_PartSet partWithClass:cls];
}

@end
