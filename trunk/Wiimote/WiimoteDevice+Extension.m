//
//  WiimoteDevice+Extension.m
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice+Extension.h"
#import "WiimoteDevice+Hardware.h"
#import "WiimoteDevice+Notification.h"
#import "WiimoteDeviceExtension+PlugIn.h"
#import "WiimoteDeviceNunchuck.h"

@implementation WiimoteDevice (Extension)

+ (NSArray*)knownExtensionClasses
{
	static NSArray *result = nil;

	if(result == nil)
	{
		result = [[NSArray alloc] initWithObjects:
										[WiimoteDeviceNunchuck class],
										[WiimoteDeviceExtension class],
										nil];
	}

	return result;
}

+ (Class)nextExtensionClass:(Class)cls
{
	NSArray *allExtensions = [WiimoteDevice knownExtensionClasses];

	if(cls == nil)
		return [allExtensions objectAtIndex:0];

	NSUInteger index = [allExtensions indexOfObject:cls];

	if(index == NSNotFound ||
	   index == ([allExtensions count] - 1))
	{
		return [WiimoteDeviceExtension class];
	}

	return [allExtensions objectAtIndex:index + 1];
}

- (BOOL)initializeExtension
{
	unsigned char data = 0x55;

	if(![self writeData:&data length:sizeof(data) address:0x04A400F0])
		return NO;

	data = 0x00;
	if(![self writeData:&data length:sizeof(data) address:0x04A400FB])
		return NO;

	return YES;
}

- (void)calibrateExtension
{
	NSRange calibrationSpace = [m_Extension calibrationAddressSpace];
	if(calibrationSpace.length == 0)
	{
		m_IsExtensionInitialized = YES;
		[self onExtensionConnected:m_Extension];
		return;
	}

	m_CalibrationData = [[NSMutableData alloc] init];
	if(![self beginReadFromMemory:calibrationSpace])
		[self disconnect];
}

- (void)processExtensionCalibrateData:(const unsigned char*)data length:(NSUInteger)length
{
	[m_CalibrationData appendBytes:data length:length];
	if([m_CalibrationData length] < [m_Extension calibrationAddressSpace].length)
	{
		NSRange calibrationSpace = [m_Extension calibrationAddressSpace];

		calibrationSpace.location	+= [m_CalibrationData length];
		calibrationSpace.length		-= [m_CalibrationData length];

		if(![self beginReadFromMemory:[m_Extension calibrationAddressSpace]])
			[self disconnect];

		return;
	}

	if(![m_Extension setCalibrationData:[m_CalibrationData bytes]
								 length:[m_CalibrationData length]])
	{
		[self disconnect];
	}

	m_IsExtensionInitialized = YES;
	[self onExtensionConnected:m_Extension];
	[self enableButtonReport];
}

- (void)probeNextExtensionClass
{
	m_ExtensionClass = [WiimoteDevice nextExtensionClass:m_ExtensionClass];

	NSRange probeSpace = [m_ExtensionClass probeAddressSpace];

	if(probeSpace.length == 0)
	{
		m_Extension = [[m_ExtensionClass alloc] initWithDevice:self];
		[self calibrateExtension];
		return;
	}

	if(![self beginReadFromMemory:probeSpace])
		[self disconnect];
}

- (void)processProbeData:(const unsigned char*)data length:(NSUInteger)length
{
	if(![m_ExtensionClass probe:data length:length])
	{
		[self probeNextExtensionClass];
		return;
	}

	m_Extension = [[m_ExtensionClass alloc] initWithDevice:self];
	[self calibrateExtension];
}

- (void)createExtensionDevice
{
	if(m_IsExtensionConnected)
		return;

	if(![self initializeExtension])
	{
		[self disconnect];
		return;
	}

	m_IsExtensionConnected = YES;
	[self probeNextExtensionClass];
}

- (void)releaseExtensionDevice
{
	if(!m_IsExtensionConnected)
		return;

	if(m_IsExtensionInitialized)
		[self onExtensionDisconnected:m_Extension];

	[m_CalibrationData release];
	[m_Extension release];
	m_CalibrationData = nil;
	m_ExtensionClass = nil;
	m_Extension = nil;
	m_IsExtensionConnected = NO;
	m_IsExtensionInitialized = NO;
}

- (void)processReadedData:(const unsigned char*)data length:(NSUInteger)length
{
	if(m_Extension == nil)
		[self processProbeData:data length:length];
	else
		[self processExtensionCalibrateData:data length:length];
}

@end
