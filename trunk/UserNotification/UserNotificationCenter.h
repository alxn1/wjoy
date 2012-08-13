//
//  UserNotificationCenter.h
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <UserNotification/UserNotification.h>

@class UserNotificationCenter;

typedef enum
{
    UserNotificationCenterScreenCornerRightTop,
    UserNotificationCenterScreenCornerRightBottom,
    UserNotificationCenterScreenCornerLeftBottom,
    UserNotificationCenterScreenCornerLeftTop
} UserNotificationCenterScreenCorner;

APPKIT_EXTERN NSString *UserNotificationClickedNotification;    // object  => UserNotification

// custom settings keys
APPKIT_EXTERN NSString *UserNotificationCenterTimeoutKey;       // NSValue => NSTimeInterval
APPKIT_EXTERN NSString *UserNotificationCenterScreenCornerKey;  // NSValue => UserNotificationCenterScreenCorner

@protocol UserNotificationCenterDelegate

- (BOOL)userNotificationCenter:(UserNotificationCenter*)center
     shouldDeliverNotification:(UserNotification*)notification;

- (void)userNotificationCenter:(UserNotificationCenter*)center
           notificationClicked:(UserNotification*)notification;

@end

@interface UserNotificationCenter : NSObject
{
}

+ (NSArray*)all;
+ (NSArray*)available;
+ (UserNotificationCenter*)withName:(NSString*)name;
+ (UserNotificationCenter*)availableWithName:(NSString*)name;
+ (UserNotificationCenter*)best;

+ (BOOL)isSoundEnabled;
+ (void)setSoundEnabled:(BOOL)enabled;

+ (NSString*)soundName;
+ (void)setSoundName:(NSString*)name;

+ (void)deliver:(UserNotification*)notification;

+ (id<UserNotificationCenterDelegate>)delegate;
+ (void)setDelegate:(id<UserNotificationCenterDelegate>)obj;

@end

@interface UserNotificationCenter (Instance)

- (BOOL)isAvailable;

- (NSString*)name;
- (NSUInteger)merit;

- (void)deliver:(UserNotification*)notification;

- (NSDictionary*)customSettings;
- (void)setCustomSettings:(NSDictionary*)preferences;

@end
