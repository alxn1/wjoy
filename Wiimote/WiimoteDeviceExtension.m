//
//  WiimoteDeviceExtension.m
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceExtension.h"

@implementation WiimoteDeviceExtension

- (id)init
{
	[[super init] release];
	return nil;
}

- (NSUInteger)type
{
	return WiimoteExtensionTypeUnknown;
}

- (WiimoteDevice*)device
{
	return [[m_Device retain] autorelease];
}

@end
