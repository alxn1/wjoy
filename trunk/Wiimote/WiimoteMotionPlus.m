//
//  WiimoteMotionPlus.m
//  Wiimote
//
//  Created by alxn1 on 13.09.12.
//  Copyright 2012 Dr. Web. All rights reserved.
//

#import "WiimoteMotionPlus.h"
#import "WiimoteExtensionProbeHandler.h"

@interface WiimoteMotionPlus (PrivatePart)

- (void)deactivate;

@end

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
    // ???
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

    m_SubExtension				= nil;
    m_IOManager					= nil;
	m_ReportCounter				= 0;
	m_ExtensionReportCounter	= 0;

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

	BOOL isExtensionDataReport  = ((extensionData[5] & 0x2) == 0);

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
        [m_SubExtension handleMotionPlusReport:extensionData length:length];
        return;
    }

    // ???
    // handle motion plus data here
}

- (void)setSubExtension:(WiimoteExtension*)extension
{
    if(extension != nil &&
     ![extension isSupportMotionPlus])
    {
        extension = nil;
    }

    if(m_SubExtension == extension)
        return;

    [m_SubExtension release];
    m_SubExtension = [extension retain];
}

- (NSString*)name
{
    return @"Motion Plus";
}

- (WiimoteExtension*)subExtension
{
    return [[m_SubExtension retain] autorelease];
}

- (void)disconnectSubExtension
{
    // ???
}

@end

@implementation WiimoteMotionPlus (PrivatePart)

- (void)deactivate
{
    uint8_t data = WiimoteDeviceMotionPlusExtensionInitOrResetValue;

    [m_IOManager writeMemory:WiimoteDeviceMotionPlusExtensionResetAddress
                        data:&data
                      length:sizeof(data)];

    usleep(50000);
}

@end
