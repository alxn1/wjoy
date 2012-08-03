//
//  Wiimote+Create.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote+Create.h"
#import "Wiimote+Tracking.h"

#import "WiimoteDevice.h"

#import "WiimoteLEDPart.h"
#import "WiimoteButtonPart.h"
#import "WiimoteBatteryPart.h"
#import "WiimoteVibrationPart.h"
#import "WiimoteExtensionPart.h"

#import "WiimotePartSet.h"

#import <IOBluetooth/IOBluetooth.h>

@implementation Wiimote (Create)

- (void)initialize
{
    [self requestUpdateState];
    [self deviceConfigurationChanged];
}

- (void)initParts
{
    m_LEDPart       = (WiimoteLEDPart*)         [self partWithClass:[WiimoteLEDPart class]];
    m_ButtonPart    = (WiimoteButtonPart*)      [self partWithClass:[WiimoteButtonPart class]];
    m_BatteryPart   = (WiimoteBatteryPart*)     [self partWithClass:[WiimoteBatteryPart class]];
    m_VibrationPart = (WiimoteVibrationPart*)   [self partWithClass:[WiimoteVibrationPart class]];
    m_ExtensionPart = (WiimoteExtensionPart*)   [self partWithClass:[WiimoteExtensionPart class]];

    [m_LEDPart setDevice:m_Device];
	[m_VibrationPart setDevice:m_Device];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithBluetoothDevice:(IOBluetoothDevice*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Device    = [[WiimoteDevice alloc] initWithBluetoothDevice:device];
    m_PartSet   = [[WiimotePartSet alloc] initWithOwner:self device:m_Device];
    m_ModelName = [[device getName] copy];

    [self initParts];

    if(m_Device == nil ||
     ![m_Device connect])
    {
        [self release];
        return nil;
    }

    [[m_Device eventDispatcher] addDisconnectHandler:self action:@selector(disconnected)];
    [self initialize];
    [Wiimote wiimoteConnected:self];
	[[m_PartSet eventDispatcher] postConnectedNotification];

    return self;
}

- (void)dealloc
{
    [m_Device disconnect];
    [m_PartSet release];
    [m_Device release];
    [m_ModelName release];
    [m_UserInfo release];
    [super dealloc];
}

- (void)disconnected
{
    [[self retain] autorelease];
    [Wiimote wiimoteDisconnected:self];
	[[m_PartSet eventDispatcher] postDisconnectNotification];
}

+ (void)connectToBluetoothDevice:(IOBluetoothDevice*)device
{
    [[[Wiimote alloc] initWithBluetoothDevice:device] autorelease];
}

@end
