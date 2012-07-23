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
        UserNotification    *notification;
        NSTimer             *autocloseTimer;

        BOOL                 isMouseEntered;
        BOOL                 isCloseOnMouseExited;

        id                   target;
        SEL                  action;
}

// MARK: public

+ (NSRect)bestRectForNotification:(UserNotification*)aNotification;

+ (NotificationWindow*)newWindowWithNotification:(UserNotification*)aNotification frame:(NSRect)aFrame;

- (id)initWithNotification:(UserNotification*)aNotification frame:(NSRect)aFrame;
- (void)dealloc;

- (id)target;
- (void)setTarget:(id)obj;

- (SEL)action;
- (void)setAction:(SEL)sel;

- (void)showWithTimeout:(NSTimeInterval)timeout;
- (void)close;

- (UserNotification*)notification;

@end
