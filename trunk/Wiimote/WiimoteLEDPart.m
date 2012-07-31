//
//  WiimoteLEDPart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteLEDPart.h"
#import "WiimoteEventDispatcher+LED.h"

@implementation WiimoteLEDPart

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteLEDPart class]];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher ioManager:ioManager];
    if(self == nil)
        return nil;

    m_Mask = 0;
    return self;
}

- (NSUInteger)highlightedLEDMask
{
    return m_Mask;
}

- (void)setHighlightedLEDMask:(NSUInteger)mask
{
    if(m_Mask == mask)
        return;

    uint8_t     commandData         = 0;
    BOOL        isVibrationEnabled  = [[self owner] isVibrationEnabled];

    if(isVibrationEnabled)
        commandData |= WiimoteDeviceCommandFlagVibrationEnabled;

    if((mask & WiimoteLEDFlagOne) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDOne;

    if((mask & WiimoteLEDFlagTwo) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDTwo;

    if((mask & WiimoteLEDFlagThree) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDThree;

    if((mask & WiimoteLEDFlagFour) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDFour;

    if(![[self ioManager]
                postCommand:WiimoteDeviceCommandTypeSetLEDState
                       data:[NSData dataWithBytes:&commandData length:sizeof(commandData)]])
    {
        return;
    }

    m_Mask = mask;
    [[self eventDispatcher] postHighlightedLEDMaskChangedNotification:mask];
}

- (void)disconnected
{
    m_Mask = 0;
}

@end
