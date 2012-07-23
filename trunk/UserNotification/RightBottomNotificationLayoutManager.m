//
//  RightBottomNotificationLayoutManager.m
//  UserNotification
//
//  Created by alxn1 on 20.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "RightBottomNotificationLayoutManager.h"

@implementation RightBottomNotificationLayoutManager

- (UserNotificationCenterScreenCorner)screenCorner
{
    return UserNotificationCenterScreenCornerRightBottom;
}

- (BOOL)hasSpaceBeforeFirst:(NSRect)bestRect
        activeNotifications:(NSArray*)activeNotifications
                       rect:(NSRect*)resultRect
{
    NSRect      screenRect  = [self screenRect];
    NSUInteger  countActive = [activeNotifications count];
    NSRect      result      = NSMakeRect(
                                    screenRect.origin.x + screenRect.size.width - bestRect.size.width,
                                    screenRect.origin.y,
                                    bestRect.size.width,
                                    bestRect.size.height);

    if(countActive == 0)
    {
        if(resultRect != NULL)
            *resultRect = result;

        return YES;
    }

    NSRect firstFrame = [[activeNotifications objectAtIndex:0] frame];
    if((result.origin.x > firstFrame.origin.x) ||
       ((result.origin.y + result.size.height + 10.0) <= firstFrame.origin.y))
    {
        if(resultRect != NULL)
            *resultRect = result;

        return YES;
    }

    return NO;
}

- (BOOL)hasSpaceBetween:(NSRect)bestRect
              firstRect:(NSRect)firstRect
             secondRect:(NSRect)secondRect
    activeNotifications:(NSArray*)activeNotifications
                   rect:(NSRect*)resultRect
{
    if(firstRect.origin.x > secondRect.origin.x)
    {
        NSRect screenRect = [self screenRect];
        float  lostSpace  = screenRect.origin.y + screenRect.size.height -
                            firstRect.origin.y - firstRect.size.height - 10.0f;

        if(lostSpace >= bestRect.size.height)
        {
            if(resultRect != NULL)
            {
                *resultRect = NSMakeRect(
                                    firstRect.origin.x,
                                    firstRect.origin.y + bestRect.size.height + 10.0f,
                                    bestRect.size.width,
                                    bestRect.size.height);
            }

            return YES;
        }

        lostSpace = secondRect.origin.y - screenRect.origin.y - 10.0f;
        if(lostSpace >= bestRect.size.height)
        {
            if(resultRect != NULL)
            {
                *resultRect = NSMakeRect(
                                    secondRect.origin.x,
                                    screenRect.origin.y,
                                    bestRect.size.width,
                                    bestRect.size.height);
            }

            return YES;
        }

        if((firstRect.origin.x - secondRect.origin.x) >= (bestRect.size.width + 20.0f))
        {
            if(resultRect != NULL)
            {
                *resultRect = NSMakeRect(
                                    firstRect.origin.x - bestRect.size.width - 10.0f,
                                    screenRect.origin.y,
                                    bestRect.size.width,
                                    bestRect.size.height);
            }

            return YES;
        }
    }

    float lostSpace = secondRect.origin.y - firstRect.origin.y - firstRect.size.height - 20.0f;
    if(lostSpace >= bestRect.size.height)
    {
        if(resultRect != NULL)
        {
            *resultRect = NSMakeRect(
                                firstRect.origin.x,
                                firstRect.origin.y + firstRect.size.height + 10.0f,
                                bestRect.size.width,
                                bestRect.size.height);
        }

        return YES;
    }

    return NO;
}

- (BOOL)hasSpaceAfterLast:(NSRect)bestRect
      activeNotifications:(NSArray*)activeNotifications
                     rect:(NSRect*)resultRect
{
    NSRect screenRect   = [self screenRect];
    NSRect lastRect     = [[activeNotifications objectAtIndex:[activeNotifications count] - 1] frame];

    if((screenRect.origin.y + screenRect.size.height - lastRect.origin.y - lastRect.size.height) >=
       (bestRect.size.height + 10.0f))
    {
        if(resultRect != NULL)
        {
            *resultRect = NSMakeRect(
                                lastRect.origin.x,
                                lastRect.origin.y + bestRect.size.height + 10.0f,
                                bestRect.size.width,
                                bestRect.size.height);
        }

        return YES;
    }

    lastRect.origin.x -= bestRect.size.width + 10.0f;
    if(lastRect.origin.x <= 0.0f)
        return NO;

    if(resultRect != NULL)
    {
        *resultRect = NSMakeRect(
                            lastRect.origin.x,
                            screenRect.origin.y,
                            bestRect.size.width,
                            bestRect.size.height);
    }

    return YES;
}

@end
