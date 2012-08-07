//
//  WiimoteAccelerometer.m
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAccelerometer+PlugIn.h"

@implementation WiimoteAccelerometer

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    m_IsEnabled = NO;
    [self setGravitySmoothQuant:0.15];
    [self setAnglesSmoothQuant:5.0];
    [self setHardwareZeroX:500 y:500 z:500];
    [self setHardware1gX:600 y:600 z:600];
    [self reset];

    return self;
}

- (BOOL)isEnabled
{
    return m_IsEnabled;
}

- (void)setEnabled:(BOOL)enabled
{
    if(m_IsEnabled == enabled)
        return;

	[self reset];
    m_IsEnabled = enabled;

    [m_Delegate wiimoteAccelerometer:self enabledStateChanged:enabled];
}

- (double)gravityX
{
    return m_GravityX;
}

- (double)gravityY
{
    return m_GravityY;
}

- (double)gravityZ
{
    return m_GravityZ;
}

- (double)pitch
{
    return m_Pitch;
}

- (double)roll
{
    return m_Roll;
}

- (double)gravitySmoothQuant
{
    return m_GravitySmoothQuant;
}

- (void)setGravitySmoothQuant:(double)quant
{
    m_GravitySmoothQuant = quant;
}

- (double)anglesSmoothQuant
{
    return m_AnglesSmoothQuant;
}

- (void)setAnglesSmoothQuant:(double)quant
{
    m_AnglesSmoothQuant = quant;
}

@end
