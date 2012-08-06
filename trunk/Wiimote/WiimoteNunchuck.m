//
//  WiimoteNunchuck.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteNunchuck.h"
#import "WiimoteAccelerometer+PlugIn.h"

@interface WiimoteNunchuck (PrivatePart)

- (void)reset;

@end

@implementation WiimoteNunchuck

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteNunchuck class]];
}

+ (NSData*)extensionSignature
{
    static const uint8_t  signature[]   = { 0x00, 0x00, 0xA4, 0x20, 0x00, 0x00 };
    static NSData        *result        = nil;

    if(result == nil)
        result = [[NSData alloc] initWithBytes:signature length:sizeof(signature)];

    return result;
}

+ (NSRange)calibrationDataMemoryRange
{
    return NSMakeRange(
                WiimoteDeviceRoutineCalibrationDataAddress,
                WiimoteDeviceRoutineCalibrationDataSize);
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

- (void)setStickPosition:(NSPoint)newPosition
{
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

- (void)handleCalibrationData:(NSData*)data
{
    if([data length] < sizeof(WiimoteDeviceNunchuckCalibrationData))
        return;

	const WiimoteDeviceNunchuckCalibrationData *calibrationData =
			(const WiimoteDeviceNunchuckCalibrationData*)[data bytes];

	m_StickCalibrationData = calibrationData->stick;
    WiimoteDeviceCheckStickCalibration(m_StickCalibrationData, 0, 127, 255);

    [m_Accelerometer setCalibrationData:&(calibrationData->accelerometer)];
	m_IsCalibrationDataReaded = YES;
}

- (void)handleReport:(NSData*)extensionData
{
    if([extensionData length] < sizeof(WiimoteDeviceNunchuckReport))
        return;

    const WiimoteDeviceNunchuckReport *nunchuckReport =
                (const WiimoteDeviceNunchuckReport*)([extensionData bytes]);

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

@end

@implementation WiimoteNunchuck (PrivatePart)

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
    [[self eventDispatcher] postNunchuck:self accelerometerEnabledStateChanged:enabled];
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
             gravityChangedX:(double)x
                           y:(double)y
                           z:(double)z
{
    [[self eventDispatcher] postNunchuck:self accelerometerChangedGravityX:x y:y z:z];
}

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
                pitchChanged:(double)pitch
                        roll:(double)roll
{
    [[self eventDispatcher] postNunchuck:self accelerometerChangedPitch:pitch roll:roll];
}

@end
