//
//  WiimoteAutoWrapper.m
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAutoWrapper.h"

@interface WiimoteAutoWrapper (PrivatePart)

+ (NSString*)wjoyNameFromWiimote:(Wiimote*)device;
+ (NSString*)nunchuckNameFromWiimote:(Wiimote*)device;

+ (void)newWiimoteDeviceNotification:(NSNotification*)notification;

- (id)initWithWiimote:(Wiimote*)device;

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

    while([[Wiimote connectedDevices] count] > count)
    {
        NSArray  *connectedDevices   = [Wiimote connectedDevices];
        Wiimote  *device             = [connectedDevices objectAtIndex:[connectedDevices count] - 1];

        [device disconnect];
    }
}

+ (void)start
{
    [[Wiimote notificationCenter]
                            addObserver:self
                               selector:@selector(newWiimoteDeviceNotification:)
                                   name:WiimoteConnectedNotification
                                 object:nil];
}

- (void)wiimote:(Wiimote*)wiimote buttonPressed:(WiimoteButtonType)button
{
    [m_HIDState setButton:button pressed:YES];
}

- (void)wiimote:(Wiimote*)wiimote buttonReleased:(WiimoteButtonType)button
{
    [m_HIDState setButton:button pressed:NO];
}

- (void)wiimote:(Wiimote*)wiimote extensionConnected:(WiimoteExtension*)extension
{
    if(![extension conformsToProtocol:@protocol(WiimoteNunchuckProtocol)])
        return;

	m_NunchuckHIDState  = [[VHIDDevice alloc]
									initWithType:VHIDDeviceTypeJoystick
									pointerCount:WiimoteNunchuckStickCount
									 buttonCount:WiimoteNunchuckButtonCount
									  isRelative:NO];

	m_WJoyNunchuck		= [[WJoyDevice alloc]
									initWithHIDDescriptor:[m_NunchuckHIDState descriptor]
											productString:[WiimoteAutoWrapper nunchuckNameFromWiimote:[extension owner]]];

	[m_NunchuckHIDState setDelegate:self];
}

- (void)wiimote:(Wiimote*)wiimote extensionDisconnected:(WiimoteExtension*)extension
{
    [m_NunchuckHIDState release];
	[m_WJoyNunchuck release];

	m_NunchuckHIDState = nil;
	m_WJoyNunchuck = nil;
}

- (void)wiimoteDisconnected:(Wiimote*)wiimote
{
    [self release];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button
{
    [m_NunchuckHIDState setButton:button pressed:YES];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button
{
    [m_NunchuckHIDState setButton:button pressed:NO];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position
{
    [m_NunchuckHIDState setPointer:0 position:position];
}

- (void)VHIDDevice:(VHIDDevice*)device stateChanged:(NSData*)state
{
    if(device == m_HIDState)
		[m_WJoy updateHIDState:state];
	else
		[m_WJoyNunchuck updateHIDState:state];
}

@end

@implementation WiimoteAutoWrapper (PrivatePart)

+ (NSString*)wjoyNameFromWiimote:(Wiimote*)device
{
    return [NSString stringWithFormat:
                            @"Nintendo Wii Remote Controller (%@)",
                            [device addressString]];
}

+ (NSString*)nunchuckNameFromWiimote:(Wiimote*)device
{
	return [NSString stringWithFormat:
                            @"Nintendo Wii Remote Nunchuck (%@)",
                            [device addressString]];
}

+ (void)newWiimoteDeviceNotification:(NSNotification*)notification
{
    [[WiimoteAutoWrapper alloc]
        initWithWiimote:(Wiimote*)[notification object]];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithWiimote:(Wiimote*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    if([[Wiimote connectedDevices] count] >
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
                                     productString:[WiimoteAutoWrapper wjoyNameFromWiimote:device]];

    if(m_HIDState   == nil ||
       m_WJoy       == nil)
    {
        [device disconnect];
        [self release];
        return nil;
    }

    [m_Device setDelegate:self];
    [m_HIDState setDelegate:self];

    return self;
}

- (void)dealloc
{
    [m_HIDState release];
    [m_WJoy release];
    [super dealloc];
}

@end
