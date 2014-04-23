//
//  MainController.m
//  WATest
//
//  Created by alxn1 on 23.04.14.
//  Copyright 2014 alxn1. All rights reserved.
//

#import "MainController.h"

#import <Wiimote/Wiimote.h>
#import <OCLog/OCLog.h>

@implementation MainController

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    // for debug output
    [[OCLog sharedLog] setLevel:OCLogLevelDebug];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(wiimoteConnectedNotification:)
                                           name:WiimoteConnectedNotification
                                         object:nil];

    [Wiimote setUseOneButtonClickConnection:YES]; // ;)
    [Wiimote beginDiscovery]; // begin wait for new wiimotes (what not paired). 30 sec.
    // If wiimote already paired, it can be connected without discovering.

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)wiimoteConnectedNotification:(NSNotification*)notification
{
    Wiimote *wiimote = [notification object];

    // debug message
    NSLog(@"Wiimote connected: %@ (%@)", [wiimote modelName], [wiimote addressString]);

    // begin listen events from wiimote (see WiimoteDelegate.h)
    [wiimote setDelegate:self];
    [[wiimote accelerometer] setEnabled:YES]; // and enable accelerometer
}

- (void)wiimote:(Wiimote*)wiimote accelerometerChangedGravityX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
    // raw accelerometer values.
    // sensitivity can be changed by [[wiimot accelerometer] setGravitySmoothQuant: <value> ];

    NSLog(@"RAW: X: %f, Y: %f, Z: %f", x, y, x);
}

- (void)wiimote:(Wiimote*)wiimote accelerometerChangedPitch:(CGFloat)pitch roll:(CGFloat)roll
{
    // processed values
    // sensitivity can be changed by [[wiimot accelerometer] setAnglesSmoothQuant: <value> ];

    NSLog(@"PROCESSED: PITCH: %f, ROLL: %f", pitch, roll);
}

- (void)wiimoteDisconnected:(Wiimote*)wiimote
{
    // debug message
    NSLog(@"Wiimote disconnected: %@ (%@)", [wiimote modelName], [wiimote addressString]);
}

@end
