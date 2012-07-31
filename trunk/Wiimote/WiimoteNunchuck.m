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

- (float)calcStickPosition:(float)value
					   min:(float)min
					   max:(float)max
					center:(float)center;

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
    // TODO: add support for calibration
    return NSMakeRange(0, 0);
}

+ (WiimoteExtensionMeritClass)meritClass
{
    return WiimoteExtensionMeritClassSystem;
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
	if(fabs(m_StickPosition.x - newPosition.x) < 0.01 &&
	   fabs(m_StickPosition.y - newPosition.y) < 0.01)
	{
		return;
	}

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
    // TODO: add support for calibration
}

- (void)handleReport:(NSData*)extensionData
{
    if([extensionData length] < sizeof(WiimoteDeviceNunchuckReport))
        return;

    const WiimoteDeviceNunchuckReport *nunchuckReport =
                (const WiimoteDeviceNunchuckReport*)([extensionData bytes]);

    NSPoint stickPostion;

    stickPostion.x = [self calcStickPosition:nunchuckReport->stickX min:m_StickMinX max:m_StickMaxX center:m_StickCenterX];
    stickPostion.y = [self calcStickPosition:nunchuckReport->stickY min:m_StickMinY max:m_StickMaxY center:m_StickCenterY];

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
	m_ButtonState[WiimoteNunchuckButtonTypeC]	= NO;
	m_ButtonState[WiimoteNunchuckButtonTypeZ]	= NO;

	m_StickMinX									= 0;
	m_StickCenterX								= 0x7F;
	m_StickMaxX									= 0xFF;

	m_StickMinY									= 0;
	m_StickCenterY								= 0x7F;
	m_StickMaxY									= 0xFF;

	m_StickPosition								= NSZeroPoint;
}

- (float)calcStickPosition:(float)value
					   min:(float)min
					   max:(float)max
					center:(float)center
{
	float result = 0.0f;

	if(value <= center)
		result = ((value - min) / (center - min)) - 1.0f;
	else
		result = ((value - center) / (max - center));

	if(result < -1.0f)
		result = -1.0f;

	if(result > 1.0f)
		result = 1.0f;

	return result;
}

@end
