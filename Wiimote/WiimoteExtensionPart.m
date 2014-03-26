//
//  WiimoteExtensionPart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtensionPart.h"
#import "WiimoteEventDispatcher+Extension.h"
#import "WiimoteMotionPlusDetector.h"
#import "WiimoteExtensionHelper.h"
#import "Wiimote+PlugIn.h"

@interface WiimoteExtensionPart (PrivatePart)

- (const uint8_t*)extractExtensionReportPart:(WiimoteDeviceReport*)report length:(NSUInteger*)length;
- (void)processExtensionReport:(WiimoteDeviceReport*)report;

- (void)extensionConnected;
- (void)extensionDisconnected;

- (void)motionPlusDetectFinish:(NSNumber*)detected;

@end

@implementation WiimoteExtensionPart

static NSInteger sortExtensionClassesByMeritFn(Class cls1, Class cls2, void *context)
{
    if([cls1 merit] > [cls2 merit])
        return NSOrderedDescending;

    if([cls1 merit] < [cls2 merit])
        return NSOrderedAscending;

    return NSOrderedSame;
}

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteExtensionPart class]];
}

+ (NSMutableArray*)registredExtensionClasses
{
    static NSMutableArray *result = nil;

    if(result == nil)
        result = [[NSMutableArray alloc] init];

    return result;
}

+ (void)sortExtensionClassesByMerit
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [[WiimoteExtensionPart registredExtensionClasses]
                                        sortUsingFunction:sortExtensionClassesByMeritFn
                                                  context:NULL];

    [pool release];
}

+ (void)registerExtensionClass:(Class)cls
{
    if(![[WiimoteExtensionPart registredExtensionClasses] containsObject:cls])
    {
        [[WiimoteExtensionPart registredExtensionClasses] addObject:cls];
        [WiimoteExtensionPart sortExtensionClassesByMerit];
    }
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher ioManager:ioManager];
    if(self == nil)
        return nil;

    m_ProbeHelper           = nil;
    m_Extension             = nil;
    m_IsExtensionConnected  = NO;
    m_MotionPlusDetector    = [[WiimoteMotionPlusDetector alloc]
                                                        initWithIOManager:ioManager
                                                                   target:self
                                                                   action:@selector(motionPlusDetectFinish:)];

    return self;
}

- (void)dealloc
{
    [self extensionDisconnected];
    [m_MotionPlusDetector release];
    [super dealloc];
}

- (WiimoteExtension*)connectedExtension
{
    if(!m_IsExtensionConnected)
        return nil;

    return [[m_Extension retain] autorelease];
}

- (void)detectMotionPlus
{
    if(m_ProbeHelper == nil)
        [m_MotionPlusDetector run];
}

- (void)reconnectExtension
{
	[self extensionDisconnected];
	m_IsExtensionConnected = NO;
	[[self owner] requestUpdateState];
}

- (void)disconnectExtension
{
    [self extensionDisconnected];
    [[self owner] deviceConfigurationChanged];
}

- (NSSet*)allowedReportTypeSet
{
    if(m_Extension == nil)
        return nil;

    NSUInteger       minReportDataSize  = [[m_Extension class] minReportDataSize];
    NSMutableSet    *result             = [NSMutableSet set];

    if(minReportDataSize <= 6)
    {
        [result addObject:[NSNumber numberWithInteger:
            WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes]];
    }

    if(minReportDataSize <= 8)
    {
        [result addObject:[NSNumber numberWithInteger:
            WiimoteDeviceReportTypeButtonAndExtension8BytesState]];
    }

    if(minReportDataSize <= 9)
    {
        [result addObject:[NSNumber numberWithInteger:
            WiimoteDeviceReportTypeButtonAndIR10BytesAndExtension9BytesState]];
    }

    if(minReportDataSize <= 16)
    {
        [result addObject:[NSNumber numberWithInteger:
            WiimoteDeviceReportTypeButtonAndAccelerometerAndExtension16BytesState]];
    }

    if(minReportDataSize <= 19)
    {
        [result addObject:[NSNumber numberWithInteger:
            WiimoteDeviceReportTypeButtonAndExtension19BytesState]];
    }

    return result;
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    [self processExtensionReport:report];

    if([report type]    != WiimoteDeviceReportTypeState ||
       [report length]  < sizeof(WiimoteDeviceStateReport))
    {
        return;
    }

    const WiimoteDeviceStateReport *state =
                (const WiimoteDeviceStateReport*)[report data];

    BOOL isExtensionConnected = ((state->flagsAndLEDState &
                        WiimoteDeviceStateReportFlagExtensionConnected) != 0);

    if(m_IsExtensionConnected == isExtensionConnected)
        return;

    m_IsExtensionConnected = isExtensionConnected;

    if(!isExtensionConnected)
        [self extensionDisconnected];
    else
        [self extensionConnected];

    [[self owner] deviceConfigurationChanged];
}

- (void)disconnected
{
    [self extensionDisconnected];
}

@end

@implementation WiimoteExtensionPart (PrivatePart)

- (const uint8_t*)extractExtensionReportPart:(WiimoteDeviceReport*)report length:(NSUInteger*)length;
{
    WiimoteDeviceReportType reportType              = (WiimoteDeviceReportType)[report type];
    NSUInteger              extensionBytesOffset    = 0;
    NSUInteger              extensionBytesSize      = 0;

    switch(reportType)
    {
        case WiimoteDeviceReportTypeButtonAndExtension8BytesState:
            extensionBytesOffset    = sizeof(WiimoteDeviceButtonState);
            extensionBytesSize      = 8;
            break;

        case WiimoteDeviceReportTypeButtonAndExtension19BytesState:
            extensionBytesOffset    = sizeof(WiimoteDeviceButtonState);
            extensionBytesSize      = 19;
            break;

        case WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes:
            extensionBytesOffset    = sizeof(WiimoteDeviceButtonState) + WiimoteDeviceAccelerometerDataSize + 10;
            extensionBytesSize      = 6;
            break;

        case WiimoteDeviceReportTypeButtonAndAccelerometerAndExtension16BytesState:
            extensionBytesOffset    = sizeof(WiimoteDeviceButtonState) + WiimoteDeviceAccelerometerDataSize;
            extensionBytesSize      = 16;
            break;

        case WiimoteDeviceReportTypeButtonAndIR10BytesAndExtension9BytesState:
            extensionBytesOffset    = sizeof(WiimoteDeviceButtonState) + 10;
            extensionBytesSize      = 9;
            break;
        
        default:
            return NULL;
    }

    if([report length] < (extensionBytesOffset + extensionBytesSize))
        return NULL;

    if(length != NULL)
        *length = extensionBytesSize;

    return ([report data] + extensionBytesOffset);
}

- (void)processExtensionReport:(WiimoteDeviceReport*)report
{
    if(m_Extension == nil)
        return;

    NSUInteger       length              = 0;
    const uint8_t   *extensionReportPart = [self extractExtensionReportPart:report length:&length];

    if(extensionReportPart == NULL)
        return;

    [m_Extension handleReport:extensionReportPart length:length];
}

- (void)extensionConnected
{
    WiimoteExtension *extension = [[m_Extension retain] autorelease];
    [self extensionDisconnected];

    m_ProbeHelper = [[WiimoteExtensionHelper alloc]
                                          initWithWiimote:[self owner]
                                          eventDispatcher:[self eventDispatcher]
                                                ioManager:[self ioManager]
                                         extensionClasses:[WiimoteExtensionPart registredExtensionClasses]
                                             subExtension:extension
                                                   target:self
                                                   action:@selector(extensionCreated:)];

    [m_ProbeHelper start];
}

- (void)extensionCreated:(WiimoteExtension*)extension
{
	WiimoteExtension *subExtension = [m_ProbeHelper subExtension];

    m_Extension = [extension retain];
    [m_ProbeHelper release];
	m_ProbeHelper = nil;

	if(m_Extension != nil)
	{
        [[self eventDispatcher] postExtensionConnectedNotification:m_Extension];
		[m_Extension setSubExtension:subExtension];
        [[self owner] deviceConfigurationChanged];
    }
}

- (void)extensionDisconnected
{
	WiimoteExtension *ex = m_Extension;

    [m_ProbeHelper cancel];
    [m_MotionPlusDetector cancel];
    [m_ProbeHelper release];
    [m_Extension autorelease];

    m_ProbeHelper   = nil;
    m_Extension     = nil;

	if(ex != nil)
	{
		[ex disconnected];
        [[self eventDispatcher] postExtensionDisconnectedNotification:ex];
	}
}

- (void)motionPlusDetectFinish:(NSNumber*)detected
{
    if(![detected boolValue])
        return;

    [WiimoteMotionPlusDetector
                    activateMotionPlus:[self ioManager]
                          subExtension:m_Extension];

    if(m_Extension != nil)
    {
        m_IsExtensionConnected = YES;
        [self extensionConnected];
    }
}

@end
