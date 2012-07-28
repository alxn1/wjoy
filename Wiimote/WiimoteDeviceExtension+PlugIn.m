//
//  WiimoteDeviceExtension+PlugIn.m
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceExtension+PlugIn.h"
#import "WiimoteDevice.h"

@implementation WiimoteDeviceExtension (PlugIn)

+ (NSRange)probeAddressSpace
{
	return NSMakeRange(0, 0);
}

+ (BOOL)probe:(const unsigned char*)data length:(NSUInteger)length
{
	return YES;
}

- (id)initWithDevice:(WiimoteDevice*)device
{
	self = [super init];
	if(self == nil)
		return nil;

	m_Device = [device retain];

	return self;
}

- (void)dealloc
{
	[m_Device release];
	[super dealloc];
}

- (NSRange)calibrationAddressSpace
{
	return NSMakeRange(0, 0);
}

- (BOOL)setCalibrationData:(const unsigned char*)data length:(NSUInteger)length
{
	return YES;
}

- (BOOL)updateStateFromData:(const unsigned char*)data length:(NSUInteger)length
{
	return YES;
}

- (void)reset
{
}

@end
