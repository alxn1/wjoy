//
//  WiimoteDeviceReport+Private.m
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReport+Private.h"
#import "WiimoteProtocol.h"
#import "Wiimote.h"

@implementation WiimoteDeviceReport (Private)

- (id)init
{
	[[super init] release];
	return nil;
}

- (id)initWithReportData:(const uint8_t*)data
				  length:(NSUInteger)length
				  device:(WiimoteDevice*)device
{
	self = [super init];
	if(self == nil)
		return nil;

    const WiimoteDeviceReportHeader *header = (const WiimoteDeviceReportHeader*)data;

	if(device	== nil  ||
	   data		== NULL ||
	   length < sizeof(WiimoteDeviceReportHeader) ||
	   header->packetType != WiimoteDevicePacketTypeReport)
	{
		[self release];
		return nil;
	}

	m_Device	= [device retain];
	m_Wiimote	= nil;
    m_Type		= header->reportType;
	m_Data		= [[NSData alloc]
						initWithBytes:data   + sizeof(WiimoteDeviceReportHeader)
							   length:length - sizeof(WiimoteDeviceReportHeader)];

	return self;
}

- (id)initWithType:(NSUInteger)type
              data:(NSData*)data
            device:(WiimoteDevice*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    if(device       == nil ||
      [data length] == 0)
    {
        [self release];
        return nil;
    }

    m_Device    = [device retain];
    m_Wiimote   = nil;
    m_Type      = type;
    m_Data      = [data copy];

    return self;
}

- (void)dealloc
{
	[m_Data release];
	[m_Device release];
	[m_Wiimote release];
	[super dealloc];
}

- (WiimoteDevice*)device
{
	return [[m_Device retain] autorelease];
}

- (void)setWiimote:(Wiimote*)wiimote
{
	if(m_Wiimote == wiimote)
		return;

	[m_Wiimote release];
	m_Wiimote = [wiimote retain];
}

+ (WiimoteDeviceReport*)parseReportData:(const uint8_t*)data
								 length:(NSUInteger)length
								 device:(WiimoteDevice*)device
{
	return [[[WiimoteDeviceReport alloc]
                                initWithReportData:data
                                            length:length
                                            device:device] autorelease];
}

+ (WiimoteDeviceReport*)deviceReportWithType:(NSUInteger)type
                                        data:(NSData*)data
                                      device:(WiimoteDevice*)device
{
    return [[[WiimoteDeviceReport alloc]
                                initWithType:type
                                        data:data
                                      device:device] autorelease];
}

@end
