//
//  test.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Wiimote+Audio.h"

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
    [m_Device setHighlightedLEDMask:WiimoteLEDFlagOne];
    [m_Device playConnectEffect];
    [m_Device playAudioFile:@"/Users/alxn1/Desktop/test.mp3" volume:1.0];

    NSLog(@"Wrapper created");
    NSLog(@"%@", [m_Device modelName]);

    return self;
}

- (void)dealloc
{
    NSLog(@"Wrapper deleted");
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
