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
    [self setGravitySmoothQuant:0.1];
    [self setAnglesSmoothQuant:5.0];
    [self setHardwareZeroX:0 y:0 z:0];
    [self setHardware1gX:1 y:1 z:1];
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

    m_IsEnabled = enabled;

    [self reset];
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
