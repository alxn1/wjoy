//
//  WiimoteAccelerometer+PlugIn.m
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAccelerometer+PlugIn.h"

@interface WiimoteAccelerometer (PrivatePart)

- (void)setGravityX:(double)x y:(double)y z:(double)z;
- (void)setPitch:(double)pitch roll:(double)roll;

@end

@implementation WiimoteAccelerometer (PlugIn)

- (void)setHardwareValueX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z
{
    double newX = (((double)x) - ((double)m_ZeroX)) / (((double)m_1gX) - ((double)m_ZeroX));
    double newY = (((double)y) - ((double)m_ZeroY)) / (((double)m_1gY) - ((double)m_ZeroY));
    double newZ = (((double)z) - ((double)m_ZeroZ)) / (((double)m_1gZ) - ((double)m_ZeroZ));

    [self setGravityX:newX y:newY z:newZ];

    if(newX < -1.0) newX = 1.0; else
    if(newX >  1.0) newX = 1.0;

    if(newY < -1.0) newY = 1.0; else
    if(newY >  1.0) newY = 1.0;

    if(newZ < -1.0) newZ = 1.0; else
    if(newZ >  1.0) newZ = 1.0;

    double newPitch = m_Pitch;
    double newRoll  = m_Roll;

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

- (void)setGravityX:(double)x y:(double)y z:(double)z
{
    x = (((double)((long long)(x / m_GravitySmoothQuant))) * m_GravitySmoothQuant);
    y = (((double)((long long)(y / m_GravitySmoothQuant))) * m_GravitySmoothQuant);
    z = (((double)((long long)(z / m_GravitySmoothQuant))) * m_GravitySmoothQuant);

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

- (void)setPitch:(double)pitch roll:(double)roll
{
    pitch = (((double)((long long)(pitch / m_AnglesSmoothQuant))) * m_AnglesSmoothQuant);
    roll  = (((double)((long long)(roll  / m_AnglesSmoothQuant))) * m_AnglesSmoothQuant);

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
             gravityChangedX:(double)x
                           y:(double)y
                           z:(double)z
{
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
                pitchChanged:(double)pitch
                        roll:(double)roll
{
}

@end
