//
//  WiimoteDeviceReadMemHandler.m
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReadMemHandler.h"
#import "WiimoteDevice.h"

@implementation WiimoteDeviceReadMemHandler

- (id)init
{
	[[super init] release];
	return nil;
}

- (id)initWithMemoryRange:(NSRange)memoryRange
				   target:(id)target
				   action:(SEL)action
{
	self = [super init];
	if(self == nil)
		return nil;

	m_MemoryRange	= memoryRange;
	m_ReadedData	= [[NSMutableData alloc] initWithCapacity:memoryRange.length];
	m_Target		= target;
	m_Action		= action;

	if(memoryRange.length == 0)
	{
		[self release];
		return nil;
	}

	return self;
}

- (void)dealloc
{
	[m_ReadedData release];
	[super dealloc];
}

- (void)dataReadFinished
{
	if(m_Target != nil &&
	   m_Action != nil)
	{
		[m_Target performSelector:m_Action
                       withObject:m_ReadedData
                       afterDelay:0.0];
	}
}

- (NSRange)memoryRange
{
    return m_MemoryRange;
}

- (BOOL)isAllDataReaded
{
	return ([m_ReadedData length] >= m_MemoryRange.length);
}

- (void)handleData:(const uint8_t*)data length:(NSUInteger)length
{
    [m_ReadedData appendBytes:data length:length];
    if([m_ReadedData length] >= m_MemoryRange.length)
		[self dataReadFinished];
}

- (void)errorOccured
{
    [m_ReadedData setLength:0];
    [self dataReadFinished];
}

- (void)disconnected
{
    [m_ReadedData release];
    m_ReadedData = nil;
    [self dataReadFinished];
}

@end
