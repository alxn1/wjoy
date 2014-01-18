//
//  TestController.m
//  Wiimote
//
//  Created by alxn1 on 09.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "TestController.h"

#import <Wiimote/WiimoteEventSystem.h>

@implementation TestController

- (void)updateWindowState
{
    [m_DiscoveryButton setEnabled:
                            (!m_IsDiscovering) &&
                            (m_ConnectedWiimotes == 0)];

    [m_ConnectedTextField setStringValue:
                            ((m_ConnectedWiimotes == 0)?
                                (@"No wii remote connected"):
                                (@"Wii remote connected"))];
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(discoveryBegin)
                                           name:WiimoteBeginDiscoveryNotification
                                         object:nil];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(discoveryEnd)
                                           name:WiimoteEndDiscoveryNotification
                                         object:nil];

    [[NSNotificationCenter defaultCenter]
								addObserver:self
								   selector:@selector(applicationWillTerminateNotification:)
									   name:NSApplicationWillTerminateNotification
									 object:[NSApplication sharedApplication]];

    [[WiimoteEventSystem defaultEventSystem] addObserver:self];
    [[WiimoteWatchdog sharedWatchdog] setEnabled:YES];

    [self updateWindowState];
	[self discovery:self];
}

- (IBAction)toggleUseOneButtonClickConnection:(id)sender
{
    [Wiimote setUseOneButtonClickConnection:[sender state] == NSOnState];
}

- (IBAction)discovery:(id)sender
{
    [Wiimote beginDiscovery];
}

- (IBAction)clearLog:(id)sender
{
    [m_Log setString:@""];
}

- (void)log:(NSString*)logLine
{
    NSAttributedString *tmp = [[NSAttributedString alloc]
                                    initWithString:[NSString stringWithFormat:@"%@\n", logLine]];

    [[m_Log textStorage] appendAttributedString:tmp];
    [tmp release];
}

- (void)discoveryBegin
{
    m_IsDiscovering = YES;
    [self updateWindowState];
    [self log:@"Begin discovery..."];
}

- (void)discoveryEnd
{
    m_IsDiscovering = NO;
    [self updateWindowState];
    [self log:@"End discovery"];
}

- (void)wiimoteConnected
{
    m_ConnectedWiimotes++;
    [self updateWindowState];
}

- (void)wiimoteDisconnected
{
    m_ConnectedWiimotes--;
    [self updateWindowState];
}

- (void)wiimoteEvent:(WiimoteEvent*)event
{
    if([[event path] isEqualToString:@"Connect"])
    {
        [[event wiimote] setHighlightedLEDMask:WiimoteLEDFlagOne];
        [[event wiimote] playConnectEffect];
        [self wiimoteConnected];
    }

    if([[event path] isEqualToString:@"Disconnect"])
        [self wiimoteDisconnected];

    [self log:
        [NSString stringWithFormat:@"%@ (%@): %@: %lf",
                                        [[event wiimote] modelName],
                                        [[event wiimote] addressString],
                                        [event path],
                                        [event value]]];
}

- (void)applicationWillTerminateNotification:(NSNotification*)notification
{
    NSArray     *devices = [Wiimote connectedDevices];
	NSUInteger   count   = [devices count];

    for(NSUInteger i = 0; i < count; i++)
        [[devices objectAtIndex:i] disconnect];
}

@end
