//
//  WiimoteEventDispatcher+Private.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+Private.h"

@implementation WiimoteEventDispatcher (Private)

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithOwner:(Wiimote*)owner
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Owner                         = owner;
    m_IsStateNotificationsEnabled   = YES;

    return self;
}

- (void)setStateNotificationsEnabled:(BOOL)flag
{
    m_IsStateNotificationsEnabled = flag;
}

- (void)postConnectedNotification
{
    [[NSNotificationCenter defaultCenter]
                        postNotificationName:WiimoteConnectedNotification
                                      object:[self owner]];
}

- (void)postDisconnectNotification
{
    [[self delegate] wiimoteDisconnected:[self owner]];

    [[NSNotificationCenter defaultCenter]
                        postNotificationName:WiimoteDisconnectedNotification
                                      object:[self owner]];
}

- (void)setDelegate:(id)delegate
{
    m_Delegate = delegate;
}

@end
