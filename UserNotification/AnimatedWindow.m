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

    isAnimationEnabled = NO;

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

    isAnimationEnabled = NO;

    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if(self == nil)
        return nil;

    isAnimationEnabled = NO;

    return self;
}

- (void)dealloc
{
    [currentAnimation stopAnimation];
    [currentAnimation release];
    [super dealloc];
}

- (void)makeKeyAndOrderFromWithoutAnimation:(id)sender
{
    [currentAnimation stopAnimation];
    [currentAnimation release];
    currentAnimation = nil;

    [super makeKeyAndOrderFront:sender];
    [self setAlphaValue:1.0f];
}

- (void)makeKeyAndOrderFront:(id)sender
{
    if(![self isVisible] && isAnimationEnabled)
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
    if(![self isVisible] && isAnimationEnabled)
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
    if([self isVisible] && isAnimationEnabled)
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
    if([self isVisible] && isAnimationEnabled)
    {
        if(currentAnimation == nil ||
         ![currentAnimation isAnimating] ||
          [currentAnimation delegate] != ((id<NSAnimationDelegate>)self))
        {
            [self fadeOut];
        }
    }
    else
        [super close];
}

// MARK: public

- (BOOL)isAnimationEnabled
{
    return isAnimationEnabled;
}

- (void)setAnimationEnabled:(BOOL)enabled
{
    if(isAnimationEnabled == enabled)
        return;

    isAnimationEnabled = enabled;
    if(isAnimationEnabled)
    {
        if(![self isVisible])
            [self setAlphaValue:0.0f];
    }
    else
    {
        [currentAnimation stopAnimation];
        [currentAnimation release];
        currentAnimation = nil;

        [self setAlphaValue:1.0f];
    }
}

- (void)animationDidEnd:(NSAnimation*)animation
{
    [currentAnimation release];
    currentAnimation = nil;
    [super close];
}

@end

@implementation AnimatedWindow (PrivarePart)

- (void)fadeIn
{
    [currentAnimation stopAnimation];
    [currentAnimation release];

    currentAnimation = [[NSViewAnimation alloc] initWithViewAnimations:
                            [NSArray arrayWithObject:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                    self,                           NSViewAnimationTargetKey,
                                    NSViewAnimationFadeInEffect,    NSViewAnimationEffectKey,
                                    nil]]];

    [currentAnimation setDuration:0.25];
    [currentAnimation setCurrentProgress:[self alphaValue]];
    [currentAnimation setAnimationBlockingMode:NSAnimationNonblocking];
    [currentAnimation startAnimation];
}

- (void)fadeOut
{
    [currentAnimation stopAnimation];
    [currentAnimation release];

    currentAnimation = [[NSViewAnimation alloc] initWithViewAnimations:
                            [NSArray arrayWithObject:
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                    self,                           NSViewAnimationTargetKey,
                                    NSViewAnimationFadeOutEffect,   NSViewAnimationEffectKey,
                                    nil]]];

    [currentAnimation setDuration:0.25];
    [currentAnimation setDelegate:(id)self];
    [currentAnimation setCurrentProgress:1.0 - [self alphaValue]];
    [currentAnimation setAnimationBlockingMode:NSAnimationNonblocking];
    [currentAnimation startAnimation];
}

@end
