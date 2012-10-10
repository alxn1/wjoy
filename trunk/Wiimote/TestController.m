//
//  TestController.m
//  Wiimote
//
//  Created by alxn1 on 09.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "TestController.h"

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
    [WiimoteWrapper setLog:self];

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
                                       selector:@selector(wiimoteConnected)
                                           name:WiimoteConnectedNotification
                                         object:nil];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(wiimoteDisconnected)
                                           name:WiimoteDisconnectedNotification
                                         object:nil];

    [self updateWindowState];
}

- (IBAction)discovery:(id)sender
{
    [WiimoteWrapper discoveryNew];
}

- (IBAction)clearLog:(id)sender
{
    [m_Log setString:@""];
}

- (void)wiimoteWrapper:(WiimoteWrapper*)wrapper log:(NSString*)logLine
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
    [self wiimoteWrapper:nil log:@"Begin discovery..."];
}

- (void)discoveryEnd
{
    m_IsDiscovering = NO;
    [self updateWindowState];
    [self wiimoteWrapper:nil log:@"End discovery"];
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

@end
