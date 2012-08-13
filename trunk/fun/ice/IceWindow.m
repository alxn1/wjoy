//
//  IceWindow.m
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "IceWindow.h"

#define NS_WindowCollectionBehaviorStationary    (1 << 4)
#define NS_WindowCollectionBehaviorIgnoresCycle  (1 << 6)

@implementation IceWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:NSBorderlessWindowMask
                              backing:bufferingType
                                defer:flag];

    [self setOpaque:NO];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setCollectionBehavior:
                NSWindowCollectionBehaviorCanJoinAllSpaces |
                NS_WindowCollectionBehaviorStationary |
                NS_WindowCollectionBehaviorIgnoresCycle];

    [self setLevel:kCGDesktopIconWindowLevel - 1];

    return self;
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
                   screen:(NSScreen*)screen
{
    self = [super initWithContentRect:contentRect
                            styleMask:NSBorderlessWindowMask
                              backing:bufferingType
                                defer:flag
                               screen:screen];

    [self setOpaque:NO];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setCollectionBehavior:
                NSWindowCollectionBehaviorCanJoinAllSpaces |
                NS_WindowCollectionBehaviorStationary |
                NS_WindowCollectionBehaviorIgnoresCycle];

    [self setLevel:kCGDesktopIconWindowLevel - 1];

    return self;
}

@end
