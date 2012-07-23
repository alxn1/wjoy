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

    layoutManager       = [[NotificationLayoutManager managerWithScreenCorner:
                                        UserNotificationCenterScreenCornerRightTop]
                                retain];

    notificationQueue   = [[NSMutableArray alloc] init];
    activeNotifications = [[NSMutableArray alloc] init];
    notificationTimeout = 5.0;

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

    [notificationQueue release];
    [activeNotifications release];
    [layoutManager release];
    [super dealloc];
}

- (NSTimeInterval)notificationTimeout
{
    return notificationTimeout;
}

- (void)setNotificationTimeout:(NSTimeInterval)timeout
{
    notificationTimeout = timeout;
}

- (UserNotificationCenterScreenCorner)screenCorner
{
    return [layoutManager screenCorner];
}

- (void)setScreenCorner:(UserNotificationCenterScreenCorner)corner
{
    if([self screenCorner] == corner)
        return;

    [layoutManager release];
    layoutManager = [[NotificationLayoutManager managerWithScreenCorner:corner] retain];

    NSUInteger countOpenedWindows = [activeNotifications count];
    for(NSUInteger i = 0; i < countOpenedWindows; i++)
    {
        NotificationWindow *w = [activeNotifications objectAtIndex:i];
        [w setReleasedWhenClosed:YES];
        [w setDelegate:nil];
        [w retain];
        [w close];
    }

    [activeNotifications removeAllObjects];
}

- (void)deliver:(UserNotification*)notification
{
    NSRect      rect;
    NSUInteger  index;

    if([self hasSpaceForNotification:notification rect:&rect index:&index])
        [self showNotification:notification rect:rect index:index];
    else
        [notificationQueue addObject:notification];
}

- (id<NotificationSystemDelegate>)delegate
{
    return delegate;
}

- (void)setDelegate:(id<NotificationSystemDelegate>)obj
{
    delegate = obj;
}

- (void)notificationClicked:(id)sender
{
    [delegate notificationSystem:self
             notificationClicked:[(NotificationWindow*)sender notification]];
}

// MARK: NSWindow delegate

- (void)showNextNotificationFromQueue
{
    if([notificationQueue count] != 0)
    {
        NSRect               rect;
        NSUInteger           index;
        UserNotification    *n = [notificationQueue objectAtIndex:0];

        if([self hasSpaceForNotification:n rect:&rect index:&index])
        {
            [self showNotification:n rect:rect index:index];
            [notificationQueue removeObjectAtIndex:0];
        }
    }
}

- (void)windowWillClose:(NSNotification*)notification
{
    [activeNotifications removeObject:[notification object]];
    [self showNextNotificationFromQueue];
}

- (void)applicationDidChangeScreenParametersNotification:(NSNotification*)notification
{
    NSUInteger countOpenedWindows = [activeNotifications count];
    for(NSUInteger i = 0; i < countOpenedWindows; i++)
    {
        NotificationWindow *w = [activeNotifications objectAtIndex:i];
        [w setAnimationEnabled:NO];
        [w setDelegate:nil];
        [w close];
    }

    [activeNotifications removeAllObjects];
    [self showNextNotificationFromQueue];
}

@end

@implementation NotificationSystem (PrivatePart)

- (BOOL)hasSpaceForNotification:(UserNotification*)notification rect:(NSRect*)resultRect index:(NSUInteger*)index
{
    return [layoutManager hasSpaceForNotification:notification
                              activeNotifications:activeNotifications
                                             rect:resultRect
                                            index:index];
}

- (void)showNotification:(UserNotification*)notification rect:(NSRect)rect index:(NSUInteger)index
{
    NotificationWindow *window = [NotificationWindow newWindowWithNotification:notification frame:rect];

    [window setTarget:self];
    [window setAction:@selector(notificationClicked:)];
    [window setDelegate:(id)self];
    [window showWithTimeout:notificationTimeout];

    [activeNotifications insertObject:window atIndex:index];
}

@end
