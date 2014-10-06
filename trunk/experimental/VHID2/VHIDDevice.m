//
//  VHIDDevice.m
//  VHID
//
//  Created by alxn1 on 17.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDDevice+Private.h"

@implementation VHIDDevice

- (void)dealloc
{
    [m_Descriptor release];
    [m_State release];
    [super dealloc];
}

- (NSData*)descriptor
{
    return [[m_Descriptor retain] autorelease];
}

- (NSData*)state
{
    return [[m_State retain] autorelease];
}

- (void)reset
{
    [self resetState];
    [self notifyAboutStateChanged];
}

- (id<VHIDDeviceDelegate>)delegate
{
    return m_Delegate;
}

- (void)setDelegate:(id<VHIDDeviceDelegate>)delegate
{
    m_Delegate = delegate;
}

@end
