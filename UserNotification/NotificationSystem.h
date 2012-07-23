//
//  NotificationSystem.h
//  UserNotification
//
//  Created by alxn1 on 19.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UserNotificationCenter.h"

@class NotificationSystem;
@class NotificationLayoutManager;

@protocol NotificationSystemDelegate

- (void)notificationSystem:(NotificationSystem*)system
       notificationClicked:(UserNotification*)notification;

@end

@interface NotificationSystem : NSObject
{
    @private
        NotificationLayoutManager       *layoutManager;
        NSMutableArray                  *notificationQueue;
        NSMutableArray                  *activeNotifications;

        NSTimeInterval                   notificationTimeout;

        id<NotificationSystemDelegate>   delegate;
}

+ (NotificationSystem*)sharedInstance;

- (NSTimeInterval)notificationTimeout;
- (void)setNotificationTimeout:(NSTimeInterval)timeout;

- (UserNotificationCenterScreenCorner)screenCorner;
- (void)setScreenCorner:(UserNotificationCenterScreenCorner)corner;

- (void)deliver:(UserNotification*)notification;

- (id<NotificationSystemDelegate>)delegate;
- (void)setDelegate:(id<NotificationSystemDelegate>)obj;

@end
