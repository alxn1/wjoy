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

#import "WiimoteIRPart.h"
#import "WiimoteLEDPart.h"
#import "WiimoteButtonPart.h"
#import "WiimoteBatteryPart.h"
#import "WiimoteVibrationPart.h"
#import "WiimoteAccelerometerPart.h"
#import "WiimoteExtensionPart.h"

NSString *WiimoteBeginDiscoveryNotification                     = @"WiimoteBeginDiscoveryNotification";
NSString *WiimoteEndDiscoveryNotification                       = @"WiimoteEndDiscoveryNotification";

NSString *WiimoteUseOneButtonClickConnectionChangedNotification = @"WiimoteUseOneButtonClickConnectionChangedNotification";

NSString *WiimoteUseOneButtonClickConnectionKey                 = @"WiimoteUseOneButtonClickConnectionKey";

@implementation Wiimote

+ (BOOL)isBluetoothEnabled
{
    return [WiimoteInquiry isBluetoothEnabled];
}

+ (NSArray*)supportedModelNames
{
    return [WiimoteInquiry supportedModelNames];
}

+ (BOOL)isUseOneButtonClickConnection
{
    return [[WiimoteInquiry sharedInquiry] isUseOneButtonClickConnection];
}

+ (void)setUseOneButtonClickConnection:(BOOL)useOneButtonClickConnection
{
    if([Wiimote isUseOneButtonClickConnection] == useOneButtonClickConnection)
        return;

    NSDictionary *userInfo = [NSDictionary
                                    dictionaryWithObject:[NSNumber numberWithBool:useOneButtonClickConnection]
                                                  forKey:WiimoteUseOneButtonClickConnectionKey];

    [[WiimoteInquiry sharedInquiry] setUseOneButtonClickConnection:useOneButtonClickConnection];

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteUseOneButtonClickConnectionChangedNotification
                                          object:nil
                                        userInfo:userInfo];
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

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteBeginDiscoveryNotification
                                          object:self];

    return YES;
}

+ (void)discoveryFinished
{
    [[NSNotificationCenter defaultCenter]
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

- (BOOL)isWiiUProController
{
	return [m_ModelName isEqualToString:WiimoteDeviceNameUPro];
}

- (BOOL)isBalanceBoard
{
    return [m_ModelName isEqualToString:WiimoteDeviceNameBalanceBoard];
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

- (BOOL)isButtonPressed:(WiimoteButtonType)button
{
    return [m_ButtonPart isButtonPressed:button];
}

- (CGFloat)batteryLevel
{
    return [m_BatteryPart batteryLevel];
}

- (BOOL)isBatteryLevelLow
{
    return [m_BatteryPart isBatteryLevelLow];
}

- (BOOL)isIREnabled
{
    return [m_IRPart isEnabled];
}

- (void)setIREnabled:(BOOL)enabled
{
    [m_IRPart setEnabled:enabled];
}

- (WiimoteIRPoint*)irPoint:(NSUInteger)index
{
    return [m_IRPart point:index];
}

- (WiimoteAccelerometer*)accelerometer
{
    return [m_AccelerometerPart accelerometer];
}

- (WiimoteExtension*)connectedExtension
{
    return [m_ExtensionPart connectedExtension];
}

- (void)detectMotionPlus
{
    [m_ExtensionPart detectMotionPlus];
}

- (void)reconnectExtension
{
	[m_ExtensionPart reconnectExtension];
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
