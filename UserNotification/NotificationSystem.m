//
//  NotificationSystem.m
//  UserNotification
//
//  Created by alxn1 on 19.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NotificationSystem.h"
#import "NotificationWindow.h"
#import "NotificationLayoutManager.h"

@interface NotificationSystem (PrivatePart)

- (BOOL)hasSpaceForNotification:(UserNotification*)notification rect:(NSRect*)resultRect index:(NSUInteger*)index;
- (void)showNotification:(UserNotification*)notification rect:(NSRect)rect index:(NSUInteger)index;

@end

@implementation NotificationSystem

+ (NotificationSystem*)sharedInstance
{
    static NotificationSystem *result = nil;

    if(result == nil)
        result = [[NotificationSystem alloc] init];

    return result;
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    m_LayoutManager     = [[NotificationLayoutManager managerWithScreenCorner:
                                        UserNotificationCenterScreenCornerRightTop]
                                retain];

    m_NotificationQueue     = [[NSMutableArray alloc] init];
    m_ActiveNotifications   = [[NSMutableArray alloc] init];
    m_NotificationTimeout   = 5.0;

    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(applicationDidChangeScreenParametersNotification:)
               name:NSApplicationDidChangeScreenParametersNotification
             object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [m_NotificationQueue release];
    [m_ActiveNotifications release];
    [m_LayoutManager release];
    [super dealloc];
}

- (NSTimeInterval)notificationTimeout
{
    return m_NotificationTimeout;
}

- (void)setNotificationTimeout:(NSTimeInterval)timeout
{
    m_NotificationTimeout = timeout;
}

- (UserNotificationCenterScreenCorner)screenCorner
{
    return [m_LayoutManager screenCorner];
}

- (void)setScreenCorner:(UserNotificationCenterScreenCorner)corner
{
    if([self screenCorner] == corner)
        return;

    [m_LayoutManager release];
    m_LayoutManager = [[NotificationLayoutManager managerWithScreenCorner:corner] retain];

    NSUInteger countOpenedWindows = [m_ActiveNotifications count];
    for(NSUInteger i = 0; i < countOpenedWindows; i++)
    {
        NotificationWindow *w = [m_ActiveNotifications objectAtIndex:i];
        [w setReleasedWhenClosed:YES];
        [w setDelegate:nil];
        [w retain];
        [w close];
    }

    [m_ActiveNotifications removeAllObjects];
}

- (void)deliver:(UserNotification*)notification
{
    NSRect      rect;
    NSUInteger  index;

    if([self hasSpaceForNotification:notification rect:&rect index:&index])
        [self showNotification:notification rect:rect index:index];
    else
        [m_NotificationQueue addObject:notification];
}

- (id<NotificationSystemDelegate>)delegate
{
    return m_Delegate;
}

- (void)setDelegate:(id<NotificationSystemDelegate>)obj
{
    m_Delegate = obj;
}

- (void)notificationClicked:(id)sender
{
    [m_Delegate notificationSystem:self
               notificationClicked:[(NotificationWindow*)sender notification]];
}

- (void)showNextNotificationFromQueue
{
    if([m_NotificationQueue count] != 0)
    {
        NSRect               rect;
        NSUInteger           index;
        UserNotification    *n = [m_NotificationQueue objectAtIndex:0];

        if([self hasSpaceForNotification:n rect:&rect index:&index])
        {
            [self showNotification:n rect:rect index:index];
            [m_NotificationQueue removeObjectAtIndex:0];
        }
    }
}

- (void)windowWillClose:(NSNotification*)notification
{
    [m_ActiveNotifications removeObject:[notification object]];
    [self showNextNotificationFromQueue];
}

- (void)applicationDidChangeScreenParametersNotification:(NSNotification*)notification
{
    NSUInteger countOpenedWindows = [m_ActiveNotifications count];
    for(NSUInteger i = 0; i < countOpenedWindows; i++)
    {
        NotificationWindow *w = [m_ActiveNotifications objectAtIndex:i];
        [w setAnimationEnabled:NO];
        [w setDelegate:nil];
        [w close];
    }

    [m_ActiveNotifications removeAllObjects];
    [self showNextNotificationFromQueue];
}

@end

@implementation NotificationSystem (PrivatePart)

- (BOOL)hasSpaceForNotification:(UserNotification*)notification rect:(NSRect*)resultRect index:(NSUInteger*)index
{
    return [m_LayoutManager hasSpaceForNotification:notification
                                activeNotifications:m_ActiveNotifications
                                               rect:resultRect
                                              index:index];
}

- (void)showNotification:(UserNotification*)notification rect:(NSRect)rect index:(NSUInteger)index
{
    NotificationWindow *window = [NotificationWindow newWindowWithNotification:notification frame:rect];

    [window setTarget:self];
    [window setAction:@selector(notificationClicked:)];
    [window setDelegate:(id)self];
    [window showWithTimeout:m_NotificationTimeout];

    [m_ActiveNotifications insertObject:window atIndex:index];
}

@end
