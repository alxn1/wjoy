//
//  WiimoteDeviceReport.m
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReport.h"
#import "WiimoteProtocol.h"
#import "Wiimote.h"

@implementation WiimoteDeviceReport

- (NSUInteger)type
{
	return m_Type;
}

- (const uint8_t*)data
{
    return m_Data;
}

- (NSUInteger)length
{
    return m_DataLength;
}

- (Wiimote*)wiimote
{
	return m_Wiimote;
}

@end
