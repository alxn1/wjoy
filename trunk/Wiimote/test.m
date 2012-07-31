//
//  main.m
//  test
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "Wiimote.h"
#import "WiimoteWatchdog.h"

#import <Cocoa/Cocoa.h>

static NSString *wiimoteButtonName(WiimoteButtonType button)
{
    NSString *result = @"unknown";

    switch(button)
    {
        case WiimoteButtonTypeLeft:
            result = @"left";
            break;

        case WiimoteButtonTypeRight:
            result = @"right";
            break;

        case WiimoteButtonTypeUp:
            result = @"up";
            break;

        case WiimoteButtonTypeDown:
            result = @"down";
            break;

        case WiimoteButtonTypeA:
            result = @"A";
            break;

        case WiimoteButtonTypeB:
            result = @"B";
            break;

        case WiimoteButtonTypePlus:
            result = @"+";
            break;

        case WiimoteButtonTypeMinus:
            result = @"-";
            break;

        case WiimoteButtonTypeHome:
            result = @"home";
            break;

        case WiimoteButtonTypeOne:
            result = @"1";
            break;

       case  WiimoteButtonTypeTwo:
            result = @"2";
            break;
    }

    return result;
}

static NSString *nunchuckButtonName(WiimoteNunchuckButtonType button)
{
    NSString *result = @"unknown";

    switch(button)
    {
        case WiimoteNunchuckButtonTypeC:
            result = @"C";
            break;

        case WiimoteNunchuckButtonTypeZ:
            result = @"Z";
            break;
    }

    return result;
}

@interface WiimoteWrapper : NSObject
{
    @private
        Wiimote *m_Device;
}

+ (void)run;

@end

@implementation WiimoteWrapper

- (id)initWithDevice:(Wiimote*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Device = [device retain];
    [m_Device setDelegate:self];
    [m_Device setHighlightedLEDMask:WiimoteLEDFlagOne];
    [m_Device playConnectEffect];
    NSLog(@"Wrapper created");
	NSLog(@"%@", [Wiimote connectedDevices]);

    return self;
}

- (void)dealloc
{
	NSLog(@"%@", [Wiimote connectedDevices]);
    NSLog(@"Wrapper deleted");
    [m_Device setDelegate:nil];
    [m_Device release];
    [super dealloc];
}

+ (void)newDeviceConnected:(NSNotification*)notification
{
    [[WiimoteWrapper alloc] initWithDevice:[notification object]];
}

+ (void)run
{
    [[Wiimote notificationCenter]
                            addObserver:self
                               selector:@selector(newDeviceConnected:)
                                   name:WiimoteConnectedNotification
                                 object:nil];

    [Wiimote beginDiscovery];
    [[WiimoteWatchdog sharedWatchdog] setEnabled:YES];
    [[NSApplication sharedApplication] run];
}

- (void)wiimote:(Wiimote*)wiimote buttonPressed:(WiimoteButtonType)button
{
    NSLog(@"buttonPressed: %@", wiimoteButtonName(button));
}

- (void)wiimote:(Wiimote*)wiimote buttonReleased:(WiimoteButtonType)button
{
    NSLog(@"buttonReleased: %@", wiimoteButtonName(button));
}

- (void)wiimote:(Wiimote*)wiimote vibrationStateChanged:(BOOL)isVibrationEnabled
{
    NSLog(@"vibrationStateChanged: %@", ((isVibrationEnabled)?(@"YES"):(@"NO")));
}

- (void)wiimote:(Wiimote*)wiimote highlightedLEDMaskChanged:(NSUInteger)mask
{
    NSLog(@"highlightedLEDMaskChanged: %X", mask);
}

- (void)wiimote:(Wiimote*)wiimote batteryLevelUpdated:(double)batteryLevel isLow:(BOOL)isLow
{
    NSLog(@"batteryLevelUpdated: %.0lf%%, isLow: %@", batteryLevel, ((isLow)?(@"YES"):(@"NO")));
}

- (void)wiimote:(Wiimote*)wiimote extensionConnected:(WiimoteExtension*)extension
{
    NSLog(@"Extension connected: %@", [extension name]);
}

- (void)wiimote:(Wiimote*)wiimote extensionDisconnected:(WiimoteExtension*)extension
{
    NSLog(@"Extension disconnected: %@", [extension name]);
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button
{
    NSLog(@"Nunchuck button pressed: %@", nunchuckButtonName(button));
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button
{
    NSLog(@"Nunchuck button released: %@", nunchuckButtonName(button));
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position
{
    NSLog(@"Nunchuck position changed: %.0f %.0f", position.x, position.y);
}

- (void)wiimoteDisconnected:(Wiimote*)wiimote
{
    NSLog(@"Disconnected");
    [self autorelease];
}

@end

int main(int argc, const char * argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [WiimoteWrapper run];
	[pool release];
    return 0;
}
