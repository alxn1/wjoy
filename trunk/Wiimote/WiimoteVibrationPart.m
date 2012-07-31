//
//  WiimoteVibrationPart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteVibrationPart.h"
#import "WiimoteEventDispatcher+Vibration.h"

@implementation WiimoteVibrationPart

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteVibrationPart class]];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher ioManager:ioManager];
    if(self == nil)
        return nil;

    m_IsVibrationEnabled = NO;
    return self;
}

- (BOOL)isVibrationEnabled
{
    return m_IsVibrationEnabled;
}

- (void)setVibrationEnabled:(BOOL)enabled
{
    if(m_IsVibrationEnabled == enabled)
        return;

    uint8_t     commandData         = 0;
    NSUInteger  highlightedLEDMask  = [[self owner] highlightedLEDMask];

    if(enabled)
        commandData |= WiimoteDeviceCommandFlagVibrationEnabled;

    if((highlightedLEDMask & WiimoteLEDFlagOne) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDOne;

    if((highlightedLEDMask & WiimoteLEDFlagTwo) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDTwo;

    if((highlightedLEDMask & WiimoteLEDFlagThree) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDThree;

    if((highlightedLEDMask & WiimoteLEDFlagFour) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDFour;

    m_IsVibrationEnabled = enabled;
    if(![[self ioManager]
                postCommand:WiimoteDeviceCommandTypeSetLEDState
                       data:[NSData dataWithBytes:&commandData length:sizeof(commandData)]])
    {
        m_IsVibrationEnabled = !enabled;
        return;
    }

    [[self eventDispatcher] postVibrationStateChangedNotification:enabled];
}

- (void)disconnected
{
    m_IsVibrationEnabled = NO;
}

@end
