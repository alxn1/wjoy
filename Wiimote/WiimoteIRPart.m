//
//  WiimoteIRPart.m
//  Wiimote
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteIRPart.h"
#import "WiimoteProtocol.h"
#import "WiimoteIRPoint+Private.h"
#import "WiimoteEventDispatcher+IR.h"
#import "Wiimote+PlugIn.h"

@interface WiimoteIRPart (PrivatePart)

- (WiimoteDeviceIRMode)irModeFromReportType:(WiimoteDeviceReportType)reportType;

- (void)enableHardware:(WiimoteDeviceIRMode)irMode;
- (void)disableHardware;

- (void)setPoint:(NSUInteger)index position:(NSPoint)newPosition;
- (void)setPointOutOfView:(NSUInteger)index;

- (void)handleIRData:(const uint8_t*)data length:(NSUInteger)length;

@end

@implementation WiimoteIRPart

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteIRPart class]];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher ioManager:ioManager];
    if(self == nil)
        return nil;

    m_IsEnabled         = NO;
    m_IsHardwareEnabled = NO;
    m_IRReportMode      = -1;
    m_ReportType        = -1;
    m_ReportCounter     = 0;
    m_Points            = [[NSArray alloc] initWithObjects:
                                    [WiimoteIRPoint pointWithOwner:owner index:0],
                                    [WiimoteIRPoint pointWithOwner:owner index:1],
                                    [WiimoteIRPoint pointWithOwner:owner index:2],
                                    [WiimoteIRPoint pointWithOwner:owner index:3],
                                    nil];

    return self;
}

- (void)dealloc
{
    [m_Points release];
    [super dealloc];
}

- (BOOL)isEnabled
{
    return m_IsEnabled;
}

- (void)setEnabled:(BOOL)enabled
{
    if(![[self owner] isConnected])
        return;

    if(m_IsEnabled == enabled)
        return;

    if(!enabled)
        [self disableHardware];

    m_IsEnabled     = enabled;
    m_IRReportMode  = -1;
    m_ReportType    = -1;

    [[self owner] deviceConfigurationChanged];
    [[self eventDispatcher] postIREnabledStateChangedNotification:enabled];
}

- (WiimoteIRPoint*)point:(NSUInteger)index
{
    return [m_Points objectAtIndex:index];
}

- (NSSet*)allowedReportTypeSet
{
    static NSSet *allowedReportTypeSet = nil;

    if(![self isEnabled])
        return nil;

    if(allowedReportTypeSet == nil)
    {
        allowedReportTypeSet = [[NSSet alloc] initWithObjects:
            [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerAndIR12BytesState],
            [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndIR10BytesAndExtension9BytesState],
            [NSNumber numberWithInteger:WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes],
            nil];
    }

    return allowedReportTypeSet;
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    if(![self isEnabled])
        return;

    WiimoteDeviceReportType reportType      = (WiimoteDeviceReportType)[report type];
    NSUInteger              irDataOffset    = 0;
    NSUInteger              irDataSize      = 0;

    switch(reportType)
    {
        case WiimoteDeviceReportTypeButtonAndAccelerometerAndIR12BytesState:
            irDataOffset    = sizeof(WiimoteDeviceButtonState) + WiimoteDeviceAccelerometerDataSize;
            irDataSize      = 12;
            break;

        case WiimoteDeviceReportTypeButtonAndIR10BytesAndExtension9BytesState:
            irDataOffset    = sizeof(WiimoteDeviceButtonState);
            irDataSize      = 10;
            break;

        case WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes:
            irDataOffset    = sizeof(WiimoteDeviceButtonState) + WiimoteDeviceAccelerometerDataSize;
            irDataSize      = 10;
            break;

        default:
            return;
    }

    if(m_ReportType != reportType)
    {
        [self enableHardware:[self irModeFromReportType:reportType]];
        m_ReportType    = reportType;
        m_ReportCounter = 0;
        return;
    }

    if((irDataOffset + irDataSize) > [report length])
        return;

    [self handleIRData:[report data] + irDataOffset
                length:irDataSize];
}

- (void)disconnected
{
    m_IsEnabled         = NO;
    m_IsHardwareEnabled = NO;
    m_ReportType        = -1;
    m_IRReportMode      = -1;

    NSUInteger pointCount = [m_Points count];

    for(NSUInteger i = 0; i < pointCount; i++)
    {
        WiimoteIRPoint *point = [m_Points objectAtIndex:i];

        [point setPosition:NSZeroPoint];
        [point setOutOfView:YES];
    }
}

@end

@implementation WiimoteIRPart (PrivatePart)

- (WiimoteDeviceIRMode)irModeFromReportType:(WiimoteDeviceReportType)reportType
{
    if(reportType == WiimoteDeviceReportTypeButtonAndAccelerometerAndIR12BytesState)
        return WiimoteDeviceIRModeExtended;

    return WiimoteDeviceIRModeBasic;
}

- (void)enableHardware:(WiimoteDeviceIRMode)irMode
{
    static const uint8_t sensitivityBlock1[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x90, 0x00, 0x41 };
    static const uint8_t sensitivityBlock2[] = { 0x40, 0x00 };

    if(m_IsHardwareEnabled)
    {
        if(m_IRReportMode == irMode)
            return;

        [self disableHardware];
    }

    uint8_t data = WiimoteDeviceCommandSetIREnabledStateFlagIREnabled;

    [[self ioManager] postCommand:WiimoteDeviceCommandTypeSetIREnabledState data:&data length:sizeof(data)];
    usleep(50000);

    [[self ioManager] postCommand:WiimoteDeviceCommandTypeSetIREnabledState2 data:&data length:sizeof(data)];
    usleep(50000);

    data = WiimoteDeviceIRBeginInitValue;
    [[self ioManager] writeMemory:WiimoteDeviceIRInitAddress data:&data length:sizeof(data)];
    usleep(50000);

    [[self ioManager] writeMemory:WiimoteDeviceIRSensitivityBlockAddress1 data:sensitivityBlock1 length:sizeof(sensitivityBlock1)];
    usleep(50000);

    [[self ioManager] writeMemory:WiimoteDeviceIRSensitivityBlockAddress2 data:sensitivityBlock2 length:sizeof(sensitivityBlock2)];
    usleep(50000);

    data = WiimoteDeviceIREndInitValue;
    [[self ioManager] writeMemory:WiimoteDeviceIRInitAddress data:&data length:sizeof(data)];
    usleep(50000);

    data = irMode;
    [[self ioManager] writeMemory:WiimoteDeviceIRModeAddress data:&data length:sizeof(data)];
    usleep(50000);

    m_IsHardwareEnabled = YES;
    m_IRReportMode      = irMode;
}

- (void)disableHardware
{
    if(!m_IsHardwareEnabled)
        return;

    uint8_t data = 0;

    [[self ioManager] postCommand:WiimoteDeviceCommandTypeSetIREnabledState data:&data length:sizeof(data)];
    usleep(50000);

    [[self ioManager] postCommand:WiimoteDeviceCommandTypeSetIREnabledState2 data:&data length:sizeof(data)];
    usleep(50000);

    m_IsHardwareEnabled = NO;
    m_ReportType        = -1;
    m_IRReportMode      = -1;
}

- (void)setPoint:(NSUInteger)index position:(NSPoint)newPosition
{
    WiimoteIRPoint *point = [m_Points objectAtIndex:index];

    if(![point isOutOfView] &&
        WiimoteDeviceIsPointEqualEx([point position], newPosition, 1.0))
    {
        return;
    }

    [point setPosition:newPosition];
    [point setOutOfView:NO];

    [[self eventDispatcher] postIRPointPositionChangedNotification:point];
}

- (void)setPointOutOfView:(NSUInteger)index
{
    WiimoteIRPoint *point = [m_Points objectAtIndex:index];

    if([point isOutOfView])
        return;

    [point setPosition:NSZeroPoint];
    [point setOutOfView:YES];

    [[self eventDispatcher] postIRPointPositionChangedNotification:point];
}

- (void)handle10ByteIRData:(const uint8_t*)data
{
    NSUInteger index = 0;

    for(NSUInteger i = 0; i < 2; i++)
    {
        uint16_t x = data[0];
        uint16_t y = data[1];

        x |= ((((uint16_t)data[2]) << 4) & 0x300);
        y |= ((((uint16_t)data[2]) << 2) & 0x300);

        if(x > 0x3FF || y > 0x3FF)
            [self setPointOutOfView:index];
        else
            [self setPoint:index position:NSMakePoint(x, y)];

        x = data[3];
        y = data[4];

        x |= ((((uint16_t)data[2]) << 8) & 0x300);
        y |= ((((uint16_t)data[2]) << 6) & 0x300);

        if(x > 0x3FF || y > 0x3FF)
            [self setPointOutOfView:index + 1];
        else
            [self setPoint:index + 1 position:NSMakePoint(x, y)];

        index   += 2;
        data    += 5;
    }
}

- (void)handle12ByteIRData:(const uint8_t*)data
{
    NSUInteger index = 0;

    if((m_ReportCounter % 2) == 1)
        index += 2;

    for(NSUInteger i = 0; i < 2; i++)
    {
        uint16_t x = data[0];
        uint16_t y = data[1];

        x |= ((((uint16_t)data[2]) << 4) & 0x300);
        y |= ((((uint16_t)data[2]) << 2) & 0x300);

        if(x > 0x3FF || y > 0x3FF)
            [self setPointOutOfView:index];
        else
            [self setPoint:index position:NSMakePoint(x, y)];

        index += 1;
        data  += 9;
    }

    m_ReportCounter++;
}

- (void)handleIRData:(const uint8_t*)data length:(NSUInteger)length
{
    if(length == 10)
        [self handle10ByteIRData:data];
    else
        [self handle12ByteIRData:data];
}

@end
