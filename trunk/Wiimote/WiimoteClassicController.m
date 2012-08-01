//
//  WiimoteClassicController.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteClassicController.h"

@interface WiimoteClassicController (PrivatePart)

- (void)reset;

@end

@implementation WiimoteClassicController

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteClassicController class]];
}

+ (NSData*)extensionSignature
{
    static const uint8_t  signature[]   = { 0x00, 0x00, 0xA4, 0x20, 0x01, 0x01 };
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
    return @"Classic Controller";
}

- (NSPoint)stickPosition:(WiimoteClassicControllerStickType)stick
{
    return m_StickPositions[stick];
}

- (BOOL)isButtonPressed:(WiimoteClassicControllerButtonType)button
{
    return m_ButtonState[button];
}

- (float)analogShiftPosition:(WiimoteClassicControllerAnalogShiftType)shift
{
    return m_AnalogShiftPositions[shift];
}

- (void)setStick:(WiimoteClassicControllerStickType)stick position:(NSPoint)newPosition
{
    if(WiimoteDeviceIsPointEqual(m_StickPositions[stick], newPosition))
        return;

    m_StickPositions[stick] = newPosition;

    [[self eventDispatcher]
                postClassicController:self
                                stick:stick
                      positionChanged:newPosition];
}

- (void)setButton:(WiimoteClassicControllerButtonType)button pressed:(BOOL)pressed
{
    if(m_ButtonState[button] == pressed)
        return;

    m_ButtonState[button] = pressed;

    if(pressed)
    {
        [[self eventDispatcher]
                    postClassicController:self
                            buttonPressed:button];
    }
    else
    {
        [[self eventDispatcher]
                    postClassicController:self
                           buttonReleased:button];
    }
}

- (void)setAnalogShift:(WiimoteClassicControllerAnalogShiftType)shift position:(float)newPosition
{
    if(WiimoteDeviceIsFloatEqual(m_AnalogShiftPositions[shift], newPosition))
        return;

    m_AnalogShiftPositions[shift] = newPosition;

    [[self eventDispatcher]
                postClassicController:self
                          analogShift:shift
                      positionChanged:newPosition];
}

- (void)handleCalibrationData:(NSData*)data
{
    // TODO: add support for calibration
}

- (void)handleButtonState:(WiimoteDeviceClassicControllerButtonState)state
{
    [self setButton:WiimoteClassicControllerButtonTypeA
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskA) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeB
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskB) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeMinus
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskMinus) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeHome
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskHome) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypePlus
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskPlus) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeX
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskX) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeY
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskY) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeUp
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskUp) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeDown
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskDown) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeLeft
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskLeft) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeRight
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskRight) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeL
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskL) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeR
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskR) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeZL
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskZL) == 0)];

    [self setButton:WiimoteClassicControllerButtonTypeZR
            pressed:((state & WiimoteDeviceClassicControllerReportButtonMaskZR) == 0)];
}

- (void)handleAnalogData:(const uint8_t*)analogData
{
    // TODO: remove all magic constants ;)

    uint8_t leftStickX  = (analogData[0] >> 0) & 0x3F;
    uint8_t leftStickY  = (analogData[1] >> 0) & 0x3F;

    uint8_t rightStickX = (analogData[2] >> 7) & 0x01;
    uint8_t rightStickY = (analogData[2] >> 0) & 0x1F;

    uint8_t leftShift   = (analogData[3] >> 5) & 0x07;
    uint8_t rightShift  = (analogData[3] >> 0) & 0x1F;

    leftShift   |= ((analogData[2] & 0x60) >> 2);
    rightStickX |= ((analogData[1] & 0xC0) >> 5);
    rightStickX |= ((analogData[0] & 0xC0) >> 3);

    NSPoint stickPosition;

    WiimoteDeviceNormalizeStickCoordinateEx(leftStickX, 0, 31, 63, stickPosition.x);
    WiimoteDeviceNormalizeStickCoordinateEx(leftStickY, 0, 31, 63, stickPosition.y);
	leftStickY = -leftStickY;
    [self setStick:WiimoteClassicControllerStickTypeLeft position:stickPosition];

    WiimoteDeviceNormalizeStickCoordinateEx(rightStickX, 0, 15, 31, stickPosition.x);
    WiimoteDeviceNormalizeStickCoordinateEx(rightStickY, 0, 15, 31, stickPosition.y);
	rightStickY = -rightStickY;
    [self setStick:WiimoteClassicControllerStickTypeRight position:stickPosition];

    float analogShiftPosition;

    WiimoteDeviceNormalizeStickCoordinateEx(leftShift, 0, 15, 31, analogShiftPosition);
	analogShiftPosition = (analogShiftPosition + 1.0f) * 0.5f;
    [self setAnalogShift:WiimoteClassicControllerAnalogShiftTypeLeft position:analogShiftPosition];

    WiimoteDeviceNormalizeStickCoordinateEx(rightShift, 0, 15, 31, analogShiftPosition);
	analogShiftPosition = (analogShiftPosition + 1.0f) * 0.5f;
    [self setAnalogShift:WiimoteClassicControllerAnalogShiftTypeRight position:analogShiftPosition];
}

- (void)handleReport:(NSData*)extensionData
{
    if([extensionData length] < sizeof(WiimoteDeviceClassicControllerReport))
        return;

    const WiimoteDeviceClassicControllerReport *classicReport =
                (const WiimoteDeviceClassicControllerReport*)[extensionData bytes];

    WiimoteDeviceClassicControllerButtonState state = OSSwapBigToHostConstInt16(classicReport->buttonState);

    [self handleButtonState:state];
    [self handleAnalogData:classicReport->analogData];
}

@end

@implementation WiimoteClassicController (PrivatePart)

- (void)reset
{
    for(NSUInteger i = 0; i < WiimoteClassicControllerButtonCount; i++)
        m_ButtonState[i] = NO;

    for(NSUInteger i = 0; i < WiimoteClassicControllerStickCount; i++)
        m_StickPositions[i] = NSZeroPoint;

    for(NSUInteger i = 0; i < WiimoteClassicControllerAnalogShiftCount; i++)
        m_AnalogShiftPositions[i] = 0.0f;
}

@end
