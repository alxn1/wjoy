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

- (CGFloat)gravityX
{
    return m_GravityX;
}

- (CGFloat)gravityY
{
    return m_GravityY;
}

- (CGFloat)gravityZ
{
    return m_GravityZ;
}

- (CGFloat)pitch
{
    return m_Pitch;
}

- (CGFloat)roll
{
    return m_Roll;
}

- (CGFloat)gravitySmoothQuant
{
    return m_GravitySmoothQuant;
}

- (void)setGravitySmoothQuant:(CGFloat)quant
{
    m_GravitySmoothQuant = quant;
}

- (CGFloat)anglesSmoothQuant
{
    return m_AnglesSmoothQuant;
}

- (void)setAnglesSmoothQuant:(CGFloat)quant
{
    m_AnglesSmoothQuant = quant;
}

@end
