//
//  WiimoteMotionPlus.m
//  Wiimote
//
//  Created by alxn1 on 13.09.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteMotionPlus.h"
#import "WiimoteExtensionProbeHandler.h"
#import "WiimoteEventDispatcher+MotionPlus.h"
#import "Wiimote.h"

@implementation WiimoteMotionPlus

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteMotionPlus class]];
}

+ (NSUInteger)merit
{
    return WiimoteExtensionMeritClassMotionPlus;
}

+ (NSUInteger)minReportDataSize
{
    return 6;
}

+ (NSArray*)motionPlusSignatures
{
	static const uint8_t  signature1[]   = { 0x00, 0x00, 0xA4, 0x20, 0x04, 0x05 };
	static const uint8_t  signature2[]   = { 0x00, 0x00, 0xA4, 0x20, 0x05, 0x05 };
	static const uint8_t  signature3[]   = { 0x00, 0x00, 0xA4, 0x20, 0x07, 0x05 };

    static NSArray       *result         = nil;

    if(result == nil)
	{
		result = [[NSArray alloc] initWithObjects:
					[NSData dataWithBytes:signature1 length:sizeof(signature1)],
					[NSData dataWithBytes:signature2 length:sizeof(signature2)],
					[NSData dataWithBytes:signature3 length:sizeof(signature3)],
					nil];
	}

    return result;
}

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action
{
    [WiimoteExtensionProbeHandler
                            routineProbe:ioManager
							  signatures:[WiimoteMotionPlus motionPlusSignatures]
                                  target:target
                                  action:action];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher];
    if(self == nil)
        return nil;

    m_SubExtension					= nil;
    m_IOManager						= nil;
	m_ReportCounter					= 0;
	m_ExtensionReportCounter		= 0;
	m_IsSubExtensionDisconnected	= NO;

    return self;
}

- (void)dealloc
{
    [m_SubExtension release];
    [m_IOManager release];
    [super dealloc];
}

- (void)calibrate:(WiimoteIOManager*)ioManager
{
    m_IOManager = [ioManager retain];
}

- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length
{
    if(length < 6)
        return;

	BOOL isExtensionConnected	= ((extensionData[5] & 0x1) == 1);
	BOOL isExtensionDataReport  = ((extensionData[5] & 0x2) == 0);

	if(m_SubExtension == nil && isExtensionConnected)
	{
		[self deactivate];
		return;
	}

	m_ReportCounter++;
	if(isExtensionDataReport)
		m_ExtensionReportCounter++;

	if(m_ReportCounter == 10)
	{
		BOOL needDeactivate = NO;

		if((m_SubExtension == nil && m_ExtensionReportCounter != 0) ||
		   (m_SubExtension != nil && m_ExtensionReportCounter == 0))
		{
			needDeactivate = YES;
		}

		m_ReportCounter			 = 0;
		m_ExtensionReportCounter = 0;

		if(needDeactivate)
		{
			[self deactivate];
			return;
		}
	}

    if(isExtensionDataReport)
    {
		if(!m_IsSubExtensionDisconnected)
			[m_SubExtension handleMotionPlusReport:extensionData length:length];

        return;
    }

    m_Report.yaw.speed			= extensionData[0];
	m_Report.roll.speed			= extensionData[1];
	m_Report.pitch.speed        = extensionData[2];

	m_Report.yaw.speed		   |= ((uint16_t)(extensionData[3] >> 2)) << 8;
	m_Report.roll.speed		   |= ((uint16_t)(extensionData[4] >> 2)) << 8;
	m_Report.pitch.speed       |= ((uint16_t)(extensionData[5] >> 2)) << 8;

	m_Report.yaw.isSlowMode		= ((extensionData[3] & 2) != 0);
	m_Report.roll.isSlowMode    = ((extensionData[4] & 2) != 0);
	m_Report.pitch.isSlowMode   = ((extensionData[3] & 1) != 0);

	[[self eventDispatcher]
					postMotionPlus:self
							report:&m_Report];
}

- (void)setSubExtension:(WiimoteExtension*)extension
{
    if(extension != nil &&
     ![extension isSupportMotionPlus])
    {
        m_IsSubExtensionDisconnected = YES;
    }

    if(m_SubExtension == extension)
        return;

    [m_SubExtension release];
    m_SubExtension = [extension retain];

	if(extension != nil && !m_IsSubExtensionDisconnected)
	{
		[[self eventDispatcher]
						postMotionPlus:self
					extensionConnected:extension];
	}
}

- (NSString*)name
{
    return @"Motion Plus";
}

- (void)disconnected
{
	[self disconnectSubExtension];
}

- (const WiimoteMotionPlusReport*)lastReport
{
    return (&m_Report);
}

- (WiimoteExtension*)subExtension
{
	if(m_IsSubExtensionDisconnected)
		return nil;

    return [[m_SubExtension retain] autorelease];
}

- (void)disconnectSubExtension
{
	if(m_IsSubExtensionDisconnected ||
	   m_SubExtension == nil)
	{
		return;
	}

	m_IsSubExtensionDisconnected = YES;

	[[self eventDispatcher]
					postMotionPlus:self
			 extensionDisconnected:m_SubExtension];
}

- (void)deactivate
{
    uint8_t data = WiimoteDeviceMotionPlusExtensionInitOrResetValue;

    [m_IOManager writeMemory:WiimoteDeviceMotionPlusExtensionResetAddress
                        data:&data
                      length:sizeof(data)];

    usleep(50000);

	[[self owner] reconnectExtension];
}

@end
