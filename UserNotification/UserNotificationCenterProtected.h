//
//  UserNotificationCenterProtected.h
//  UserNotification
//
//  Created by alxn1 on 23.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UserNotificationCenter.h"

@interface UserNotificationCenter (Protected)

+ (void)registerImpl:(UserNotificationCenter*)impl;

+ (BOOL)shouldDeliverNotification:(UserNotification*)notification
                           center:(UserNotificationCenter*)center;

+ (void)notificationClicked:(UserNotification*)notification
                     center:(UserNotificationCenter*)center;

@end
