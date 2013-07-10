//
//  WiimoteWatchdog.m
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteWatchdog.h"
#import "Wiimote.h"

#import <Cocoa/Cocoa.h>

NSString *WiimoteWatchdogEnabledChangedNotification  = @"WiimoteWatchdogEnabledChangedNotification";
NSString *WiimoteWatchdogPingNotification            = @"WiimoteWatchdogPingNotification";

@interface WiimoteWatchdog (PrivatePart)

- (id)initInternal;

- (void)onTimer:(id)sender;

- (void)applicationWillTerminateNotification:(NSNotification*)notification;

@end

@implementation WiimoteWatchdog

+ (WiimoteWatchdog*)sharedWatchdog
{
    static WiimoteWatchdog *result = nil;

    if(result == nil)
        result = [[WiimoteWatchdog alloc] initInternal];

    return result;
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [m_Timer invalidate];
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
        m_Timer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                                   target:self
                                                 selector:@selector(onTimer:)
                                                 userInfo:nil
                                                  repeats:YES];

        [[NSRunLoop currentRunLoop] addTimer:m_Timer forMode:NSRunLoopCommonModes];

        [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                   selector:@selector(applicationWillTerminateNotification:)
                                       name:NSApplicationWillTerminateNotification
                                     object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [m_Timer invalidate];
        m_Timer = nil;
    }

    if(m_IsPingNotificationEnabled)
    {
        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteWatchdogEnabledChangedNotification
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

@implementation WiimoteWatchdog (PrivatePart)

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
    NSArray     *connectedDevices   = [Wiimote connectedDevices];
    NSUInteger   countDevices       = [connectedDevices count];

    for(NSUInteger i = 0; i < countDevices; i++)
    {
        Wiimote *device = [connectedDevices objectAtIndex:i];
        [device requestUpdateState];
    }

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteWatchdogPingNotification
                                          object:self];
}

- (void)applicationWillTerminateNotification:(NSNotification*)notification
{
    NSArray     *connectedDevices   = [[[Wiimote connectedDevices] copy] autorelease];
    NSUInteger   countDevices       = [connectedDevices count];

    for(NSUInteger i = 0; i < countDevices; i++)
        [[connectedDevices objectAtIndex:i] disconnect];
}

@end
