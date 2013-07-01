//
//  WiimoteDevice.m
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"
#import "WiimoteDeviceReport+Private.h"
#import "WiimoteDeviceReadMemQueue.h"

#import <IOBluetooth/IOBluetooth.h>
#import <HID/HIDDevice.h>

@interface WiimoteDevice (PrivatePart)

- (void)handleReport:(WiimoteDeviceReport*)report;
- (void)handleDisconnect;

@end

@implementation WiimoteDevice

- (id)init
{
	[[super init] release];
	return nil;
}

- (id)initWithHIDDevice:(HIDDevice*)device
{
	self = [super init];
	if(self == nil)
		return nil;

	if(device == nil)
	{
		[self release];
		return nil;
	}

	m_Device				= [device retain];
    m_Report                = [[WiimoteDeviceReport alloc] initWithDevice:self];
    m_ReadMemQueue			= [[WiimoteDeviceReadMemQueue alloc] initWithDevice:self];
	m_IsConnected			= NO;
    m_IsVibrationEnabled    = NO;
    m_LEDsState             = 0;
	m_Delegate				= nil;

	[device setDelegate:self];

	return self;
}

- (void)dealloc
{
	[self disconnect];
    [m_Report release];
    [m_ReadMemQueue release];
	[m_Device release];
	[super dealloc];
}

- (BOOL)isConnected
{
	return m_IsConnected;
}

- (BOOL)connect
{
	if([self isConnected])
		return YES;

	m_IsConnected = YES;

	if(![m_Device openWithOptions:kIOHIDOptionsTypeSeizeDevice])
    {
		[self disconnect];
		m_IsConnected = NO;
        return NO;
    }

	return YES;
}

- (void)disconnect
{
	if(![self isConnected])
		return;

    BluetoothDeviceAddress address = { 0 };

    [[self address]
                getBytes:address.data
                  length:sizeof(address.data)];

	m_IsConnected = NO;
    [[IOBluetoothDevice withAddress:&address] closeConnection];
	[m_Device setDelegate:nil];
	[m_Device close];

	[self handleDisconnect];
}

- (NSData*)address
{
	NSString	*address		= [self addressString];
	NSArray		*components		= nil;
	uint8_t		 bytes[6]		= { 0 };
	unsigned int value			= 0;

	components = [address componentsSeparatedByString:@"-"];
	if([components count] != sizeof(bytes))
		return nil;

	for(int i = 0; i < sizeof(bytes); i++)
	{
		NSScanner *scanner = [[NSScanner alloc] initWithString:[components objectAtIndex:i]];
		[scanner scanHexInt:&value];
		[scanner release];
		bytes[i] = (uint8_t)value;
	}

	return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

- (NSString*)addressString
{
	if(![self isConnected])
		return nil;

    return [m_Device address];
}

- (BOOL)postCommand:(WiimoteDeviceCommandType)command
               data:(const uint8_t*)data
             length:(NSUInteger)length
{
    if(![self isConnected]  ||
        data    == NULL     ||
        length  == 0)
    {
		return NO;
    }

	uint8_t buffer[length + 1];

    buffer[0] = command;
    memcpy(buffer + 1, data, length);

    if(m_IsVibrationEnabled)
        buffer[1] |= WiimoteDeviceCommandFlagVibrationEnabled;
    else
        buffer[1] &= (~WiimoteDeviceCommandFlagVibrationEnabled);

	return [m_Device postBytes:buffer length:sizeof(buffer)];
}

- (BOOL)writeMemory:(NSUInteger)address
               data:(const uint8_t*)data
             length:(NSUInteger)length
{
    if(![self isConnected]  ||
        data    == NULL     ||
		length  > WiimoteDeviceWriteMemoryReportMaxDataSize)
	{
		return NO;
	}

    if(length == 0)
		return YES;

    uint8_t                          buffer[sizeof(WiimoteDeviceWriteMemoryParams)];
    WiimoteDeviceWriteMemoryParams  *params = (WiimoteDeviceWriteMemoryParams*)buffer;

    params->address = OSSwapHostToBigConstInt32(address);
    params->length  = length;
    memset(params->data, 0, sizeof(params->data));
    memcpy(params->data, data, length);

    return [self postCommand:WiimoteDeviceCommandTypeWriteMemory
						data:buffer
                      length:sizeof(buffer)];
}

- (BOOL)readMemory:(NSRange)memoryRange
            target:(id)target
            action:(SEL)action
{
    if(![self isConnected])
		return NO;

	return [m_ReadMemQueue readMemory:memoryRange
							   target:target
							   action:action];
}

- (BOOL)requestStateReport
{
    uint8_t param = 0;

    return [self postCommand:WiimoteDeviceCommandTypeGetState
                        data:&param
                      length:sizeof(param)];
}

- (BOOL)requestReportType:(WiimoteDeviceReportType)type
{
	WiimoteDeviceSetReportTypeParams params;

    params.flags        = 0;
    params.reportType   = type;

    return [self postCommand:WiimoteDeviceCommandTypeSetReportType
						data:(const uint8_t*)&params
                      length:sizeof(params)];
}

- (BOOL)postVibrationAndLEDStates
{
    return [self postCommand:WiimoteDeviceCommandTypeSetLEDState
                        data:&m_LEDsState
                      length:sizeof(m_LEDsState)];
}

- (BOOL)isVibrationEnabled
{
    return m_IsVibrationEnabled;
}

- (BOOL)setVibrationEnabled:(BOOL)enabled
{
    if(m_IsVibrationEnabled == enabled)
        return YES;

    m_IsVibrationEnabled = enabled;
    if(![self postVibrationAndLEDStates])
    {
        m_IsVibrationEnabled = !enabled;
        return NO;
    }

    return YES;
}

- (uint8_t)LEDsState
{
    return m_LEDsState;
}

- (BOOL)setLEDsState:(uint8_t)state
{
    uint8_t oldState = m_LEDsState;

    m_LEDsState = state;
    if(![self postVibrationAndLEDStates])
    {
        m_LEDsState = oldState;
        return NO;
    }

    return YES;
}

- (id)delegate
{
	return m_Delegate;
}

- (void)setDelegate:(id)delegate
{
	m_Delegate = delegate;
}

@end

@implementation WiimoteDevice (PrivatePart)

- (void)handleReport:(WiimoteDeviceReport*)report
{
    [m_ReadMemQueue handleReport:report];
	[m_Delegate wiimoteDevice:self handleReport:report];
}

- (void)handleDisconnect
{
    m_IsVibrationEnabled    = NO;
    m_LEDsState             = 0;

    [m_ReadMemQueue handleDisconnect];
	[m_Delegate performSelector:@selector(wiimoteDeviceDisconnected:)
					 withObject:self
					 afterDelay:0.5];
}

@end

@implementation WiimoteDevice (IOBluetoothL2CAPChannelDelegate)

- (void)hidDevice:(HIDDevice*)device reportDataReceived:(const uint8_t*)bytes length:(NSUInteger)length
{
	if(![m_Report updateFromReportData:(const uint8_t*)bytes
                                length:length])
    {
        return;
    }

	[self handleReport:m_Report];
}

- (void)hidDeviceClosed:(HIDDevice*)device
{
	[self disconnect];
}

@end

@implementation NSObject (WiimoteDeviceDelegate)

- (void)wiimoteDevice:(WiimoteDevice*)device handleReport:(WiimoteDeviceReport*)report
{
}

- (void)wiimoteDeviceDisconnected:(WiimoteDevice*)device
{
}

@end
