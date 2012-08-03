//
//  WiimoteLEDPart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteLEDPart.h"
#import "WiimoteEventDispatcher+LED.h"
#import "WiimoteDelegate.h"
#import "WiimoteDevice.h"

@implementation WiimoteLEDPart

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteLEDPart class]];
}

- (NSUInteger)highlightedLEDMask
{
    uint8_t     hardwareState = [m_Device LEDsState];
    NSUInteger  result        = 0;

    if((hardwareState & WiimoteDeviceSetLEDStateCommandFlagLEDOne) != 0)
        result |= WiimoteLEDFlagOne;

    if((hardwareState & WiimoteDeviceSetLEDStateCommandFlagLEDTwo) != 0)
        result |= WiimoteLEDFlagTwo;

    if((hardwareState & WiimoteDeviceSetLEDStateCommandFlagLEDThree) != 0)
        result |= WiimoteLEDFlagThree;

    if((hardwareState & WiimoteDeviceSetLEDStateCommandFlagLEDFour) != 0)
        result |= WiimoteLEDFlagFour;

    return result;
}

- (void)setHighlightedLEDMask:(NSUInteger)mask
{
    if([self highlightedLEDMask] == mask)
        return;

	uint8_t hardwareState = 0;

    if((mask & WiimoteLEDFlagOne) != 0)
        hardwareState |= WiimoteDeviceSetLEDStateCommandFlagLEDOne;

    if((mask & WiimoteLEDFlagTwo) != 0)
        hardwareState |= WiimoteDeviceSetLEDStateCommandFlagLEDTwo;

    if((mask & WiimoteLEDFlagThree) != 0)
        hardwareState |= WiimoteDeviceSetLEDStateCommandFlagLEDThree;

    if((mask & WiimoteLEDFlagFour) != 0)
        hardwareState |= WiimoteDeviceSetLEDStateCommandFlagLEDFour;

    if(![m_Device setLEDsState:hardwareState])
        return;

    [[self eventDispatcher] postHighlightedLEDMaskChangedNotification:mask];
}

- (void)setDevice:(WiimoteDevice*)device
{
    m_Device = device;
}

@end
