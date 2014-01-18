//
//  WiimoteAccelerometer+PlugIn.m
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAccelerometer+PlugIn.h"

@interface WiimoteAccelerometer (PrivatePart)

- (void)setGravityX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;
- (void)setPitch:(CGFloat)pitch roll:(CGFloat)roll;

@end

@implementation WiimoteAccelerometer (PlugIn)

- (void)setHardwareValueX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z
{
    CGFloat newX = (((CGFloat)x) - ((CGFloat)m_ZeroX)) / (((CGFloat)m_1gX) - ((CGFloat)m_ZeroX));
    CGFloat newY = (((CGFloat)y) - ((CGFloat)m_ZeroY)) / (((CGFloat)m_1gY) - ((CGFloat)m_ZeroY));
    CGFloat newZ = (((CGFloat)z) - ((CGFloat)m_ZeroZ)) / (((CGFloat)m_1gZ) - ((CGFloat)m_ZeroZ));

    [self setGravityX:newX y:newY z:newZ];

    if(newX < -1.0) newX = 1.0; else
    if(newX >  1.0) newX = 1.0;

    if(newY < -1.0) newY = 1.0; else
    if(newY >  1.0) newY = 1.0;

    if(newZ < -1.0) newZ = 1.0; else
    if(newZ >  1.0) newZ = 1.0;

    CGFloat newPitch = m_Pitch;
    CGFloat newRoll  = m_Roll;

    if(abs(x - m_ZeroX) <= (m_1gX - m_ZeroX))
        newRoll  = (atan2(newX, newZ) * 180.0) / M_PI;

    if(abs(y - m_ZeroY) <= (m_1gY - m_ZeroY))
        newPitch = (atan2(newY, newZ) * 180.0) / M_PI;

    [self setPitch:newPitch roll:newRoll];
}

- (void)setHardwareZeroX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z
{
    m_ZeroX = x;
    m_ZeroY = y;
    m_ZeroZ = z;
}

- (void)setHardware1gX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z
{
    m_1gX = x;
    m_1gY = y;
    m_1gZ = z;
}

- (void)setCalibrationData:(const WiimoteDeviceAccelerometerCalibrationData*)calibrationData
{
    uint16_t zeroX  = (((uint16_t)calibrationData->zero.x) << 2) | ((calibrationData->zero.additionalXYZ >> 0) & 0x3);
    uint16_t zeroY  = (((uint16_t)calibrationData->zero.y) << 2) | ((calibrationData->zero.additionalXYZ >> 2) & 0x3);
    uint16_t zeroZ  = (((uint16_t)calibrationData->zero.z) << 2) | ((calibrationData->zero.additionalXYZ >> 4) & 0x3);

    uint16_t gX     = (((uint16_t)calibrationData->oneG.x) << 2) | ((calibrationData->oneG.additionalXYZ >> 0) & 0x3);
    uint16_t gY     = (((uint16_t)calibrationData->oneG.y) << 2) | ((calibrationData->oneG.additionalXYZ >> 2) & 0x3);
    uint16_t gZ     = (((uint16_t)calibrationData->oneG.z) << 2) | ((calibrationData->oneG.additionalXYZ >> 4) & 0x3);

    [self setHardwareZeroX:zeroX y:zeroY z:zeroZ];
    [self setHardware1gX:gX y:gY z:gZ];
}

- (BOOL)isHardwareZeroValuesInvalid
{
    return (m_ZeroX == 0 ||
            m_ZeroY == 0 ||
            m_ZeroZ == 0);
}

- (BOOL)isHardware1gValuesInvalid
{
    return (m_1gX == 0 ||
            m_1gY == 0 ||
            m_1gZ == 0);
}

- (void)reset
{
    m_GravityX  = 0.0;
    m_GravityY  = 0.0;
    m_GravityZ  = 0.0;

    m_Pitch     = 0.0;
    m_Roll      = 0.0;

    m_IsEnabled = NO;
}

- (id)delegate
{
    return m_Delegate;
}

- (void)setDelegate:(id)delegate
{
    m_Delegate = delegate;
}

@end

@implementation WiimoteAccelerometer (PrivatePart)

- (void)setGravityX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
    x = (((CGFloat)((long long)(x / m_GravitySmoothQuant))) * m_GravitySmoothQuant);
    y = (((CGFloat)((long long)(y / m_GravitySmoothQuant))) * m_GravitySmoothQuant);
    z = (((CGFloat)((long long)(z / m_GravitySmoothQuant))) * m_GravitySmoothQuant);

    if(WiimoteDeviceIsFloatEqualEx(m_GravityX, x, m_GravitySmoothQuant) &&
       WiimoteDeviceIsFloatEqualEx(m_GravityY, y, m_GravitySmoothQuant) &&
       WiimoteDeviceIsFloatEqualEx(m_GravityZ, z, m_GravitySmoothQuant))
    {
        return;
    }

    m_GravityX = x;
    m_GravityY = y;
    m_GravityZ = z;

    [m_Delegate wiimoteAccelerometer:self gravityChangedX:x y:y z:z];
}

- (void)setPitch:(CGFloat)pitch roll:(CGFloat)roll
{
    pitch = (((CGFloat)((long long)(pitch / m_AnglesSmoothQuant))) * m_AnglesSmoothQuant);
    roll  = (((CGFloat)((long long)(roll  / m_AnglesSmoothQuant))) * m_AnglesSmoothQuant);

    if(WiimoteDeviceIsFloatEqualEx(m_Pitch, pitch, m_AnglesSmoothQuant) &&
       WiimoteDeviceIsFloatEqualEx(m_Roll,	roll,  m_AnglesSmoothQuant))
    {
        return;
    }

    m_Pitch = pitch;
    m_Roll  = roll;

    [m_Delegate wiimoteAccelerometer:self pitchChanged:pitch roll:roll];
}

@end

@implementation NSObject (WiimoteAccelerometerDelegate)

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
         enabledStateChanged:(BOOL)enabled
{
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
             gravityChangedX:(CGFloat)x
                           y:(CGFloat)y
                           z:(CGFloat)z
{
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
                pitchChanged:(CGFloat)pitch
                        roll:(CGFloat)roll
{
}

@end
