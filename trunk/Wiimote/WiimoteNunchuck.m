//
//  WiimoteNunchuck.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteNunchuck.h"

@interface WiimoteNunchuck (PrivatePart)

- (void)reset;
- (void)checkCalibrationData;

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

    [self reset];
    return self;
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
    if([data length] < sizeof(m_CalibrationData))
        return;

    memcpy(&m_CalibrationData, [data bytes], sizeof(m_CalibrationData));
    [self checkCalibrationData];
}

- (void)handleReport:(NSData*)extensionData
{
    if([extensionData length] < sizeof(WiimoteDeviceNunchuckReport))
        return;

    const WiimoteDeviceNunchuckReport *nunchuckReport =
                (const WiimoteDeviceNunchuckReport*)([extensionData bytes]);

    NSPoint stickPostion;

    WiimoteDeviceNormalizeStick(
                        nunchuckReport->stickX,
                        nunchuckReport->stickY,
                        m_CalibrationData.stick,
                        stickPostion);

    [self setStickPosition:stickPostion];

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
	m_ButtonState[WiimoteNunchuckButtonTypeC]       = NO;
	m_ButtonState[WiimoteNunchuckButtonTypeZ]       = NO;
	m_StickPosition                                 = NSZeroPoint;

    memset(&m_CalibrationData, 0, sizeof(m_CalibrationData));
    [self checkCalibrationData];
}

- (void)checkCalibrationData
{
    // TODO: add accelerometer default values

    WiimoteDeviceCheckStickCalibration(m_CalibrationData.stick, 0, 127, 255);
}

@end
