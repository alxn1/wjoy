//
//  NotificationWindow.m
//  UserNotification
//
//  Created by alxn1 on 19.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NotificationWindow.h"

@interface NSWindow (Additions)

- (void)setMovable:(BOOL)flag;

@end

@interface NotificationWindow (PrivatePart)

- (void)startAutocloseTimer:(NSTimeInterval)timeout;

@end

@implementation NotificationWindow

+ (NSRect)bestRectForNotification:(UserNotification*)notification
{
    return [NotificationWindowView
                        bestViewRectForTitle:[notification title]
                                        text:[notification text]];
}

+ (NotificationWindow*)newWindowWithNotification:(UserNotification*)notification frame:(NSRect)frame
{
    return [[[NotificationWindow alloc]
                        initWithNotification:notification
                                       frame:frame] autorelease];
}

- (id)initWithNotification:(UserNotification*)notification frame:(NSRect)frame
{
    self = [super initWithContentRect:frame
                            styleMask:NSBorderlessWindowMask
                              backing:NSBackingStoreBuffered
                                defer:NO];

    if(self == nil) return nil;

    if([self respondsToSelector:@selector(setMovable:)])
        [self setMovable:NO];

    [self setOpaque:NO];
    [self setOneShot:NO];
    [self setHasShadow:YES];
    [self setLevel:kCGMaximumWindowLevel];
    [self setAcceptsMouseMovedEvents:YES];
    [self setMovableByWindowBackground:NO];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setReleasedWhenClosed:NO];
    [self setExcludedFromWindowsMenu:YES];
    [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];

    [self setAnimationEnabled:YES];

    NSRect contentViewFrame = frame;
    contentViewFrame.origin = NSZeroPoint;

    NotificationWindowView *contentView = [[NotificationWindowView alloc] initWithFrame:contentViewFrame];

    [contentView setIcon:[[NSApplication sharedApplication] applicationIconImage]];
    [contentView setText:[notification text]];
    [contentView setTitle:[notification title]];
    [contentView setDelegate:self];
    [contentView setTarget:self];
    [contentView setAction:@selector(contentViewClicked:)];

    [self setContentView:contentView];
    [contentView release];

    m_Notification          = [notification retain];
    m_IsMouseEntered        = NO;
    m_IsCloseOnMouseExited  = NO;

    return self;
}

- (void)dealloc
{
    [m_AutocloseTimer invalidate];
    [m_Notification release];
    [super dealloc];
}

- (id)target
{
    return m_Target;
}

- (void)setTarget:(id)obj
{
    m_Target = obj;
}

- (SEL)action
{
    return m_Action;
}

- (void)setAction:(SEL)sel
{
    m_Action = sel;
}

- (void)showWithTimeout:(NSTimeInterval)timeout
{
    [self orderFront:self];
    [self startAutocloseTimer:timeout];
}

- (void)close
{
    [m_AutocloseTimer invalidate];
    m_AutocloseTimer = nil;
    [super close];
}

- (UserNotification*)notification
{
    return [[m_Notification retain] autorelease];
}

- (BOOL)canBecomeKeyWindow
{
    return NO;
}

- (BOOL)canBecomeMainWindow
{
    return NO;
}

- (void)autoclose:(id)sender
{
    m_AutocloseTimer = nil;
    if(!m_IsMouseEntered)
        [self close];
    else
        m_IsCloseOnMouseExited = YES;
}

- (void)contentViewClicked:(id)sender
{
    if(m_Target != nil && m_Action != nil)
        [m_Target performSelector:m_Action withObject:self];
}

- (void)notificationWindowViewMouseEntered:(NotificationWindowView*)view
{
    m_IsMouseEntered = YES;
}

- (void)notificationWindowViewMouseExited:(NotificationWindowView*)view
{
    m_IsMouseEntered = NO;
    if(m_IsCloseOnMouseExited)
        [self close];
}

@end

@implementation NotificationWindow (PrivatePart)

- (void)startAutocloseTimer:(NSTimeInterval)timeout
{
    if(m_AutocloseTimer == nil)
    {
        m_AutocloseTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                            target:self
                                                          selector:@selector(autoclose:)
                                                          userInfo:nil
                                                           repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:m_AutocloseTimer forMode:NSEventTrackingRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:m_AutocloseTimer forMode:NSModalPanelRunLoopMode];
    }
}

@end
