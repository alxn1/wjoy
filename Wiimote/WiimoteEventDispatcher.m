//
//  WiimoteEventDispatcher.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher.h"

@implementation WiimoteEventDispatcher

- (Wiimote*)owner
{
    return m_Owner;
}

- (BOOL)isStateNotificationsEnabled
{
    return m_IsStateNotificationsEnabled;
}

- (void)postNotification:(NSString*)notification
{
    [self postNotification:notification sender:[self owner]];
}

- (void)postNotification:(NSString*)notification sender:(id)sender
{
    [self postNotification:notification params:nil sender:[self owner]];
}

- (void)postNotification:(NSString*)notification param:(id)param key:(NSString*)key
{
    [self postNotification:notification param:param key:key sender:[self owner]];
}

- (void)postNotification:(NSString*)notification param:(id)param key:(NSString*)key sender:(id)sender
{
    NSDictionary *params = nil;

    if(param != nil && key != nil)
        params = [NSDictionary dictionaryWithObject:param forKey:key];

    [self postNotification:notification
                    params:params
                    sender:sender];
}

- (void)postNotification:(NSString*)notification params:(NSDictionary*)params
{
    [self postNotification:notification params:params sender:[self owner]];
}

- (void)postNotification:(NSString*)notification params:(NSDictionary*)params sender:(id)sender
{
    [[NSNotificationCenter defaultCenter]
                                postNotificationName:notification
                                              object:sender
                                            userInfo:params];
}

- (id)delegate
{
    return m_Delegate;
}

@end
