//
//  WiimoteNunchuck.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteNunchuck.h"
#import "WiimoteAccelerometer+PlugIn.h"
#import "Wiimote.h"

@interface WiimoteNunchuck (PrivatePart)

- (void)checkCalibrationData;
- (void)reset;

@end

@implementation WiimoteNunchuck

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteNunchuck class]];
}

+ (NSArray*)extensionSignatures
{
	static const uint8_t  signature[]	= { 0x00, 0x00, 0xA4, 0x20, 0x00, 0x00 };
	static const uint8_t  signature2[]	= { 0xFF, 0x00, 0xA4, 0x20, 0x00, 0x00 };

	static NSArray *result = nil;

	if(result == nil)
	{
		result = [[NSArray alloc] initWithObjects:
					[NSData dataWithBytes:signature  length:sizeof(signature)],
					[NSData dataWithBytes:signature2 length:sizeof(signature2)],
					nil];
	}

	return result;
}

+ (NSRange)calibrationDataMemoryRange
{
    return NSMakeRange(
				WiimoteDeviceRoutineExtensionCalibrationDataAddress,
                WiimoteDeviceRoutineExtensionCalibrationDataSize);
}

+ (WiimoteExtensionMeritClass)meritClass
{
    return WiimoteExtensionMeritClassSystem;
}

+ (NSUInteger)minReportDataSize
{
    return sizeof(WiimoteDeviceNunchuckReport);
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher];
    if(self == nil)
        return nil;

	m_IsCalibrationDataReaded	= NO;
    m_Accelerometer             = [[WiimoteAccelerometer alloc] init];

    [m_Accelerometer setDelegate:self];

    [self reset];
    return self;
}

- (void)dealloc
{
    [m_Accelerometer setDelegate:nil];
    [m_Accelerometer release];
    [super dealloc];
}

- (NSString*)name
{
    return @"Nunchuck";
}

- (NSPoint)stickPosition
{
    return m_StickPosition;
}

- (BOOL)isButtonPressed:(WiimoteNunchuckButtonType)button
{
    return m_ButtonState[button];
}

- (WiimoteAccelerometer*)accelerometer
{
    return [[m_Accelerometer retain] autorelease];
}

- (NSPoint)normalizeStickPosition:(NSPoint)position
{
    return position;
}

- (void)setStickPosition:(NSPoint)newPosition
{
    newPosition = [self normalizeStickPosition:newPosition];

    if(WiimoteDeviceIsPointEqual(m_StickPosition, newPosition))
        return;

	m_StickPosition = newPosition;

    [[self eventDispatcher] postNunchuck:self stickPositionChanged:newPosition];
}

- (void)setButton:(WiimoteNunchuckButtonType)button pressed:(BOOL)pressed
{
	if(m_ButtonState[button] == pressed)
		return;

	m_ButtonState[button] = pressed;

    if(pressed)
        [[self eventDispatcher] postNunchuck:self buttonPressed:button];
    else
        [[self eventDispatcher] postNunchuck:self buttonReleased:button];
}

- (BOOL)isSupportMotionPlus
{
    return YES;
}

- (WiimoteDeviceMotionPlusMode)motionPlusMode
{
    return WiimoteDeviceMotionPlusModeNunchuck;
}

- (void)handleCalibrationData:(const uint8_t*)data length:(NSUInteger)length
{
    if(length < sizeof(WiimoteDeviceNunchuckCalibrationData))
        return;

	const WiimoteDeviceNunchuckCalibrationData *calibrationData =
			(const WiimoteDeviceNunchuckCalibrationData*)data;

	m_StickCalibrationData = calibrationData->stick;
    [m_Accelerometer setCalibrationData:&(calibrationData->accelerometer)];
	[self checkCalibrationData];

	m_IsCalibrationDataReaded = YES;
}

- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length
{
    if(length < sizeof(WiimoteDeviceNunchuckReport))
        return;

    const WiimoteDeviceNunchuckReport *nunchuckReport =
                (const WiimoteDeviceNunchuckReport*)extensionData;

	if(m_IsCalibrationDataReaded)
	{
		NSPoint stickPostion;

		WiimoteDeviceNormalizeStick(
							nunchuckReport->stickX,
							nunchuckReport->stickY,
							m_StickCalibrationData,
							stickPostion);

		[self setStickPosition:stickPostion];

        if([m_Accelerometer isEnabled])
        {
            uint16_t x = (((uint16_t)nunchuckReport->accelerometerX) << 2) | ((nunchuckReport->acceleromererXYZAndButtonState >> 2) & 0x3);
            uint16_t y = (((uint16_t)nunchuckReport->accelerometerY) << 2) | ((nunchuckReport->acceleromererXYZAndButtonState >> 4) & 0x3);
            uint16_t z = (((uint16_t)nunchuckReport->accelerometerZ) << 2) | ((nunchuckReport->acceleromererXYZAndButtonState >> 6) & 0x3);

            [m_Accelerometer setHardwareValueX:x y:y z:z];
        }
	}

    [self setButton:WiimoteNunchuckButtonTypeZ
            pressed:((nunchuckReport->acceleromererXYZAndButtonState &
                                    WiimoteDeviceNunchuckReportButtonMaskZ) == 0)];

    [self setButton:WiimoteNunchuckButtonTypeC
            pressed:((nunchuckReport->acceleromererXYZAndButtonState &
                                    WiimoteDeviceNunchuckReportButtonMaskC) == 0)];
}

- (void)handleMotionPlusReport:(const uint8_t*)extensionData
                        length:(NSUInteger)length
{
    if(length < sizeof(WiimoteDeviceNunchuckReport))
        return;

    uint8_t data[sizeof(WiimoteDeviceNunchuckReport)];

    // transform to standart nunchuck report
    memcpy(data, extensionData, sizeof(data));
    data[4] &= 0xFE;
    data[4] |= ((extensionData[5] >> 7) & 0x1);
    data[5] =
        ((extensionData[5] & 0x40) << 1) |
        ((extensionData[5] & 0x20) >> 0) |
        ((extensionData[5] & 0x10) >> 1) |
        ((extensionData[5] & 0x0C) >> 2);

    [self handleReport:data length:sizeof(data)];
}

@end

@implementation WiimoteNunchuck (PrivatePart)

- (void)checkCalibrationData
{
    WiimoteDeviceCheckStickCalibration(m_StickCalibrationData, 0, 127, 255);

    if([m_Accelerometer isHardwareZeroValuesInvalid])
		[m_Accelerometer setHardwareZeroX:500 y:500 z:500];

	if([m_Accelerometer isHardware1gValuesInvalid])
		[m_Accelerometer setHardware1gX:700 y:700 z:700];
}

- (void)reset
{
	m_ButtonState[WiimoteNunchuckButtonTypeC]   = NO;
	m_ButtonState[WiimoteNunchuckButtonTypeZ]   = NO;
	m_StickPosition                             = NSZeroPoint;

	[m_Accelerometer reset];
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

    [[self eventDispatcher] postNunchuck:self accelerometerEnabledStateChanged:enabled];
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
             gravityChangedX:(CGFloat)x
                           y:(CGFloat)y
                           z:(CGFloat)z
{
    [[self eventDispatcher] postNunchuck:self accelerometerChangedGravityX:x y:y z:z];
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
                pitchChanged:(CGFloat)pitch
                        roll:(CGFloat)roll
{
    [[self eventDispatcher] postNunchuck:self accelerometerChangedPitch:pitch roll:roll];
}

@end
