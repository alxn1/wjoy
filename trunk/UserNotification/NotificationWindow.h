//
//  NotificationWindow.h
//  UserNotification
//
//  Created by alxn1 on 19.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AnimatedWindow.h"
#import "UserNotification.h"
#import "NotificationWindowView.h"

@interface NotificationWindow : AnimatedWindow<NotificationWindowViewDelegate>
{
    @private
        UserNotification    *m_Notification;
        NSTimer             *m_AutocloseTimer;

        BOOL                 m_IsMouseEntered;
        BOOL                 m_IsCloseOnMouseExited;

        id                   m_Target;
        SEL                  m_Action;
}

+ (NSRect)bestRectForNotification:(UserNotification*)notification;

+ (NotificationWindow*)newWindowWithNotification:(UserNotification*)notification frame:(NSRect)frame;

- (id)initWithNotification:(UserNotification*)notification frame:(NSRect)frame;
- (void)dealloc;

- (id)target;
- (void)setTarget:(id)obj;

- (SEL)action;
- (void)setAction:(SEL)sel;

- (void)showWithTimeout:(NSTimeInterval)timeout;
- (void)close;

- (UserNotification*)notification;

@end
