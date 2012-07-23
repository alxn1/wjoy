//
//  NotificationLayoutManager.m
//  UserNotification
//
//  Created by alxn1 on 20.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "RightTopNotificationLayoutManager.h"
#import "RightBottomNotificationLayoutManager.h"
#import "LeftBottomNotificationLayoutManager.h"
#import "LeftTopNotificationLayoutManager.h"
#import "NotificationWindow.h"

@implementation NotificationLayoutManager

+ (NotificationLayoutManager*)managerWithScreenCorner:(UserNotificationCenterScreenCorner)screenCorner
{
    static NotificationLayoutManager *rightTop      = nil;
    static NotificationLayoutManager *rightBottom   = nil;
    static NotificationLayoutManager *leftBottom    = nil;
    static NotificationLayoutManager *leftTop       = nil;

    NotificationLayoutManager *result = nil;

    switch(screenCorner)
    {
        case UserNotificationCenterScreenCornerRightTop:
        {
            if(rightTop == nil)
                rightTop = [[RightTopNotificationLayoutManager alloc] init];

            result = rightTop;
            break;
        }

        case UserNotificationCenterScreenCornerRightBottom:
        {
            if(rightBottom == nil)
                rightBottom = [[RightBottomNotificationLayoutManager alloc] init];

            result = rightBottom;
            break;
        }

        case UserNotificationCenterScreenCornerLeftBottom:
        {
            if(leftBottom == nil)
                leftBottom = [[LeftBottomNotificationLayoutManager alloc] init];

            result = leftBottom;
            break;
        }

        case UserNotificationCenterScreenCornerLeftTop:
        {
            if(leftTop == nil)
                leftTop = [[LeftTopNotificationLayoutManager alloc] init];
            result = leftTop;
            break;
        }
    }

    return result;
}

- (UserNotificationCenterScreenCorner)screenCorner
{
    return UserNotificationCenterScreenCornerRightTop;
}

- (BOOL)hasSpaceForNotification:(UserNotification*)notification
            activeNotifications:(NSArray*)activeNotifications
                           rect:(NSRect*)resultRect
                          index:(NSUInteger*)index
{
    NSRect screenRect   = [self screenRect];
    NSRect bestRect     = [NotificationWindow bestRectForNotification:notification];

    if(bestRect.size.height > screenRect.size.height)
        bestRect.size.height = screenRect.size.height;

    if([self hasSpaceBeforeFirst:bestRect
             activeNotifications:activeNotifications
                            rect:resultRect])
    {
        if(index != NULL)
            *index = 0;

        return YES;
    }

    NSUInteger countActive = [activeNotifications count];
    for(NSUInteger i = 0; i < (countActive - 1); i++)
    {
        if([self hasSpaceBetween:bestRect
                       firstRect:[[activeNotifications objectAtIndex:i] frame]
                      secondRect:[[activeNotifications objectAtIndex:i + 1] frame]
             activeNotifications:activeNotifications
                            rect:resultRect])
        {
            if(index != NULL)
                *index = i + 1;

            return YES;
        }
    }

    if([self hasSpaceAfterLast:bestRect
           activeNotifications:activeNotifications
                          rect:resultRect])
    {
        if(index != NULL)
            *index = countActive;

        return YES;
    }

    return NO;
}

@end

@implementation NotificationLayoutManager (Protected)

- (NSRect)screenRect
{
    return NSInsetRect([[NSScreen mainScreen] visibleFrame], 15.0f, 15.0f);
}

- (BOOL)hasSpaceBeforeFirst:(NSRect)bestRect
        activeNotifications:(NSArray*)activeNotifications
                       rect:(NSRect*)resultRect
{
    return NO;
}

- (BOOL)hasSpaceBetween:(NSRect)bestRect
              firstRect:(NSRect)firstRect
             secondRect:(NSRect)secondRect
    activeNotifications:(NSArray*)activeNotifications
                   rect:(NSRect*)resultRect
{
    return NO;
}

- (BOOL)hasSpaceAfterLast:(NSRect)bestRect
      activeNotifications:(NSArray*)activeNotifications
                     rect:(NSRect*)resultRect
{
    return NO;
}

@end
