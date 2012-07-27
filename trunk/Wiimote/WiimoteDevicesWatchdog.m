//
//  WiimoteDevicesWatchdog.m
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevicesWatchdog.h"
#import "WiimoteDevice.h"

NSString *WiimoteDevicesWatchdogEnabledChangedNotification  = @"WiimoteDevicesWatchdogEnabledChangedNotification";
NSString *WiimoteDevicesWatchdogPingNotification            = @"WiimoteDevicesWatchdogPingNotification";

@interface WiimoteDevicesWatchdog (PrivatePart)

- (id)initInternal;

- (void)onTimer:(id)sender;

@end

@implementation WiimoteDevicesWatchdog

+ (WiimoteDevicesWatchdog*)sharedWatchdog
{
    static WiimoteDevicesWatchdog *result = nil;

    if(result == nil)
        result = [[WiimoteDevicesWatchdog alloc] initInternal];

    return result;
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (void)dealloc
{
    [self setEnabled:NO];
    [super dealloc];
}

- (BOOL)isEnabled
{
    return (m_Timer != nil);
}

- (void)setEnabled:(BOOL)enabled
{
    if([self isEnabled] == enabled)
        return;

    if(enabled)
    {
        m_Timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(onTimer:)
                                                 userInfo:nil
                                                  repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:m_Timer forMode:NSEventTrackingRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:m_Timer forMode:NSModalPanelRunLoopMode];
    }
    else
    {
        [m_Timer invalidate];
        m_Timer = nil;
    }

    if(m_IsPingNotificationEnabled)
    {
        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteDevicesWatchdogEnabledChangedNotification
                                              object:self];
    }
}

- (BOOL)isPingNotificationEnabled
{
    return m_IsPingNotificationEnabled;
}

- (void)setPingNotificationEnabled:(BOOL)enabled
{
    m_IsPingNotificationEnabled = enabled;
}

@end

@implementation WiimoteDevicesWatchdog (PrivatePart)

- (id)initInternal
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Timer                     = nil;
    m_IsPingNotificationEnabled = YES;

    return self;
}

- (void)onTimer:(id)sender
{
    NSArray     *connectedDevices   = [WiimoteDevice connectedDevices];
    NSUInteger   countDevices       = [connectedDevices count];

    for(NSUInteger i = 0; i < countDevices; i++)
    {
        WiimoteDevice *device = [connectedDevices objectAtIndex:i];
        [device updateState];
    }

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteDevicesWatchdogPingNotification
                                          object:self];
}

@end
