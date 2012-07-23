//
//  LeftTopNotificationLayoutManager.m
//  UserNotification
//
//  Created by alxn1 on 20.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "LeftTopNotificationLayoutManager.h"

@implementation LeftTopNotificationLayoutManager

- (UserNotificationCenterScreenCorner)screenCorner
{
    return UserNotificationCenterScreenCornerLeftTop;
}

- (BOOL)hasSpaceBeforeFirst:(NSRect)bestRect
        activeNotifications:(NSArray*)activeNotifications
                       rect:(NSRect*)resultRect
{
    NSRect      screenRect  = [self screenRect];
    NSUInteger  countActive = [activeNotifications count];
    NSRect      result      = NSMakeRect(
                                    screenRect.origin.x,
                                    screenRect.origin.y + screenRect.size.height - bestRect.size.height,
                                    bestRect.size.width,
                                    bestRect.size.height);

    if(countActive == 0)
    {
        if(resultRect != NULL)
            *resultRect = result;

        return YES;
    }

    NSRect firstFrame = [[activeNotifications objectAtIndex:0] frame];
    if((result.origin.x < firstFrame.origin.x) ||
       (result.origin.y >= (firstFrame.origin.y + firstFrame.size.height + 10.0f)))
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
    if(firstRect.origin.x < secondRect.origin.x)
    {
        NSRect screenRect = [self screenRect];
        if((firstRect.origin.y - screenRect.origin.y) >= (bestRect.size.height + 10.0f))
        {
            if(resultRect != NULL)
            {
                *resultRect = NSMakeRect(
                                    firstRect.origin.x,
                                    firstRect.origin.y - bestRect.size.height - 10.0f,
                                    bestRect.size.width,
                                    bestRect.size.height);
            }

            return YES;
        }

        float lostSpace = screenRect.origin.y + screenRect.size.height -
                          secondRect.origin.y - secondRect.size.height - 10.0f;

        if(lostSpace >= bestRect.size.height)
        {
            if(resultRect != NULL)
            {
                *resultRect = NSMakeRect(
                                    secondRect.origin.x,
                                    screenRect.origin.y + screenRect.size.height - bestRect.size.height,
                                    bestRect.size.width,
                                    bestRect.size.height);
            }

            return YES;
        }

        if((secondRect.origin.x - firstRect.origin.x) >= (bestRect.size.width + 20.0f))
        {
            if(resultRect != NULL)
            {
                *resultRect = NSMakeRect(
                                    firstRect.origin.x + bestRect.size.width + 10.0f,
                                    screenRect.origin.y + screenRect.size.height - bestRect.size.height,
                                    bestRect.size.width,
                                    bestRect.size.height);
            }

            return YES;
        }
    }

    float lostSpace = firstRect.origin.y - secondRect.origin.y - secondRect.size.height - 20.0f;
    if(lostSpace >= bestRect.size.height)
    {
        if(resultRect != NULL)
        {
            *resultRect = NSMakeRect(
                                firstRect.origin.x,
                                firstRect.origin.y - bestRect.size.height - 10.0f,
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

    if((lastRect.origin.y - screenRect.origin.y) >= (bestRect.size.height + 10.0f))
    {
        if(resultRect != NULL)
        {
            *resultRect = NSMakeRect(
                                lastRect.origin.x,
                                lastRect.origin.y - bestRect.size.height - 10.0f,
                                bestRect.size.width,
                                bestRect.size.height);
        }

        return YES;
    }

    lastRect.origin.x += bestRect.size.width + 10.0f;
    if((lastRect.origin.x + lastRect.size.width) >=
       (screenRect.origin.x + screenRect.size.width))
    {
        return NO;
    }

    if(resultRect != NULL)
    {
        *resultRect = NSMakeRect(
                            lastRect.origin.x,
                            screenRect.origin.y + screenRect.size.height - bestRect.size.height,
                            bestRect.size.width,
                            bestRect.size.height);
    }

    return YES;
}

@end
