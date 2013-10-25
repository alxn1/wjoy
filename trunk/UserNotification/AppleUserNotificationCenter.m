//
//  AppleUserNotificationCenter.m
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AppleUserNotificationCenter.h"

#define NSUserNotificationClassName                 @"NSUserNotification"
#define NSUserNotificationCenterClassName           @"NSUserNotificationCenter"

@protocol NSUserNotificationFutureProtocol

- (void)setTitle:(NSString*)title;
- (void)setInformativeText:(NSString*)text;
- (void)setSoundName:(NSString*)soundName;

- (NSDictionary*)userInfo;
- (void)setUserInfo:(NSDictionary*)userInfo;

@end

@protocol NSUserNotificationCenterFutureProtocol

+ (id<NSUserNotificationCenterFutureProtocol>)defaultUserNotificationCenter;

- (void)setDelegate:(id)obj;
- (void)deliverNotification:(id<NSUserNotificationFutureProtocol>)notification;
- (void)removeDeliveredNotification:(id<NSUserNotificationFutureProtocol>)notification;
- (void)removeAllDeliveredNotifications;

@end

@protocol NSUserNotificationDelegateFutureProtocol

- (void)userNotificationCenter:(id<NSUserNotificationCenterFutureProtocol>)center
        didDeliverNotification:(id<NSUserNotificationFutureProtocol>)notification;

- (void)userNotificationCenter:(id<NSUserNotificationCenterFutureProtocol>)center
       didActivateNotification:(id<NSUserNotificationFutureProtocol>)notification;

- (BOOL)userNotificationCenter:(id<NSUserNotificationCenterFutureProtocol>)center
     shouldPresentNotification:(id<NSUserNotificationFutureProtocol>)notification;

@end

@interface AppleUserNotificationCenter (PrivatePart)

+ (BOOL)isAvailable;

- (void)userNotificationCenter:(id)center didActivateNotification:(id)notification;
- (void)applicationWillTerminateNotification:(NSNotification*)notification;

@end

@implementation AppleUserNotificationCenter

+ (void)load
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if([AppleUserNotificationCenter isAvailable])
    {
        AppleUserNotificationCenter *center = [[AppleUserNotificationCenter alloc] init];
        [UserNotificationCenter registerImpl:center];
        [center release];
    }

    [pool release];
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    m_NotificationClass       = NSClassFromString(NSUserNotificationClassName);
    m_NotificationCenterClass = NSClassFromString(NSUserNotificationCenterClassName);

    [(id<NSUserNotificationCenterFutureProtocol>)
        [m_NotificationCenterClass defaultUserNotificationCenter] setDelegate:self];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(applicationWillTerminateNotification:)
                                           name:NSApplicationWillTerminateNotification
                                         object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (BOOL)isAvailable
{
    return YES;
}

- (NSString*)name
{
    return @"apple";
}

- (NSUInteger)merit
{
    return 0;
}

- (void)deliver:(UserNotification*)notification
{
    if(![UserNotificationCenter
                    shouldDeliverNotification:notification
                                       center:self])
    {
        return;
    }

    id<NSUserNotificationCenterFutureProtocol>  center  = (id)[m_NotificationCenterClass defaultUserNotificationCenter];
    id<NSUserNotificationFutureProtocol>        n       = [[[m_NotificationClass alloc] init] autorelease];

    [n setInformativeText:[notification text]];
    [n setTitle:[notification title]];
    [n setSoundName:nil];
    [n setUserInfo:[notification asDictionary]];

    [center deliverNotification:n];
}

@end

@implementation AppleUserNotificationCenter (PrivatePart)

+ (BOOL)isAvailable
{
    Class notificationClass         = NSClassFromString(NSUserNotificationClassName);
    Class notificationCenterClass   = NSClassFromString(NSUserNotificationCenterClassName);

    if(notificationCenterClass  == nil ||
       notificationClass        == nil)
    {
        return NO;
    }

    return YES;
}

- (void)userNotificationCenter:(id)center didActivateNotification:(id)notification
{
    UserNotification *n = [[UserNotification alloc] initWithDictionary:
                                    [(id<NSUserNotificationFutureProtocol>)notification userInfo]];

    [UserNotificationCenter notificationClicked:n center:self];
    [n release];

    [(id<NSUserNotificationCenterFutureProtocol>)center
        removeDeliveredNotification:(id<NSUserNotificationFutureProtocol>)notification];
}

- (BOOL)userNotificationCenter:(id)center shouldPresentNotification:(id)notification
{
    return YES;
}

- (void)applicationWillTerminateNotification:(NSNotification*)notification
{
    [(id<NSUserNotificationCenterFutureProtocol>)
        [m_NotificationCenterClass defaultUserNotificationCenter]
            removeAllDeliveredNotifications];
}

@end
