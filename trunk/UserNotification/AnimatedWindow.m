//
//  AnimatedWindow.m
//  UserNotification
//
//  Created by alxn1 on 26.10.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "AnimatedWindow.h"

@interface AnimatedWindow (PrivarePart)

- (void)fadeIn;
- (void)fadeOut;

@end

@implementation AnimatedWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:aStyle
                              backing:bufferingType
                                defer:flag];

    if(self == nil)
        return nil;

    m_IsAnimationEnabled = NO;

    return self;
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
                   screen:(NSScreen *)screen
{
    self = [super initWithContentRect:contentRect
                            styleMask:aStyle
                              backing:bufferingType
                                defer:flag
                               screen:screen];

    if(self == nil)
        return nil;

    m_IsAnimationEnabled = NO;

    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if(self == nil)
        return nil;

    m_IsAnimationEnabled = NO;

    return self;
}

- (void)dealloc
{
    [m_CurrentAnimation stopAnimation];
    [m_CurrentAnimation release];
    [super dealloc];
}

- (void)makeKeyAndOrderFromWithoutAnimation:(id)sender
{
    [m_CurrentAnimation stopAnimation];
    [m_CurrentAnimation release];
    m_CurrentAnimation = nil;

    [super makeKeyAndOrderFront:sender];
    [self setAlphaValue:1.0f];
}

- (void)makeKeyAndOrderFront:(id)sender
{
    if(![self isVisible] && m_IsAnimationEnabled)
    {
        [self setAlphaValue:0.0f];
        [super makeKeyAndOrderFront:sender];
        [self fadeIn];
    }
    else
        [super makeKeyAndOrderFront:sender];
}

- (void)orderFront:(id)sender
{
    if(![self isVisible] && m_IsAnimationEnabled)
    {
        [self setAlphaValue:0.0f];
        [super orderFront:sender];
        [self fadeIn];
    }
    else
        [super orderFront:sender];
}

- (void)orderOut:(id)sender
{
    if([self isVisible] && m_IsAnimationEnabled)
    {
        [self setAlphaValue:1.0f];
        [super orderOut:sender];
        [self fadeOut];
    }
    else
        [super orderOut:sender];
}

- (void)close
{
    if([self isVisible] && m_IsAnimationEnabled)
    {
        if(m_CurrentAnimation == nil ||
         ![m_CurrentAnimation isAnimating] ||
          ((id)[m_CurrentAnimation delegate]) != self)
        {
            [self fadeOut];
        }
    }
    else
        [super close];
}

- (BOOL)isAnimationEnabled
{
    return m_IsAnimationEnabled;
}

- (void)setAnimationEnabled:(BOOL)enabled
{
    if(m_IsAnimationEnabled == enabled)
        return;

    m_IsAnimationEnabled = enabled;
    if(m_IsAnimationEnabled)
    {
        if(![self isVisible])
            [self setAlphaValue:0.0f];
    }
    else
    {
        [m_CurrentAnimation stopAnimation];
        [m_CurrentAnimation release];
        m_CurrentAnimation = nil;

        [self setAlphaValue:1.0f];
    }
}

- (void)animationDidEnd:(NSAnimation*)animation
{
    [m_CurrentAnimation release];
    m_CurrentAnimation = nil;
    [super close];
}

@end

@implementation AnimatedWindow (PrivarePart)

- (void)fadeIn
{
    [m_CurrentAnimation stopAnimation];
    [m_CurrentAnimation release];

    m_CurrentAnimation = [[NSViewAnimation alloc] initWithViewAnimations:
                            [NSArray arrayWithObject:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                    self,                           NSViewAnimationTargetKey,
                                    NSViewAnimationFadeInEffect,    NSViewAnimationEffectKey,
                                    nil]]];

    [m_CurrentAnimation setDuration:0.25];
    [m_CurrentAnimation setCurrentProgress:[self alphaValue]];
    [m_CurrentAnimation setAnimationBlockingMode:NSAnimationNonblocking];
    [m_CurrentAnimation startAnimation];
}

- (void)fadeOut
{
    [m_CurrentAnimation stopAnimation];
    [m_CurrentAnimation release];

    m_CurrentAnimation = [[NSViewAnimation alloc] initWithViewAnimations:
                            [NSArray arrayWithObject:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                    self,                           NSViewAnimationTargetKey,
                                    NSViewAnimationFadeOutEffect,   NSViewAnimationEffectKey,
                                    nil]]];

    [m_CurrentAnimation setDuration:0.25];
    [m_CurrentAnimation setDelegate:(id)self];
    [m_CurrentAnimation setCurrentProgress:1.0 - [self alphaValue]];
    [m_CurrentAnimation setAnimationBlockingMode:NSAnimationNonblocking];
    [m_CurrentAnimation startAnimation];
}

@end
