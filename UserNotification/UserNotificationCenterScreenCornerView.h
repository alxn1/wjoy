//
//  UserNotificationCenterScreenCornerView.h
//  UserNotification
//
//  Created by alxn1 on 20.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UserNotificationCenter.h"

@interface UserNotificationCenterScreenCornerView : NSView {
@private
    NSImage                            *bgImage;

    UserNotificationCenterScreenCorner  screenCorner;
    int                                 underMouseScreenCorner;
    int                                 draggedMouseScreenCorner;
    int                                 clickedMouseScreenCorner;
    BOOL                                isEnabled;

    id                                  target;
    SEL                                 action;

    NSTrackingRectTag                   trackingRectTags[4];
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
