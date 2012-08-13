//
//  MainController.m
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "MainController.h"

#import "IceView.h"

@interface MainController (PrivatePart)

- (void)screenChanged;

@end

static void screenSettingsChanged(
                CGDirectDisplayID            display,
                CGDisplayChangeSummaryFlags  flags,
                void                        *userInfo)
{
    if(userInfo == NULL)
        return;

    [(MainController*)userInfo
        performSelectorOnMainThread:@selector(screenChanged)
                         withObject:nil
                      waitUntilDone:NO];
}

@implementation MainController

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    CGDisplayRegisterReconfigurationCallback(screenSettingsChanged, self);

    return self;
}

- (void)awakeFromNib
{
    m_StatusBarItem = [[[NSStatusBar systemStatusBar] 
                statusItemWithLength:NSSquareStatusItemLength] retain];

    NSImage *trayIcon = [NSImage imageNamed:@"ice_tray"];

    [trayIcon setSize: NSMakeSize(18.0f, 18.0f)];

    [m_StatusBarItem setMenu:m_StatusBarMenu];
    [m_StatusBarItem setHighlightMode:YES];
    [m_StatusBarItem setImage:trayIcon];

    [m_MoutionBlurMenuItem setState:
        [[NSUserDefaults standardUserDefaults] integerForKey:@"moutionBlurEnabled"]];

	[self screenChanged];
}

- (void)dealloc
{
    CGDisplayRemoveReconfigurationCallback(screenSettingsChanged, self);
    [m_StatusBarItem release];
    [super dealloc];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
    return YES;
}

- (void)screenChanged
{
    [m_Window setFrame:[[NSScreen mainScreen] frame] display:YES];
}

- (IBAction)toggleMoutionBlur:(id)sender
{
    if([m_MoutionBlurMenuItem state] == NSOnState)
        [m_MoutionBlurMenuItem setState:NSOffState];
    else
        [m_MoutionBlurMenuItem setState:NSOnState];
}

- (IBAction)exit:(id)sender
{
    [[NSUserDefaults standardUserDefaults]
                                setInteger:[m_MoutionBlurMenuItem state]
                                    forKey:@"moutionBlurEnabled"];

    [m_StatusBarItem release];
    m_StatusBarItem = nil;

    [m_IceView beginQuit];
}

@end
