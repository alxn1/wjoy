//
//  WiimoteDeviceEventDispatcher+Private.m
//  Wiimote
//
//  Created by alxn1 on 03.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceEventDispatcher+Private.h"
#import "WiimoteDeviceEventHandler.h"

@implementation WiimoteDeviceEventDispatcher (Private)

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
