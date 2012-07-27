//
//  WiimoteAutoWrapper.m
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAutoWrapper.h"

@interface WiimoteAutoWrapper (PrivatePart)

+ (NSString*)wjoyNameFromWiimoteDevice:(WiimoteDevice*)device;

+ (void)newWiimoteDeviceNotification:(NSNotification*)notification;

- (id)initWithWiimoteDevice:(WiimoteDevice*)device;

@end

@implementation WiimoteAutoWrapper

static NSUInteger maxConnectedDevices = 0;

+ (NSUInteger)maxConnectedDevices
{
    return maxConnectedDevices;
}

+ (void)setMaxConnectedDevices:(NSUInteger)count
{
    if(maxConnectedDevices == count)
        return;

    maxConnectedDevices = count;

    while([[WiimoteDevice connectedDevices] count] > count)
    {
        NSArray         *connectedDevices   = [WiimoteDevice connectedDevices];
        WiimoteDevice   *device             = [connectedDevices objectAtIndex:[connectedDevices count] - 1];

        [device disconnect];
    }
}

+ (void)start
{
    [[NSNotificationCenter defaultCenter]
                            addObserver:self
                               selector:@selector(newWiimoteDeviceNotification:)
                                   name:WiimoteDeviceConnectedNotification
                                 object:nil];
}

- (void)wiimoteDevice:(WiimoteDevice*)device buttonPressed:(WiimoteButtonType)button
{
    [m_HIDState setButton:button pressed:YES];
}

- (void)wiimoteDevice:(WiimoteDevice*)device buttonReleased:(WiimoteButtonType)button
{
    [m_HIDState setButton:button pressed:NO];
}

- (void)wiimoteDevice:(WiimoteDevice*)device highlightedLEDMaskChanged:(NSUInteger)mask
{
}

- (void)wiimoteDevice:(WiimoteDevice*)device vibrationStateChanged:(BOOL)isVibrationEnabled
{
}

- (void)wiimoteDevice:(WiimoteDevice*)device batteryLevelUpdated:(double)batteryLevel isLow:(BOOL)isLow
{
}

- (void)wiimoteDeviceDisconnected:(WiimoteDevice*)device
{
    [self release];
}

- (void)VHIDDevice:(VHIDDevice*)device stateChanged:(NSData*)state
{
    [m_WJoy updateHIDState:state];
}

@end

@implementation WiimoteAutoWrapper (PrivatePart)

+ (NSString*)wjoyNameFromWiimoteDevice:(WiimoteDevice*)device
{
    return [NSString stringWithFormat:
                            @"Nintendo Wii Remote Controller (%@)",
                            [device addressString]];
}

+ (void)newWiimoteDeviceNotification:(NSNotification*)notification
{
    [[WiimoteAutoWrapper alloc]
        initWithWiimoteDevice:
            (WiimoteDevice*)[notification object]];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithWiimoteDevice:(WiimoteDevice*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    if([[WiimoteDevice connectedDevices] count] >
       [WiimoteAutoWrapper maxConnectedDevices])
    {
        [device disconnect];
        [self release];
        return nil;
    }

    m_Device    = device;
    m_HIDState  = [[VHIDDevice alloc] initWithType:VHIDDeviceTypeJoystick
                                      pointerCount:0
                                       buttonCount:WiimoteButtonCount
                                        isRelative:NO];

    m_WJoy      = [[WJoyDevice alloc]
                             initWithHIDDescriptor:[m_HIDState descriptor]
                                     productString:[WiimoteAutoWrapper wjoyNameFromWiimoteDevice:device]];

    if(m_HIDState   == nil ||
       m_WJoy       == nil)
    {
        [device disconnect];
        [self release];
        return nil;
    }

    [m_Device setDelegate:self];
    [m_HIDState setDelegate:self];
    [m_Device setStateChangeNotificationsEnabled:NO];

    return self;
}

- (void)dealloc
{
    [m_HIDState release];
    [m_WJoy release];
    [super dealloc];
}

@end
