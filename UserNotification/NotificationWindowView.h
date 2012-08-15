//
//  NotificationWindowView.h
//  UserNotification
//
//  Created by alxn1 on 19.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NotificationWindowView;

@protocol NotificationWindowViewDelegate

- (void)notificationWindowViewMouseEntered:(NotificationWindowView*)view;
- (void)notificationWindowViewMouseExited:(NotificationWindowView*)view;

@end

@interface NotificationWindowView : NSView
{
    @private
        NSImage                             *m_Icon;
        NSString                            *m_Title;
        NSString                            *m_Text;

        NSTrackingRectTag                    m_TrackingRectTag;

        BOOL                                 m_IsHowered;
        BOOL                                 m_IsMouseDragged;
        BOOL                                 m_IsCloseButtonDragged;
        BOOL                                 m_IsCloseButtonPressed;
        BOOL                                 m_IsAlreadyClicked;

        id                                   m_Target;
        SEL                                  m_Action;

        id<NotificationWindowViewDelegate>   m_Delegate;
}

+ (NSRect)bestViewRectForTitle:(NSString*)title text:(NSString*)text;

- (NSImage*)icon;
- (void)setIcon:(NSImage*)img;

- (NSString*)title;
- (void)setTitle:(NSString*)str;

- (NSString*)text;
- (void)setText:(NSString*)str;

- (id)target;
- (void)setTarget:(id)obj;

- (SEL)action;
- (void)setAction:(SEL)sel;

- (id<NotificationWindowViewDelegate>)delegate;
- (void)setDelegate:(id<NotificationWindowViewDelegate>)obj;

@end
