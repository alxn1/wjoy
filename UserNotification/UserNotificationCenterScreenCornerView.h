//
//  UserNotificationCenterScreenCornerView.h
//  UserNotification
//
//  Created by alxn1 on 20.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <UserNotification/UserNotificationCenter.h>

@interface UserNotificationCenterScreenCornerView : NSView
{
    @private
        NSImage                            *m_BGImage;

        UserNotificationCenterScreenCorner  m_ScreenCorner;
        int                                 m_UnderMouseScreenCorner;
        int                                 m_DraggedMouseScreenCorner;
        int                                 m_ClickedMouseScreenCorner;
        BOOL                                m_IsEnabled;

        id                                  m_Target;
        SEL                                 m_Action;

        NSTrackingRectTag                   m_TrackingRectTags[4];
}

+ (NSSize)bestSize;

- (BOOL)isEnabled;
- (void)setEnabled:(BOOL)enabled;

- (UserNotificationCenterScreenCorner)screenCorner;
- (void)setScreenCorner:(UserNotificationCenterScreenCorner)corner;

- (id)target;
- (void)setTarget:(id)obj;

- (SEL)action;
- (void)setAction:(SEL)sel;

@end
