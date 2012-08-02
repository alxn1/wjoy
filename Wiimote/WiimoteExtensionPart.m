//
//  WiimoteExtensionPart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtensionPart.h"
#import "WiimoteEventDispatcher+Extension.h"
#import "WiimoteExtensionHelper.h"

@interface WiimoteExtensionPart (PrivatePart)

- (NSData*)extractExtensionReportPart:(WiimoteDeviceReport*)report;
- (void)processExtensionReport:(WiimoteDeviceReport*)report;

- (void)extensionConnected;
- (void)extensionDisconnected;

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

    return self;
}

- (void)dealloc
{
    [self extensionDisconnected];
    [super dealloc];
}

- (WiimoteExtension*)connectedExtension
{
    if(!m_IsExtensionConnected)
        return nil;

    return [[m_Extension retain] autorelease];
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

    return [NSSet setWithObject:
                    [NSNumber numberWithInteger:
                                    WiimoteDeviceReportTypeButtonAndExtensionState]];
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    [self processExtensionReport:report];

    if([report type] != WiimoteDeviceReportTypeState ||
      [[report data] length] < sizeof(WiimoteDeviceStateReport))
    {
        return;
    }

    const WiimoteDeviceStateReport *state =
                (const WiimoteDeviceStateReport*)[[report data] bytes];

    BOOL isExtensionConnected = ((state->flagsAndLEDState &
                        WiimoteDeviceStateReportFlagExtensionConnected) != 0);

    if(m_IsExtensionConnected == isExtensionConnected)
        return;

    m_IsExtensionConnected = isExtensionConnected;

    if(isExtensionConnected)
        [self extensionConnected];
    else
        [self extensionDisconnected];

    [[self owner] deviceConfigurationChanged];
}

- (void)disconnected
{
    [self extensionDisconnected];
}

@end

@implementation WiimoteExtensionPart (PrivatePart)

- (NSData*)extractExtensionReportPart:(WiimoteDeviceReport*)report
{
    if([report type] != WiimoteDeviceReportTypeButtonAndExtensionState)
        return nil;

    if([[report data] length] < sizeof(WiimoteDeviceButtonAndExtensionStateReport))
        return nil;

    const WiimoteDeviceButtonAndExtensionStateReport *stateReport =
            (const WiimoteDeviceButtonAndExtensionStateReport*)[[report data] bytes];

    return [NSData dataWithBytes:stateReport->data
                          length:sizeof(stateReport->data)];
}

- (void)processExtensionReport:(WiimoteDeviceReport*)report
{
    if(m_Extension == nil)
        return;

    NSData *extensionReportPart = [self extractExtensionReportPart:report];

    if(extensionReportPart == nil)
        return;

    [m_Extension handleReport:extensionReportPart];
}

- (void)initializeExtensionPort
{
    NSMutableData *data = [NSMutableData dataWithLength:1];

    *((uint8_t*)[data mutableBytes]) = WiimoteDeviceRoutineInitValue1;
    [[self ioManager] writeMemory:WiimoteDeviceRoutineInitAddress1 data:data];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];

    *((uint8_t*)[data mutableBytes]) = WiimoteDeviceRoutineInitValue2;
    [[self ioManager] writeMemory:WiimoteDeviceRoutineInitAddress2 data:data];
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
}

- (void)extensionConnected
{
    [self extensionDisconnected];
    [self initializeExtensionPort];

    m_ProbeHelper = [[WiimoteExtensionHelper alloc]
                                          initWithWiimote:[self owner]
                                          eventDispatcher:[self eventDispatcher]
                                                ioManager:[self ioManager]
                                         extensionClasses:[WiimoteExtensionPart registredExtensionClasses]
                                                   target:self
                                                   action:@selector(extensionCreated:)];

    [m_ProbeHelper start];
}

- (void)extensionCreated:(WiimoteExtension*)extension
{
    m_Extension = [extension retain];
    [m_ProbeHelper release];
	m_ProbeHelper = nil;

	if(m_Extension != nil)
	{
        [[self eventDispatcher] postExtensionConnectedNotification:m_Extension];
        [[self owner] deviceConfigurationChanged];
    }
}

- (void)extensionDisconnected
{
    if(m_Extension != nil)
        [[self eventDispatcher] postExtensionDisconnectedNotification:m_Extension];

    [m_ProbeHelper cancel];
    [m_ProbeHelper release];
    [m_Extension autorelease];

    m_ProbeHelper   = nil;
    m_Extension     = nil;
}

@end
