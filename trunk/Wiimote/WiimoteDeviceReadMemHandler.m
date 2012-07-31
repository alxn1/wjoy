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

	m_Device		= nil;
	m_MemoryRange	= memoryRange;
	m_ReadedData	= [[NSMutableData alloc] initWithCapacity:memoryRange.length];
	m_IsAutorelease	= YES;
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

- (BOOL)startWithDevice:(WiimoteDevice*)device
		 vibrationState:(BOOL)vibrationState
{
	if(m_Device != nil ||
       device	== nil ||
     ![device isConnected])
	{
		return NO;
	}

    WiimoteDeviceReadMemoryParams params;

    params.address = OSSwapHostToBigConstInt32((uint32_t)m_MemoryRange.location);
    params.length  = OSSwapHostToBigConstInt16((uint16_t)m_MemoryRange.length);

	NSMutableData *commandData = [NSMutableData dataWithBytesNoCopy:&params length:sizeof(params)];

	if(![device postCommand:WiimoteDeviceCommandTypeReadMemory
                       data:commandData
             vibrationState:vibrationState])
	{
		return NO;
	}

	[device addReportHandler:self
                      action:@selector(deviceReadDataReport:)];

    [device addDisconnectHandler:self
                          action:@selector(deviceDisconnected:)];

    m_Device = device;
	return YES;
}

- (BOOL)isAutorelease
{
	return m_IsAutorelease;
}

- (void)setAutorelease:(BOOL)flag
{
	m_IsAutorelease = flag;
}

- (void)dataReadFinished
{
    [m_Device removeHandler:self];

	if(m_Target != nil &&
	   m_Action != nil)
	{
		[m_Target performSelector:m_Action withObject:m_ReadedData];
		m_Target = nil;
	}

	if(m_IsAutorelease)
		[self release];
}

- (void)deviceReadDataReport:(WiimoteDeviceReport*)report
{
    NSData                              *data         = [report data];
    const WiimoteDeviceReadMemoryReport *memoryReport =
                                            (const WiimoteDeviceReadMemoryReport*)[data bytes];

    if([report type] != WiimoteDeviceReportTypeReadMemory ||
       [data length] < sizeof(WiimoteDeviceReadMemoryReport))
    {
        return;
    }

    NSUInteger desiredAddress   = m_MemoryRange.location + [m_ReadedData length];
    NSUInteger address          = (m_MemoryRange.location & 0xFFFF0000) |
                                            OSSwapBigToHostConstInt16(memoryReport->dataOffset);

    if(address != desiredAddress)
        return;

    if(((memoryReport->errorAndDataSize &
            WiimoteDeviceReadMemoryReportErrorMask) >>
                WiimoteDeviceReadMemoryReportErrorOffset) !=
                                        WiimoteDeviceReadMemoryReportErrorOk)
    {
        [self dataReadFinished];
        return;
    }

    NSUInteger dataSize = ((memoryReport->errorAndDataSize &
                                WiimoteDeviceReadMemoryReportDataSizeMask) >>
                                    WiimoteDeviceReadMemoryReportDataSizeOffset) + 1;

    [m_ReadedData appendBytes:memoryReport->data length:dataSize];

    if([m_ReadedData length] >= m_MemoryRange.length)
		[self dataReadFinished];
}

- (void)deviceDisconnected:(WiimoteDevice*)device
{
    [m_ReadedData release];
    m_ReadedData = nil;

    [self dataReadFinished];
}

@end
