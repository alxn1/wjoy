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

- (NSDictionary*)systemInfoDictionary
{
    static NSDictionary *result = nil;

    if(result == nil)
    {
        result = [[NSDictionary dictionaryWithContentsOfFile:
                                @"/System/Library/CoreServices/ServerVersion.plist"]
                                        retain];

        if(result == nil)
        {
            result = [[NSDictionary dictionaryWithContentsOfFile:
                                @"/System/Library/CoreServices/SystemVersion.plist"]
                                        retain];
        }
    }

    return result;
}

- (BOOL)isLion
{
    static BOOL result          = NO;
    static BOOL isInitialized   = NO;

    if(!isInitialized)
    {
        NSArray *version = [[[self systemInfoDictionary]
                                        objectForKey:@"ProductVersion"]
                                                componentsSeparatedByString:@"."];

        int      major   = [[version objectAtIndex:0] intValue];
        int      minor   = [[version objectAtIndex:1] intValue];

        result           = (major >= 10 && minor > 6);
        isInitialized    = YES;
    }

    return result;
}

- (NSInteger)standartWindowLevel
{
    if([self isLion])
        return (kCGDesktopIconWindowLevel - 1);

    return (kCGDesktopWindowLevel - 1);
}

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
    [self setLevel:[self standartWindowLevel]];
    [self setCollectionBehavior:
                NSWindowCollectionBehaviorCanJoinAllSpaces |
                NS_WindowCollectionBehaviorStationary |
                NS_WindowCollectionBehaviorIgnoresCycle];

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
    [self setLevel:[self standartWindowLevel]];
    [self setCollectionBehavior:
                NSWindowCollectionBehaviorCanJoinAllSpaces |
                NS_WindowCollectionBehaviorStationary |
                NS_WindowCollectionBehaviorIgnoresCycle];

    return self;
}

@end
