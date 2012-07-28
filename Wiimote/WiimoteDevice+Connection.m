//
//  WiimoteDevice+Connection.m
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice+Connection.h"
#import "WiimoteDevice+Hardware.h"
#import "WiimoteDevice+Notification.h"
#import "WiimoteDevice+ConnectedTracking.h"

@implementation WiimoteDevice (Connection)

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

    if(device == nil)
    {
        [self release];
        return nil;
    }

    m_IsInitialiased			= NO;
    m_HighlightedLEDMask		= 0;
    m_IsVibrationEnabled		= NO;
    m_BatteryLevel				= -1.0;
    m_IsBatteryLevelLow			= NO;
    m_IsUpdateStateStarted		= NO;
    m_UserInfo					= nil;
	m_Extension					= nil;
	m_IsExtensionConnected		= NO;
	m_IsExtensionInitialized	= NO;
	m_IsStateChangeNotificationsEnabled = YES;

    memset(m_ButtonState, 0, sizeof(m_ButtonState));

    m_Device					= [device retain];
	m_ControlChannel			= [[self openChannel:kBluetoothL2CAPPSMHIDControl] retain];
	m_DataChannel				= [[self openChannel:kBluetoothL2CAPPSMHIDInterrupt] retain];

	if(m_ControlChannel == nil ||
       m_DataChannel    == nil)
    {
		[self release];
        return nil;
    }

    [self initialize];
    if(![self isConnected])
    {
        [self release];
        return nil;
    }

    m_IsInitialiased = YES;
    [WiimoteDevice addNewConnectedDevice:self];
    [self onConnected];

    return self;
}

- (void)dealloc
{
    [m_UserInfo release];
    [self disconnect];
    [super dealloc];
}

+ (void)connectToBluetoothDevice:(IOBluetoothDevice*)device
{
    [[[WiimoteDevice alloc] initWithBluetoothDevice:device] autorelease];
}

@end
