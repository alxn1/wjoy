//
//  WiimoteEventDispatcher.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote.h"

@interface WiimoteEventDispatcher : NSObject
{
    @private
        Wiimote *m_Owner;
        BOOL     m_IsStateNotificationsEnabled;

        id       m_Delegate;
}

- (Wiimote*)owner;
- (id)delegate;

- (BOOL)isStateNotificationsEnabled;

@end
