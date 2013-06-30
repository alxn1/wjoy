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

+ (WiimoteDeviceReport*)deviceReportWithType:(NSUInteger)type
                                        data:(const uint8_t*)data
                                      length:(NSUInteger)length
                                      device:(WiimoteDevice*)device
{
    WiimoteDeviceReport *result = [[WiimoteDeviceReport alloc] initWithDevice:device];

    if(result == nil)
        return nil;

    result->m_Type          = type;
    result->m_Data          = data;
    result->m_DataLength    = length;

    return [result autorelease];
}

- (id)init
{
	[[super init] release];
	return nil;
}

- (id)initWithDevice:(WiimoteDevice*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Device        = device;
    m_Data          = NULL;
    m_DataLength    = 0;
    m_Type          = 0;

    return self;
}

- (BOOL)updateFromReportData:(const uint8_t*)data length:(NSUInteger)length
{
	if(data == NULL || length < 1)
		return NO;

	m_Wiimote       = nil;
    m_Type          = data[0];
	m_Data          = data   + 1;
    m_DataLength    = length - 1;

	return YES;
}

- (WiimoteDevice*)device
{
	return m_Device;
}

- (void)setWiimote:(Wiimote*)wiimote
{
	m_Wiimote = wiimote;
}

@end
