//
//  NotificationWindow.m
//  UserNotification
//
//  Created by alxn1 on 19.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NotificationWindow.h"

@interface NotificationWindow (PrivatePart)

- (void)startAutocloseTimer:(NSTimeInterval)timeout;

@end

@implementation NotificationWindow

+ (NSRect)bestRectForNotification:(UserNotification*)aNotification
{
    return [NotificationWindowView
                        bestViewRectForTitle:[aNotification title]
                                        text:[aNotification text]];
}

+ (NotificationWindow*)newWindowWithNotification:(UserNotification*)aNotification frame:(NSRect)aFrame
{
    return [[[NotificationWindow alloc]
                        initWithNotification:aNotification
                                       frame:aFrame] autorelease];
}

- (id)initWithNotification:(UserNotification*)aNotification frame:(NSRect)aFrame
{
    self = [super initWithContentRect:aFrame
                            styleMask:NSBorderlessWindowMask
                              backing:NSBackingStoreBuffered
                                defer:NO];

    if(self == nil) return nil;

    [self setOpaque:NO];
    [self setOneShot:NO];
    [self setMovable:NO];
    [self setHasShadow:YES];
    [self setLevel:kCGMaximumWindowLevel];
    [self setAcceptsMouseMovedEvents:YES];
    [self setMovableByWindowBackground:NO];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setReleasedWhenClosed:NO];
    [self setExcludedFromWindowsMenu:YES];
    [self setCollectionBehavior:
            NSWindowCollectionBehaviorCanJoinAllSpaces |
            NSWindowCollectionBehaviorTransient |
            NSWindowCollectionBehaviorIgnoresCycle];

    [self setAnimationEnabled:YES];

    NSRect contentViewFrame = aFrame;
    contentViewFrame.origin = NSZeroPoint;

    NotificationWindowView *contentView = [[NotificationWindowView alloc] initWithFrame:contentViewFrame];

    [contentView setIcon:[[NSApplication sharedApplication] applicationIconImage]];
    [contentView setText:[aNotification text]];
    [contentView setTitle:[aNotification title]];
    [contentView setDelegate:self];
    [contentView setTarget:self];
    [contentView setAction:@selector(contentViewClicked:)];

    [self setContentView:contentView];
    [contentView release];

    notification            = [aNotification retain];
    isMouseEntered          = NO;
    isCloseOnMouseExited    = NO;

    return self;
}

- (void)dealloc
{
    [autocloseTimer invalidate];
    [notification release];
    [super dealloc];
}

- (id)target
{
    return target;
}

- (void)setTarget:(id)obj
{
    target = obj;
}

- (SEL)action
{
    return action;
}

- (void)setAction:(SEL)sel
{
    action = sel;
}

- (void)showWithTimeout:(NSTimeInterval)timeout
{
    [self orderFront:self];
    [self startAutocloseTimer:timeout];
}

- (void)close
{
    [autocloseTimer invalidate];
    autocloseTimer = nil;
    [super close];
}

- (UserNotification*)notification
{
    return [[notification retain] autorelease];
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
    autocloseTimer = nil;
    if(!isMouseEntered)
        [self close];
    else
        isCloseOnMouseExited = YES;
}

- (void)contentViewClicked:(id)sender
{
    if(target != nil && action != nil)
        [target performSelector:action withObject:self];
}

- (void)notificationWindowViewMouseEntered:(NotificationWindowView*)view
{
    isMouseEntered = YES;
}

- (void)notificationWindowViewMouseExited:(NotificationWindowView*)view
{
    isMouseEntered = NO;
    if(isCloseOnMouseExited)
        [self close];
}

@end

@implementation NotificationWindow (PrivatePart)

- (void)startAutocloseTimer:(NSTimeInterval)timeout
{
    if(autocloseTimer == nil)
    {
        autocloseTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                          target:self
                                                        selector:@selector(autoclose:)
                                                        userInfo:nil
                                                         repeats:NO];

        [[NSRunLoop currentRunLoop] addTimer:autocloseTimer forMode:NSEventTrackingRunLoopMode];
        [[NSRunLoop currentRunLoop] addTimer:autocloseTimer forMode:NSModalPanelRunLoopMode];
    }
}

@end
