//
//  WiimotePartSet.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePartSet.h"
#import "WiimoteDeviceReport+Private.h"

@implementation WiimotePartSet

+ (NSMutableArray*)registredPartClasses
{
    static NSMutableArray *result = nil;

    if(result == nil)
        result = [[NSMutableArray alloc] init];

    return result;
}

+ (void)registerPartClass:(Class)cls
{
    if(![[WiimotePartSet registredPartClasses] containsObject:cls])
        [[WiimotePartSet registredPartClasses] addObject:cls];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithOwner:(Wiimote*)owner device:(WiimoteDevice*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    NSArray     *partClasses        = [WiimotePartSet registredPartClasses];
    NSUInteger   countPartClasses   = [partClasses count];

    m_Owner             = owner;
    m_Device            = device;
    m_IOManager         = [[WiimoteIOManager alloc] initWithOwner:owner device:device];
    m_EventDispatcher   = [[WiimoteEventDispatcher alloc] initWithOwner:owner];
    m_PartDictionary    = [[NSMutableDictionary alloc] initWithCapacity:countPartClasses];
    m_PartArray         = [[NSMutableArray alloc] initWithCapacity:countPartClasses];

    for(NSUInteger i = 0; i < countPartClasses; i++)
    {
        Class        partClass  = [partClasses objectAtIndex:i];
        WiimotePart *part       = [[partClass alloc] initWithOwner:owner
                                                   eventDispatcher:m_EventDispatcher
                                                         ioManager:m_IOManager];

        [m_PartDictionary setObject:part forKey:(id)partClass];
        [m_PartArray addObject:part];
        [part release];
    }

    return self;
}

- (void)dealloc
{
    [m_IOManager release];
    [m_EventDispatcher release];
    [m_PartDictionary release];
    [m_PartArray release];
    [super dealloc];
}

- (Wiimote*)owner
{
    return m_Owner;
}

- (WiimoteDevice*)device
{
    return m_Device;
}

- (WiimoteEventDispatcher*)eventDispatcher
{
    return m_EventDispatcher;
}

- (WiimotePart*)partWithClass:(Class)cls
{
    return [m_PartDictionary objectForKey:cls];
}

- (WiimoteDeviceReportType)bestReportType
{
    NSUInteger    countParts  = [m_PartArray count];
    NSMutableSet *reportTypes = [NSMutableSet setWithObjects:
                                    [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonState],
                                    [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerState],
                                    [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndExtension8BytesState],
                                    [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerAndIR12BytesState],
                                    [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndExtension19BytesState],
                                    [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerAndExtension16BytesState],
                                    [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndIR10BytesAndExtension9BytesState],
                                    [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes],
                                    nil];

    for(NSUInteger i = 0; i < countParts; i++)
    {
        NSSet *partReports = [[m_PartArray objectAtIndex:i] allowedReportTypeSet];

        if(partReports == nil)
            continue;

        [reportTypes intersectSet:partReports];
    }

    if([reportTypes count] == 0 ||
       [reportTypes containsObject:[NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonState]])
    {
        return WiimoteDeviceReportTypeButtonState;
    }

    return ((WiimoteDeviceReportType)
                    [[reportTypes anyObject] integerValue]);
}

- (void)connected
{
	NSUInteger countParts = [m_PartArray count];

    for(NSUInteger i = 0; i < countParts; i++)
        [[m_PartArray objectAtIndex:i] connected];
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    NSUInteger countParts = [m_PartArray count];

	[report setWiimote:[self owner]];
    for(NSUInteger i = 0; i < countParts; i++)
        [[m_PartArray objectAtIndex:i] handleReport:report];
}

- (void)disconnected
{
    NSUInteger countParts = [m_PartArray count];

    for(NSUInteger i = 0; i < countParts; i++)
        [[m_PartArray objectAtIndex:i] disconnected];
}

@end
