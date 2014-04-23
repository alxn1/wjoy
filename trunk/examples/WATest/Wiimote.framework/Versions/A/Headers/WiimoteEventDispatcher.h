//
//  WiimoteEventDispatcher.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Wiimote;

@interface WiimoteEventDispatcher : NSObject
{
    @private
        Wiimote *m_Owner;
        BOOL     m_IsStateNotificationsEnabled;

        id       m_Delegate;
}

- (Wiimote*)owner;

- (BOOL)isStateNotificationsEnabled;

- (void)postNotification:(NSString*)notification;
- (void)postNotification:(NSString*)notification sender:(id)sender;
- (void)postNotification:(NSString*)notification param:(id)param key:(NSString*)key;
- (void)postNotification:(NSString*)notification param:(id)param key:(NSString*)key sender:(id)sender;
- (void)postNotification:(NSString*)notification params:(NSDictionary*)params;
- (void)postNotification:(NSString*)notification params:(NSDictionary*)params sender:(id)sender;

- (id)delegate;

@end
