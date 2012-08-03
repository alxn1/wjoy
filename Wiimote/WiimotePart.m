//
//  WiimotePart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePartSet.h"

@implementation WiimotePart

+ (void)registerPartClass:(Class)cls
{
    [WiimotePartSet registerPartClass:cls];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Owner             = owner;
    m_EventDispatcher   = dispatcher;
    m_IOManager         = ioManager;

    return self;
}

- (Wiimote*)owner
{
    return m_Owner;
}

- (WiimoteIOManager*)ioManager
{
    return m_IOManager;
}

- (WiimoteEventDispatcher*)eventDispatcher
{
    return m_EventDispatcher;
}

- (NSSet*)allowedReportTypeSet
{
    return nil;
}

- (void)connected
{
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
}

- (void)disconnected
{
}

@end
