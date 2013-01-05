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

@interface WiimoteDevice (PrivatePart)

- (IOBluetoothL2CAPChannel*)openChannel:(BluetoothL2CAPPSM)channelID;

- (void)handleReport:(WiimoteDeviceReport*)report;
- (void)handleDisconnect;

@end

@interface WiimoteDevice (IOBluetoothL2CAPChannelDelegate)

- (void)l2capChannelData:(IOBluetoothL2CAPChannel*)l2capChannel
                    data:(void*)dataPointer
                  length:(size_t)dataLength;

- (void)l2capChannelClosed:(IOBluetoothL2CAPChannel*)l2capChannel;

@end

@implementation WiimoteDevice

- (id)init
{
	[[super init] release];
	return nil;
}

- (id)initWithBluetoothDevice:(IOBluetoothDevice*)device
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
	m_DataChannel			= nil;
	m_ControlChannel		= nil;
    m_Report                = [[WiimoteDeviceReport alloc] initWithDevice:self];
    m_ReadMemQueue			= [[WiimoteDeviceReadMemQueue alloc] initWithDevice:self];
	m_IsConnected			= NO;
    m_IsVibrationEnabled    = NO;
    m_LEDsState             = 0;
	m_Delegate				= nil;

	return self;
}

- (void)dealloc
{
	[self disconnect];
    [m_Report release];
    [m_ReadMemQueue release];
	[m_ControlChannel release];
	[m_DataChannel release];
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

	m_IsConnected		= YES;
	m_ControlChannel	= [[self openChannel:kBluetoothL2CAPPSMHIDControl] retain];
	m_DataChannel		= [[self openChannel:kBluetoothL2CAPPSMHIDInterrupt] retain];

	if(m_ControlChannel == nil ||
       m_DataChannel    == nil)
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

	[m_ControlChannel setDelegate:nil];
	[m_DataChannel setDelegate:nil];

	[m_ControlChannel closeChannel];
	[m_DataChannel closeChannel];
	[m_Device closeConnection];

	m_IsConnected = NO;

	[self handleDisconnect];
}

- (NSData*)address
{
	if(![self isConnected])
		return nil;

	const BluetoothDeviceAddress *address = [m_Device getAddress];
    if(address == NULL)
        return nil;

    return [NSData dataWithBytes:address->data
                          length:sizeof(address->data)];
}

- (NSString*)addressString
{
	if(![self isConnected])
		return nil;

	return [m_Device getAddressString];
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

	uint8_t                     buffer[sizeof(WiimoteDeviceCommandHeader) + length];
    WiimoteDeviceCommandHeader *header = (WiimoteDeviceCommandHeader*)buffer;

    header->packetType  = WiimoteDevicePacketTypeCommand;
    header->commandType = command;
    memcpy(buffer + sizeof(WiimoteDeviceCommandHeader), data, length);

    if(m_IsVibrationEnabled)
    {
        buffer[sizeof(WiimoteDeviceCommandHeader)] |=
                        WiimoteDeviceCommandFlagVibrationEnabled;
    }
    else
    {
        buffer[sizeof(WiimoteDeviceCommandHeader)] &=
                        (~WiimoteDeviceCommandFlagVibrationEnabled);
    }

    return ([m_DataChannel
                    writeSync:buffer
                       length:sizeof(buffer)] == kIOReturnSuccess);
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

- (IOBluetoothL2CAPChannel*)openChannel:(BluetoothL2CAPPSM)channelID
{
	IOBluetoothL2CAPChannel *result = nil;

	if([m_Device openL2CAPChannelSync:&result
                              withPSM:channelID
                             delegate:self] != kIOReturnSuccess)
    {
		return nil;
    }

	return result;
}

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

- (void)l2capChannelData:(IOBluetoothL2CAPChannel*)l2capChannel
                    data:(void*)dataPointer
                  length:(size_t)dataLength
{
    if(![m_Report updateFromReportData:(const uint8_t*)dataPointer
                                length:dataLength])
    {
        return;
    }

	[self handleReport:m_Report];
}

- (void)l2capChannelClosed:(IOBluetoothL2CAPChannel*)l2capChannel
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
