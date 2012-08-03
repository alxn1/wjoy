//
//  WiimoteVibrationPart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteVibrationPart.h"
#import "WiimoteEventDispatcher+Vibration.h"
#import "WiimoteLEDPart.h"
#import "WiimoteDevice.h"

@implementation WiimoteVibrationPart

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteVibrationPart class]];
}

- (BOOL)isVibrationEnabled
{
    return [m_Device isVibrationEnabled];
}

- (void)setVibrationEnabled:(BOOL)enabled
{
    if([self isVibrationEnabled] == enabled)
        return;

	if(![m_Device setVibrationEnabled:enabled])
        return;

    [[self eventDispatcher] postVibrationStateChangedNotification:enabled];
}

- (void)setDevice:(WiimoteDevice*)device
{
	m_Device = device;
}

@end
