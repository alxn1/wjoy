//
//  WiimoteDeviceReadMemQueue.m
//  Wiimote
//
//  Created by alxn1 on 02.08.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReadMemQueue.h"
#import "WiimoteDeviceReadMemHandler.h"
#import "WiimoteProtocol.h"
#import "WiimoteDevice.h"

#import "WiimoteLog.h"

@interface WiimoteDeviceReadMemQueue (PrivatePart)

- (BOOL)isQueueEmpty;
- (WiimoteDeviceReadMemHandler*)nextHandlerFromQueue;
- (void)addHandlerToQueue:(WiimoteDeviceReadMemHandler*)handler;
- (BOOL)runHandler:(WiimoteDeviceReadMemHandler*)handler;
- (void)runNextHandler;

@end

@implementation WiimoteDeviceReadMemQueue

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

	m_Device				= device;
	m_ReadMemHandlersQueue	= [[NSMutableArray alloc] init];
	m_CurrentMemHandler		= nil;

	return self;
}

- (void)dealloc
{
	[m_ReadMemHandlersQueue release];
    [m_CurrentMemHandler release];
	[super dealloc];
}

- (BOOL)readMemory:(NSRange)memoryRange
			target:(id)target
			action:(SEL)action
{
	if(![m_Device isConnected])
		return NO;

	if(memoryRange.length == 0)
        return YES;

	WiimoteDeviceReadMemHandler *handler =
			[[[WiimoteDeviceReadMemHandler alloc]
									initWithMemoryRange:memoryRange
												 target:target
												 action:action] autorelease];

	if(m_CurrentMemHandler == nil)
		return [self runHandler:handler];

    [self addHandlerToQueue:handler];
	return YES;
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
	if(m_CurrentMemHandler == nil)
		return;

    if([report type]    != WiimoteDeviceReportTypeReadMemory ||
       [report length]  < sizeof(WiimoteDeviceReadMemoryReport))
    {
        return;
    }

    const WiimoteDeviceReadMemoryReport *memoryReport =
                                            (const WiimoteDeviceReadMemoryReport*)[report data];

    if(((memoryReport->errorAndDataSize &
            WiimoteDeviceReadMemoryReportErrorMask) >>
                WiimoteDeviceReadMemoryReportErrorOffset) !=
                                        WiimoteDeviceReadMemoryReportErrorOk)
    {
        [m_CurrentMemHandler errorOccured];
        [self runNextHandler];
        return;
    }

    NSUInteger dataSize = ((memoryReport->errorAndDataSize &
                                WiimoteDeviceReadMemoryReportDataSizeMask) >>
                                    WiimoteDeviceReadMemoryReportDataSizeOffset) + 1;

    [m_CurrentMemHandler handleData:memoryReport->data length:dataSize];

	if([m_CurrentMemHandler isAllDataReaded])
        [self runNextHandler];
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
}

@end

@implementation WiimoteDeviceReadMemQueue (PrivatePart)

- (BOOL)isQueueEmpty
{
	return ([m_ReadMemHandlersQueue count] == 0);
}

- (WiimoteDeviceReadMemHandler*)nextHandlerFromQueue
{
	if([self isQueueEmpty])
		return nil;

	WiimoteDeviceReadMemHandler *result =
			[[[m_ReadMemHandlersQueue objectAtIndex:0] retain] autorelease];

	[m_ReadMemHandlersQueue removeObjectAtIndex:0];
	return result;
}

- (void)addHandlerToQueue:(WiimoteDeviceReadMemHandler*)handler
{
	[m_ReadMemHandlersQueue addObject:handler];
}

- (BOOL)runHandler:(WiimoteDeviceReadMemHandler*)handler
{
	if(handler == nil)
        return NO;

    WiimoteDeviceReadMemoryParams params;
    NSRange                       memoryRange = [handler memoryRange];

    params.address = OSSwapHostToBigConstInt32((uint32_t)memoryRange.location);
    params.length  = OSSwapHostToBigConstInt16((uint16_t)memoryRange.length);

	if([m_Device postCommand:WiimoteDeviceCommandTypeReadMemory
						data:(const uint8_t*)&params
                      length:sizeof(params)])
    {
        m_CurrentMemHandler = [handler retain];
        return YES;
    }

    W_ERROR(@"[WiimoteDevice postCommand: data: length:] failed");
    [handler errorOccured];
    return NO;
}

- (void)runNextHandler
{
	[m_CurrentMemHandler release];
	m_CurrentMemHandler = nil;

	while(![self isQueueEmpty])
	{
		if([self runHandler:[self nextHandlerFromQueue]])
			break;
	}
}

@end
