//
//  WiimoteDeviceEventDispatcher.m
//  Wiimote
//
//  Created by alxn1 on 02.08.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceEventDispatcher.h"
#import "WiimoteDeviceEventHandler.h"

@implementation WiimoteDeviceEventDispatcher

- (id)init
{
	self = [super init];
	if(self == nil)
		return nil;

	m_ReportHandlers		= [[NSMutableArray alloc] init];
	m_DisconnectHandlers	= [[NSMutableArray alloc] init];

	return self;
}

- (void)dealloc
{
	[m_ReportHandlers release];
	[m_DisconnectHandlers release];
	[super dealloc];
}

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

- (void)handleReport:(WiimoteDeviceReport*)report
{
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

@end
