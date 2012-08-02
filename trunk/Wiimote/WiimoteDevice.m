//
//  WiimoteDevice.m
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"
#import "WiimoteDeviceEventHandler.h"
#import "WiimoteDeviceReadMemHandler.h"
#import "WiimoteDeviceReport+Private.h"
#import <IOBluetooth/IOBluetooth.h>

@interface WiimoteDevice (PrivatePart)

- (IOBluetoothL2CAPChannel*)openChannel:(BluetoothL2CAPPSM)channelID;

- (void)handleReport:(WiimoteDeviceReport*)report;
- (void)handleDisconnect;

- (BOOL)isReadMemHandlersQueueEmpty;
- (void)addReadMemHandlerToQueue:(WiimoteDeviceReadMemHandler*)handler;
- (WiimoteDeviceReadMemHandler*)nextReadMemHandlerFromQueue;
- (BOOL)runReadMemHandler:(WiimoteDeviceReadMemHandler*)handler;

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
	m_ReportHandlers		= [[NSMutableArray alloc] init];
	m_DisconnectHandlers	= [[NSMutableArray alloc] init];
    m_ReadMemHandlersQueue  = [[NSMutableArray alloc] init];
    m_CurrentMemHandler     = nil;
	m_IsConnected			= NO;
    m_IsVibrationEnabled    = NO;

	return self;
}

- (void)dealloc
{
	[self disconnect];
    [m_CurrentMemHandler release];
    [m_ReadMemHandlersQueue release];
	[m_DisconnectHandlers release];
	[m_ReportHandlers release];
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
	[self removeAllHandlers];
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

- (BOOL)isVibrationEnabled
{
    return m_IsVibrationEnabled;
}

- (void)setVibrationEnabled:(BOOL)enabled
{
    m_IsVibrationEnabled = enabled;
}

- (BOOL)postCommand:(WiimoteDeviceCommandType)command data:(NSData*)data
{
	if(![self isConnected] ||
        [data length] == 0)
    {
		return NO;
    }

	uint8_t                     buffer[sizeof(WiimoteDeviceCommandHeader) + [data length]];
    WiimoteDeviceCommandHeader *header = (WiimoteDeviceCommandHeader*)buffer;

    header->packetType  = WiimoteDevicePacketTypeCommand;
    header->commandType = command;
    memcpy(buffer + sizeof(WiimoteDeviceCommandHeader), [data bytes], [data length]);

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

- (BOOL)writeMemory:(NSUInteger)address data:(NSData*)data
{
    if(![self isConnected] ||
		[data length] > WiimoteDeviceWriteMemoryReportMaxDataSize)
	{
		return NO;
	}

    if([data length] == 0)
		return YES;

    NSMutableData                   *commandData	= [NSMutableData dataWithLength:sizeof(WiimoteDeviceWriteMemoryParams)];
	uint8_t                         *buffer         = [commandData mutableBytes];
    WiimoteDeviceWriteMemoryParams  *params         = (WiimoteDeviceWriteMemoryParams*)buffer;

    params->address = OSSwapHostToBigConstInt32(address);
    params->length  = [data length];
    memset(params->data, 0, sizeof(params->data));
    memcpy(params->data, [data bytes], [data length]);

    return [self postCommand:WiimoteDeviceCommandTypeWriteMemory
						data:commandData];
}

- (BOOL)readMemory:(NSRange)memoryRange target:(id)target action:(SEL)action
{
	if(![self isConnected])
		return NO;

	WiimoteDeviceReadMemHandler *handler =
			[[[WiimoteDeviceReadMemHandler alloc]
									initWithMemoryRange:memoryRange
												 target:target
												 action:action] autorelease];

    if([self isReadMemHandlersQueueEmpty])
        return [self runReadMemHandler:handler];

    [self addReadMemHandlerToQueue:handler];
    return YES;
}

- (BOOL)injectReport:(NSUInteger)type data:(NSData*)data
{
    if(![self isConnected])
        return NO;

    WiimoteDeviceReport *report = [WiimoteDeviceReport
                                            deviceReportWithType:type
                                                            data:data
                                                          device:self];

    if(report == nil)
        return NO;

    [self handleReport:report];
    return YES;
}

- (BOOL)requestStateReport
{
    uint8_t param = 0;
    return [self postCommand:WiimoteDeviceCommandTypeGetState
                        data:[NSData dataWithBytes:&param length:sizeof(param)]];
}

@end

@implementation WiimoteDevice (ReportHandling)

- (void)addReportHandler:(id)target action:(SEL)action
{
	[m_ReportHandlers addObject:
		[WiimoteDeviceEventHandler
                    newHandlerWithTarget:target action:action]];
}

- (void)removeReportHandler:(id)target action:(SEL)action
{
	NSUInteger countHandlers = [m_ReportHandlers count];

	for(NSUInteger i = 0; i < countHandlers; i++)
	{
		WiimoteDeviceEventHandler *handler = [m_ReportHandlers objectAtIndex:i];

		if([handler target] == target &&
		   [handler action] == action)
		{
			[m_ReportHandlers removeObjectAtIndex:i];
			countHandlers--;
			i--;
		}
	}
}

- (void)removeReportHandler:(id)target
{
	NSUInteger countHandlers = [m_ReportHandlers count];

	for(NSUInteger i = 0; i < countHandlers; i++)
	{
		WiimoteDeviceEventHandler *handler = [m_ReportHandlers objectAtIndex:i];

		if([handler target] == target)
		{
			[m_ReportHandlers removeObjectAtIndex:i];
			countHandlers--;
			i--;
		}
	}
}

- (void)addDisconnectHandler:(id)target action:(SEL)action
{
	[m_DisconnectHandlers addObject:
		[WiimoteDeviceEventHandler
                    newHandlerWithTarget:target action:action]];
}

- (void)removeDisconnectHandler:(id)target action:(SEL)action
{
	NSUInteger countHandlers = [m_DisconnectHandlers count];

	for(NSUInteger i = 0; i < countHandlers; i++)
	{
		WiimoteDeviceEventHandler *handler = [m_DisconnectHandlers objectAtIndex:i];

		if([handler target] == target &&
		   [handler action] == action)
		{
			[m_DisconnectHandlers removeObjectAtIndex:i];
			countHandlers--;
			i--;
		}
	}
}

- (void)removeDisconnectHandler:(id)target
{
	NSUInteger countHandlers = [m_DisconnectHandlers count];

	for(NSUInteger i = 0; i < countHandlers; i++)
	{
		WiimoteDeviceEventHandler *handler = [m_DisconnectHandlers objectAtIndex:i];

		if([handler target] == target)
		{
			[m_DisconnectHandlers removeObjectAtIndex:i];
			countHandlers--;
			i--;
		}
	}
}

- (void)removeHandler:(id)target
{
    [self removeReportHandler:target];
    [self removeDisconnectHandler:target];
}

- (void)removeAllHandlers
{
	[m_DisconnectHandlers removeAllObjects];
	[m_ReportHandlers removeAllObjects];
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

- (void)handleReadMemoryReport:(WiimoteDeviceReport*)report
{
    NSData                              *data         = [report data];
    const WiimoteDeviceReadMemoryReport *memoryReport =
                                            (const WiimoteDeviceReadMemoryReport*)[data bytes];

    if([report type] != WiimoteDeviceReportTypeReadMemory ||
       [data length] < sizeof(WiimoteDeviceReadMemoryReport))
    {
        return;
    }

    if(((memoryReport->errorAndDataSize &
            WiimoteDeviceReadMemoryReportErrorMask) >>
                WiimoteDeviceReadMemoryReportErrorOffset) !=
                                        WiimoteDeviceReadMemoryReportErrorOk)
    {
        [m_CurrentMemHandler errorOccured];
        [m_CurrentMemHandler release];
        m_CurrentMemHandler = nil;
        return;
    }

    NSUInteger dataSize = ((memoryReport->errorAndDataSize &
                                WiimoteDeviceReadMemoryReportDataSizeMask) >>
                                    WiimoteDeviceReadMemoryReportDataSizeOffset) + 1;

    if(![m_CurrentMemHandler handleData:
                                    [NSData dataWithBytes:memoryReport->data
                                                   length:dataSize]])
    {
        [m_CurrentMemHandler release];
        m_CurrentMemHandler = nil;
    }
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    if(m_CurrentMemHandler != nil)
    {
        [self handleReadMemoryReport:report];

        if(m_CurrentMemHandler == nil)
            [self runReadMemHandler:[self nextReadMemHandlerFromQueue]];
    }

    for(NSUInteger i = 0; i < [m_ReportHandlers count]; i++)
    {
        WiimoteDeviceEventHandler *handler = [m_ReportHandlers objectAtIndex:i];

        [handler perform:report];

        if(i >= [m_ReportHandlers count])
            break;

        if([m_ReportHandlers objectAtIndex:i] != handler)
        {
            i--;
            continue;
        }
    }
}

- (void)handleDisconnect
{
    if(m_CurrentMemHandler != 0)
    {
        [m_CurrentMemHandler disconnected];
        [m_CurrentMemHandler release];
        m_CurrentMemHandler = nil;
    }

    while([m_ReadMemHandlersQueue count] != 0)
    {
        [[m_ReadMemHandlersQueue objectAtIndex:0] disconnected];
        [m_ReadMemHandlersQueue removeObjectAtIndex:0];
    }

	for(NSUInteger i = 0; i < [m_DisconnectHandlers count]; i++)
	{
		WiimoteDeviceEventHandler *handler = [m_DisconnectHandlers objectAtIndex:i];

		[handler perform:self];

        if(i >= [m_DisconnectHandlers count])
            break;

        if([m_DisconnectHandlers objectAtIndex:i] != handler)
        {
            i--;
            continue;
        }
    }
}

- (BOOL)isReadMemHandlersQueueEmpty
{
    return ([m_ReadMemHandlersQueue count] == 0);
}

- (void)addReadMemHandlerToQueue:(WiimoteDeviceReadMemHandler*)handler
{
    [m_ReadMemHandlersQueue addObject:handler];
}

- (WiimoteDeviceReadMemHandler*)nextReadMemHandlerFromQueue
{
    if([m_ReadMemHandlersQueue count] == 0)
        return nil;

    WiimoteDeviceReadMemHandler *result =
        [[[m_ReadMemHandlersQueue objectAtIndex:0] retain] autorelease];

    [m_ReadMemHandlersQueue removeObjectAtIndex:0];
    return result;
}

- (BOOL)runReadMemHandler:(WiimoteDeviceReadMemHandler*)handler
{
    if(handler == nil)
        return NO;

    WiimoteDeviceReadMemoryParams params;
    NSRange                       memoryRange = [handler memoryRange];

    if(memoryRange.length == 0)
        return YES;

    params.address = OSSwapHostToBigConstInt32((uint32_t)memoryRange.location);
    params.length  = OSSwapHostToBigConstInt16((uint16_t)memoryRange.length);

	NSData *commandData = [NSData dataWithBytes:&params length:sizeof(params)];

	if([self postCommand:WiimoteDeviceCommandTypeReadMemory
                    data:commandData])
    {
        m_CurrentMemHandler = [handler retain];
        return YES;
    }

    [m_CurrentMemHandler errorOccured];
    return NO;
}

@end

@implementation WiimoteDevice (IOBluetoothL2CAPChannelDelegate)

- (void)l2capChannelData:(IOBluetoothL2CAPChannel*)l2capChannel
                    data:(void*)dataPointer
                  length:(size_t)dataLength
{
	[self handleReport:[WiimoteDeviceReport
                                parseReportData:dataPointer
                                         length:dataLength
                                         device:self]];
}

- (void)l2capChannelClosed:(IOBluetoothL2CAPChannel*)l2capChannel
{
    [self disconnect];
}

@end
