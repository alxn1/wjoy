//
//  WiimoteAccelerometerPart.m
//  Wiimote
//
//  Created by alxn1 on 03.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAccelerometerPart.h"
#import "WiimoteEventDispatcher+Accelerometer.h"
#import "Wiimote+PlugIn.h"

@interface WiimoteAccelerometerPart (PrivatePart)

- (void)reset;

- (void)beginReadCalibrationData;
- (void)handleCalibrationData:(NSData*)data;

@end

@implementation WiimoteAccelerometerPart

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteAccelerometerPart class]];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher ioManager:ioManager];
    if(self == nil)
        return nil;

    [self reset];
    m_IsCalibrationDataReaded   = NO;
    m_IsEnabled                 = NO;

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
    [[self owner] deviceConfigurationChanged];
    [[self eventDispatcher] postAccelerometerEnabledNotification:enabled];
}

- (double)x
{
    return m_Z;
}

- (double)y
{
    return m_Y;
}

- (double)z
{
    return m_Z;
}

- (double)pitch
{
    return m_Roll;
}

- (double)roll
{
    return m_Pitch;
}

- (void)setX:(double)x Y:(double)y Z:(double)z
{
    if(WiimoteDeviceIsFloatEqual(m_X, x) &&
       WiimoteDeviceIsFloatEqual(m_Y, y) &&
       WiimoteDeviceIsFloatEqual(m_Z, z))
    {
        return;
    }

    m_X = x;
    m_Y = y;
    m_Z = z;

    [[self eventDispatcher] postAccelerometerValueChangedNotificationX:x Y:y Z:z];
}

- (void)setPitch:(double)pitch roll:(double)roll
{
    if(WiimoteDeviceIsFloatEqualEx(m_Pitch, pitch, 2.5) &&
       WiimoteDeviceIsFloatEqualEx(m_Roll, roll, 2.5))
    {
        return;
    }

    m_Pitch = pitch;
    m_Roll  = roll;

    [[self eventDispatcher] postAccelerometerValueChangedNotificationPitch:pitch roll:roll];
}

- (NSSet*)allowedReportTypeSet
{
    static NSSet *result = nil;

    if(![self isEnabled])
        return nil;

    if(result == nil)
    {
        result = [[NSSet alloc] initWithObjects:
                            [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerState],
                            [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerAndIR12BytesState],
                            [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerAndExtension16BytesState],
                            [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes],
                            nil] ;
    }

    return result;
}

- (void)connected
{
	[self beginReadCalibrationData];
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    if(![self isEnabled] || !m_IsCalibrationDataReaded)
        return;

    if([[report data] length] < sizeof(WiimoteDeviceButtonAndAccelerometerStateReport))
        return;

    WiimoteDeviceReportType                               reportType  = [report type];
    const WiimoteDeviceButtonAndAccelerometerStateReport *stateReport =
            (const WiimoteDeviceButtonAndAccelerometerStateReport*)[[report data] bytes];

    switch(reportType)
    {
        case WiimoteDeviceReportTypeButtonAndAccelerometerState:
        case WiimoteDeviceReportTypeButtonAndAccelerometerAndIR12BytesState:
        case WiimoteDeviceReportTypeButtonAndAccelerometerAndExtension16BytesState:
        case WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes:
            break;

        default:
            return;
    }

    uint16_t x = (((uint16_t)stateReport->accelerometerX) << 2);
    uint16_t y = (((uint16_t)stateReport->accelerometerY) << 2);
    uint16_t z = (((uint16_t)stateReport->accelerometerZ) << 2);

    x |= (stateReport->accelerometerAdditionalX >> 5) & 0x3;
    y |= ((stateReport->accelerometerAdditionalYZ >> 5) & 0x1) << 1;
    z |= ((stateReport->accelerometerAdditionalYZ >> 6) & 0x1) << 1;

    double newX = (((double)x) - ((double)m_ZeroX)) / (((double)m_1gX) - ((double)m_ZeroX));
    double newY = (((double)y) - ((double)m_ZeroY)) / (((double)m_1gY) - ((double)m_ZeroY));
    double newZ = (((double)z) - ((double)m_ZeroZ)) / (((double)m_1gZ) - ((double)m_ZeroZ));

    [self setX:newX Y:newY Z:newZ];

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

- (void)disconnected
{
    [self reset];
}

@end

@implementation WiimoteAccelerometerPart (PrivatePart)

- (void)reset
{
    m_X     = 0.0;
    m_Y     = 0.0;
    m_Z     = 0.0;
    m_Pitch = 0.0;
    m_Roll  = 0.0;
}

- (void)beginReadCalibrationData
{
    NSRange memRange = NSMakeRange(
                                WiimoteDeviceAccelerometerCalibrationDataAddress,
                                sizeof(WiimoteDeviceAccelerometerCalibrationData));

    if(![[self ioManager] readMemory:memRange
                              target:self
                              action:@selector(handleCalibrationData:)])
    {
        return;
    }

    [self retain];
}

- (void)handleCalibrationData:(NSData*)data
{
    [self autorelease];

    if([data length] < sizeof(WiimoteDeviceAccelerometerCalibrationData))
        return;

    m_IsCalibrationDataReaded = YES;
    const WiimoteDeviceAccelerometerCalibrationData *calibrationData =
                (const WiimoteDeviceAccelerometerCalibrationData*)[data bytes];

    m_ZeroX = (((uint16_t)calibrationData->zero.x) << 2) | ((calibrationData->zero.additionalXYZ >> 0) & 0x3);
    m_ZeroY = (((uint16_t)calibrationData->zero.y) << 2) | ((calibrationData->zero.additionalXYZ >> 2) & 0x3);
    m_ZeroZ = (((uint16_t)calibrationData->zero.z) << 2) | ((calibrationData->zero.additionalXYZ >> 4) & 0x3);

    m_1gX   = (((uint16_t)calibrationData->oneG.x) << 2) | ((calibrationData->oneG.additionalXYZ >> 0) & 0x3);
    m_1gY   = (((uint16_t)calibrationData->oneG.x) << 2) | ((calibrationData->oneG.additionalXYZ >> 2) & 0x3);
    m_1gZ   = (((uint16_t)calibrationData->oneG.x) << 2) | ((calibrationData->oneG.additionalXYZ >> 4) & 0x3);
}

@end
