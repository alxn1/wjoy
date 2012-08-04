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

- (double)pitch
{
    return m_Roll;
}

- (double)roll
{
    return m_Pitch;
}

- (void)setPitch:(double)pitch roll:(double)roll
{
    if(WiimoteDeviceIsFloatEqualEx(m_Pitch, pitch, 2.5) &&
       WiimoteDeviceIsFloatEqualEx(m_Roll,	roll,  2.5))
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

    WiimoteDeviceReportType reportType = [report type];

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

	const WiimoteDeviceButtonAndAccelerometerStateReport *stateReport =
            (const WiimoteDeviceButtonAndAccelerometerStateReport*)[[report data] bytes];

    uint16_t hardwareX	= (((uint16_t)stateReport->accelerometerX) << 2) | (((stateReport->accelerometerAdditionalX  >> 5) & 0x3) << 0);
    uint16_t hardwareY	= (((uint16_t)stateReport->accelerometerY) << 2) | (((stateReport->accelerometerAdditionalYZ >> 5) & 0x1) << 1);
    uint16_t hardwareZ	= (((uint16_t)stateReport->accelerometerZ) << 2) | (((stateReport->accelerometerAdditionalYZ >> 6) & 0x1) << 1);
    double	 x			= (((double)hardwareX) - ((double)m_ZeroX)) / (((double)m_1gX) - ((double)m_ZeroX));
    double	 y			= (((double)hardwareY) - ((double)m_ZeroY)) / (((double)m_1gY) - ((double)m_ZeroY));
    double	 z			= (((double)hardwareZ) - ((double)m_ZeroZ)) / (((double)m_1gZ) - ((double)m_ZeroZ));

    if(x < -1.0) x = 1.0; else
    if(x >  1.0) x = 1.0;

    if(y < -1.0) y = 1.0; else
    if(y >  1.0) y = 1.0;

    if(z < -1.0) z = 1.0; else
    if(z >  1.0) z = 1.0;

    double newPitch = m_Pitch;
    double newRoll  = m_Roll;

    if(abs(hardwareX - m_ZeroX) <= (m_1gX - m_ZeroX))
        newRoll  = (atan2(x, z) * 180.0) / M_PI;

    if(abs(hardwareY - m_ZeroY) <= (m_1gY - m_ZeroY))
        newPitch = (atan2(y, z) * 180.0) / M_PI;

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
