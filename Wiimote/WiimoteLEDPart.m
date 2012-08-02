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

	NSUInteger oldMask = m_Mask;

	m_Mask = mask;
	if(![self updateHadwareLEDState])
	{
		m_Mask = oldMask;
		return;
	}

    [[self eventDispatcher] postHighlightedLEDMaskChangedNotification:mask];
}

- (BOOL)updateHadwareLEDState
{
	uint8_t commandData = 0;

    if((m_Mask & WiimoteLEDFlagOne) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDOne;

    if((m_Mask & WiimoteLEDFlagTwo) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDTwo;

    if((m_Mask & WiimoteLEDFlagThree) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDThree;

    if((m_Mask & WiimoteLEDFlagFour) != 0)
        commandData |= WiimoteDeviceSetLEDStateCommandFlagLEDFour;

    return [[self ioManager]
                postCommand:WiimoteDeviceCommandTypeSetLEDState
                       data:[NSData dataWithBytes:&commandData length:sizeof(commandData)]];
}

- (void)disconnected
{
    m_Mask = 0;
}

@end
