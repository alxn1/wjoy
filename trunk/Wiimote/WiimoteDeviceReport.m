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

- (NSData*)data
{
	return [[m_Data retain] autorelease];
}

- (NSUInteger)type
{
	return m_Type;
}

- (Wiimote*)wiimote
{
	return [[m_Wiimote retain] autorelease];
}

@end
