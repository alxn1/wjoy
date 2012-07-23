//
//  OwnUserNotificationCenter.m
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "OwnUserNotificationCenter.h"

@implementation OwnUserNotificationCenter

+ (void)load
{
    NSAutoreleasePool           *pool   = [[NSAutoreleasePool alloc] init];
    OwnUserNotificationCenter   *center = [[OwnUserNotificationCenter alloc] init];

    [UserNotificationCenter registerImpl:center];
    [center release];
    [pool release];
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    [[NotificationSystem sharedInstance] setDelegate:self];

    return self;
}

- (BOOL)isAvailable
{
    return YES;
}

- (NSString*)name
{
    return @"own";
}

- (NSUInteger)merit
{
    return 2;
}

- (void)deliver:(UserNotification*)notification
{
    if(![UserNotificationCenter
                    shouldDeliverNotification:notification
                                       center:self]) {
        return;
    }

    [[NotificationSystem sharedInstance] deliver:notification];
}

- (NSDictionary*)customSettings
{
    NSNumber *timeout       = [NSNumber numberWithDouble:[[NotificationSystem sharedInstance] notificationTimeout]];
    NSNumber *screenCorner  = [NSNumber numberWithInteger:[[NotificationSystem sharedInstance] screenCorner]];

    return [NSDictionary dictionaryWithObjectsAndKeys:
                                timeout,        UserNotificationCenterTimeoutKey,
                                screenCorner,   UserNotificationCenterScreenCornerKey,
                                nil];
}

- (void)setCustomSettings:(NSDictionary*)preferences
{
    NSNumber *number = [preferences objectForKey:UserNotificationCenterTimeoutKey];
    if(number != nil)
    {
        [[NotificationSystem sharedInstance]
                            setNotificationTimeout:[number doubleValue]];
    }

    number = [preferences objectForKey:UserNotificationCenterScreenCornerKey];
    if(number != nil)
    {
        [[NotificationSystem sharedInstance]
                            setScreenCorner:(UserNotificationCenterScreenCorner)
                                                    [number integerValue]];
    }
}

- (void)notificationSystem:(NotificationSystem*)system
       notificationClicked:(UserNotification*)notification
{
    [UserNotificationCenter notificationClicked:notification center:self];
}

@end
