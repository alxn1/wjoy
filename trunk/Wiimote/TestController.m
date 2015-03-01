//
//  TestController.m
//  Wiimote
//
//  Created by alxn1 on 09.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "TestController.h"

#import <Wiimote/WiimoteEventSystem.h>
#import <Wiimote/WiimoteWatchdog.h>

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
    [[OCLog sharedLog] setHandler:self];
    [[OCLog sharedLog] setLevel:OCLogLevelDebug];
    [[WiimoteWatchdog sharedWatchdog] setEnabled:YES];

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

    [[WiimoteEventSystem defaultEventSystem] addObserver:self];
    [[WiimoteWatchdog sharedWatchdog] setEnabled:YES];

    [self updateWindowState];
	[self discovery:self];
}

- (IBAction)toggleUseOneButtonClickConnection:(id)sender
{
    [Wiimote setUseOneButtonClickConnection:[sender state] == NSOnState];
}

- (IBAction)toggleDebugOutput:(id)sender
{
    [[OCLog sharedLog] setLevel:
                            (([m_DebugCheckBox state] == NSOnState)?
                                (OCLogLevelDebug):
                                (OCLogLevelError))];
}

- (IBAction)discovery:(id)sender
{
    [Wiimote beginDiscovery];
}

- (IBAction)clearLog:(id)sender
{
    [m_Log setString:@""];
}

- (IBAction)detectMotionPlus:(id)sender
{
    for(Wiimote *wiimote in [Wiimote connectedDevices])
        [wiimote detectMotionPlus];
}

- (IBAction)toggleVibration:(id)sender
{
    for(Wiimote *wiimote in [Wiimote connectedDevices])
        [wiimote setVibrationEnabled:![wiimote isVibrationEnabled]];
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

- (void)  log:(OCLog*)log
        level:(OCLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message
{
    [self log:
        [NSString stringWithFormat:
                            @"[%s (%llu)]:[%s]: %@",
                                                sourceFile,
                                                (unsigned long long)line,
                                                functionName,
                                                message]];
}

@end
