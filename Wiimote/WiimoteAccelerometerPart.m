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

- (void)beginReadCalibrationData;
- (void)handleCalibrationData:(NSData*)data;
- (void)checkCalibrationData;

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

    m_IsCalibrationDataReaded   = NO;
    m_Accelerometer             = [[WiimoteAccelerometer alloc] init];

    [m_Accelerometer setDelegate:self];

    return self;
}

- (void)dealloc
{
    [m_Accelerometer setDelegate:nil];
    [m_Accelerometer release];
    [super dealloc];
}

- (WiimoteAccelerometer*)accelerometer
{
    return [[m_Accelerometer retain] autorelease];
}

- (NSSet*)allowedReportTypeSet
{
    static NSSet *result = nil;

    if(![m_Accelerometer isEnabled])
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
	if(![[self owner] isWiiUProController])
		[self beginReadCalibrationData];
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    if(![m_Accelerometer isEnabled] || !m_IsCalibrationDataReaded)
        return;

    if([report length] < sizeof(WiimoteDeviceButtonAndAccelerometerStateReport))
        return;

    WiimoteDeviceReportType reportType = (WiimoteDeviceReportType)[report type];

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
            (const WiimoteDeviceButtonAndAccelerometerStateReport*)[report data];

    uint16_t x = (((uint16_t)stateReport->accelerometerX) << 2) | (((stateReport->accelerometerAdditionalX  >> 5) & 0x3) << 0);
    uint16_t y = (((uint16_t)stateReport->accelerometerY) << 2) | (((stateReport->accelerometerAdditionalYZ >> 5) & 0x1) << 1);
    uint16_t z = (((uint16_t)stateReport->accelerometerZ) << 2) | (((stateReport->accelerometerAdditionalYZ >> 6) & 0x1) << 1);

    [m_Accelerometer setHardwareValueX:x y:y z:z];
}

- (void)disconnected
{
    [m_Accelerometer reset];
}

@end

@implementation WiimoteAccelerometerPart (PrivatePart)

- (void)beginReadCalibrationData
{
    NSRange memRange = NSMakeRange(
                                WiimoteDeviceCalibrationDataAddress,
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

    const WiimoteDeviceAccelerometerCalibrationData *calibrationData =
                (const WiimoteDeviceAccelerometerCalibrationData*)[data bytes];

    [m_Accelerometer setCalibrationData:calibrationData];
	[self checkCalibrationData];

    m_IsCalibrationDataReaded = YES;
}

- (void)checkCalibrationData
{
    if([m_Accelerometer isHardwareZeroValuesInvalid])
        [m_Accelerometer setHardwareZeroX:500 y:500 z:500];

    if([m_Accelerometer isHardware1gValuesInvalid])
        [m_Accelerometer setHardware1gX:600 y:600 z:600];
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
         enabledStateChanged:(BOOL)enabled
{
    if(![[self owner] isConnected])
    {
        if(enabled)
            [accelerometer setEnabled:NO];

        return;
    }

    [[self owner] deviceConfigurationChanged];
    [[self eventDispatcher] postAccelerometerEnabledNotification:enabled];
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
             gravityChangedX:(CGFloat)x
                           y:(CGFloat)y
                           z:(CGFloat)z
{
    [[self eventDispatcher] postAccelerometerGravityChangedNotificationX:x y:y z:z];
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
                pitchChanged:(CGFloat)pitch
                        roll:(CGFloat)roll
{
    [[self eventDispatcher] postAccelerometerAnglesChangedNotificationPitch:pitch roll:roll];
}

@end
