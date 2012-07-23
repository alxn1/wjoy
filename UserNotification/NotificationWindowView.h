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
        NSImage                             *icon;
        NSString                            *title;
        NSString                            *text;

        NSTrackingRectTag                    trackingRectTag;

        BOOL                                 isHowered;
        BOOL                                 isCloseButtonDragged;
        BOOL                                 isCloseButtonPressed;
        BOOL                                 isAlreadyClicked;

        id                                   target;
        SEL                                  action;

        id<NotificationWindowViewDelegate>   delegate;
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
