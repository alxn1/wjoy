//
//  WiimoteEventDispatcher.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher.h"

@implementation WiimoteEventDispatcher

+ (void)postConnectedNotification:(Wiimote*)wiimote
{
    [[NSNotificationCenter defaultCenter]
                        postNotificationName:WiimoteConnectedNotification
                                      object:wiimote];
}

- (Wiimote*)owner
{
    return m_Owner;
}

- (id)delegate
{
    return m_Delegate;
}

- (BOOL)isStateNotificationsEnabled
{
    return m_IsStateNotificationsEnabled;
}

@end
