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
#import "WiimotePartSet.h"

@implementation Wiimote (Create)

- (void)initialize
{
    [self requestUpdateState];
    [self deviceConfigurationChanged];
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
    m_Parts     = [[WiimotePartSet alloc] initWithOwner:self device:m_Device];

    if(m_Device == nil ||
     ![m_Device connect])
    {
        [self release];
        return nil;
    }

	[m_Device addDisconnectHandler:self action:@selector(disconnected)];
    [self initialize];
    [Wiimote wiimoteConnected:self];
	[[m_Parts eventDispatcher] postConnectedNotification];

    return self;
}

- (void)dealloc
{
    [m_Device disconnect];
    [m_Parts release];
    [m_Device release];
    [m_UserInfo release];
    [super dealloc];
}

- (void)disconnected
{
    [[self retain] autorelease];
    [Wiimote wiimoteDisconnected:self];
	[[m_Parts eventDispatcher] postDisconnectNotification];
}

+ (void)connectToBluetoothDevice:(IOBluetoothDevice*)device
{
    [[[Wiimote alloc] initWithBluetoothDevice:device] autorelease];
}

@end
