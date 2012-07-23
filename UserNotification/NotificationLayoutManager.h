//
//  NotificationLayoutManager.h
//  UserNotification
//
//  Created by alxn1 on 20.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UserNotificationCenter.h"

@interface NotificationLayoutManager : NSObject
{
}

+ (NotificationLayoutManager*)managerWithScreenCorner:(UserNotificationCenterScreenCorner)screenCorner;

- (UserNotificationCenterScreenCorner)screenCorner;

- (BOOL)hasSpaceForNotification:(UserNotification*)notification
            activeNotifications:(NSArray*)activeNotifications
                           rect:(NSRect*)resultRect
                          index:(NSUInteger*)index;

@end

@interface NotificationLayoutManager (Protected)

- (NSRect)screenRect;

- (BOOL)hasSpaceBeforeFirst:(NSRect)bestRect
        activeNotifications:(NSArray*)activeNotifications
                       rect:(NSRect*)resultRect;

- (BOOL)hasSpaceBetween:(NSRect)bestRect
              firstRect:(NSRect)firstRect
             secondRect:(NSRect)secondRect
    activeNotifications:(NSArray*)activeNotifications
                   rect:(NSRect*)resultRect;

- (BOOL)hasSpaceAfterLast:(NSRect)bestRect
      activeNotifications:(NSArray*)activeNotifications
                     rect:(NSRect*)resultRect;

@end
