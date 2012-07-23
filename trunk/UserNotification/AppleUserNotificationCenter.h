//
//  AppleUserNotificationCenter.h
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UserNotificationCenterProtected.h"

@interface AppleUserNotificationCenter : UserNotificationCenter
{
    @private
        Class notificationClass;
        Class notificationCenterClass;
}

@end
