//
//  WiimoteClassicController.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteClassicController.h"

@interface WiimoteClassicController (PrivatePart)

- (void)checkCalibrationData;
- (void)reset;

@end

@implementation WiimoteClassicController

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteClassicController class]];
}

+ (NSArray*)extensionSignatures
{
    static const uint8_t  signature1[]  = { 0x00, 0x00, 0xA4, 0x20, 0x01, 0x01 };
    static const uint8_t  signature2[]  = { 0x01, 0x00, 0xA4, 0x20, 0x01, 0x01 }; // Pro
    static NSArray       *result        = nil;

    if(result == nil)
    {
        result = [[NSArray alloc] initWithObjects:
                    [NSData dataWithBytes:signature1 length:sizeof(signature1)],
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
    return sizeof(WiimoteDeviceClassicControllerReport);
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher];
    if(self == nil)
        return nil;

    m_IsCalibrationDataReaded = NO;

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

- (NSPoint)normalizeStick:(WiimoteClassicControllerStickType)stick position:(NSPoint)position
{
    return position;
}

- (float)normalizeAnalogShift:(WiimoteClassicControllerAnalogShiftType)shift position:(float)position
{
    return position;
}

- (void)setStick:(WiimoteClassicControllerStickType)stick position:(NSPoint)newPosition
{
    newPosition = [self normalizeStick:stick position:newPosition];

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
    newPosition = [self normalizeAnalogShift:shift position:newPosition];

    if(WiimoteDeviceIsFloatEqual(m_AnalogShiftPositions[shift], newPosition))
        return;

    m_AnalogShiftPositions[shift] = newPosition;

    [[self eventDispatcher]
                postClassicController:self
                          analogShift:shift
                      positionChanged:newPosition];
}

- (BOOL)isSupportMotionPlus
{
    return YES;
}

- (void)handleCalibrationData:(const uint8_t*)data length:(NSUInteger)length
{
    if(length < sizeof(m_CalibrationData))
        return;

    memcpy(&m_CalibrationData, data, sizeof(m_CalibrationData));

    m_CalibrationData.leftStick.x.max       /= 4;
    m_CalibrationData.leftStick.x.min       /= 4;
    m_CalibrationData.leftStick.x.center    /= 4;
    m_CalibrationData.leftStick.y.max       /= 4;
    m_CalibrationData.leftStick.y.min       /= 4;
    m_CalibrationData.leftStick.y.center    /= 4;

    m_CalibrationData.rightStick.x.max      /= 8;
    m_CalibrationData.rightStick.x.min      /= 8;
    m_CalibrationData.rightStick.x.center   /= 8;
    m_CalibrationData.rightStick.y.max      /= 8;
    m_CalibrationData.rightStick.y.min      /= 8;
    m_CalibrationData.rightStick.y.center   /= 8;

    [self checkCalibrationData];
    m_IsCalibrationDataReaded = YES;
}

- (void)handleButtonState:(WiimoteDeviceClassicControllerButtonState)state
{
    static const struct
    {
        WiimoteClassicControllerButtonType              type;
        WiimoteDeviceClassicControllerReportButtonMask  mask;
    } buttonMasks[] = {
        { WiimoteClassicControllerButtonTypeA,      WiimoteDeviceClassicControllerReportButtonMaskA     },
        { WiimoteClassicControllerButtonTypeB,      WiimoteDeviceClassicControllerReportButtonMaskB     },
        { WiimoteClassicControllerButtonTypeMinus,  WiimoteDeviceClassicControllerReportButtonMaskMinus },
        { WiimoteClassicControllerButtonTypeHome,   WiimoteDeviceClassicControllerReportButtonMaskHome  },
        { WiimoteClassicControllerButtonTypePlus,   WiimoteDeviceClassicControllerReportButtonMaskPlus  },
        { WiimoteClassicControllerButtonTypeX,      WiimoteDeviceClassicControllerReportButtonMaskX     },
        { WiimoteClassicControllerButtonTypeY,      WiimoteDeviceClassicControllerReportButtonMaskY     },
        { WiimoteClassicControllerButtonTypeUp,     WiimoteDeviceClassicControllerReportButtonMaskUp    },
        { WiimoteClassicControllerButtonTypeDown,   WiimoteDeviceClassicControllerReportButtonMaskDown  },
        { WiimoteClassicControllerButtonTypeLeft,   WiimoteDeviceClassicControllerReportButtonMaskLeft  },
        { WiimoteClassicControllerButtonTypeRight,  WiimoteDeviceClassicControllerReportButtonMaskRight },
        { WiimoteClassicControllerButtonTypeL,      WiimoteDeviceClassicControllerReportButtonMaskL     },
        { WiimoteClassicControllerButtonTypeR,      WiimoteDeviceClassicControllerReportButtonMaskR     },
        { WiimoteClassicControllerButtonTypeZL,     WiimoteDeviceClassicControllerReportButtonMaskZL    },
        { WiimoteClassicControllerButtonTypeZR,     WiimoteDeviceClassicControllerReportButtonMaskZR    }
    };

    for(NSUInteger i = 0; i < WiimoteClassicControllerButtonCount; i++)
        [self setButton:buttonMasks[i].type pressed:((state & buttonMasks[i].mask) == 0)];
}

- (void)handleAnalogData:(const uint8_t*)analogData
{
    if(!m_IsCalibrationDataReaded)
        return;

	uint8_t leftStickY  = ((analogData[1] >> 0) & 0x3F);
	uint8_t leftStickX  = ((analogData[0] >> 0) & 0x3F);

	uint8_t rightStickY = ((analogData[2] >> 0) & 0x1F);
    uint8_t rightStickX = ((analogData[2] >> 7) & 0x01) |
						  ((analogData[1] & 0xC0) >> 5) |
						  ((analogData[0] & 0xC0) >> 3);

	uint8_t rightShift  = ((analogData[3] >> 0) & 0x1F);
    uint8_t leftShift   = ((analogData[3] >> 5) & 0x07) |
						  ((analogData[2] & 0x60) >> 2);

    NSPoint stickPosition;
    float   analogShiftPosition;

    WiimoteDeviceNormalizeStick(leftStickX, leftStickY, m_CalibrationData.leftStick, stickPosition);
    [self setStick:WiimoteClassicControllerStickTypeLeft position:stickPosition];

    WiimoteDeviceNormalizeStick(rightStickX, rightStickY, m_CalibrationData.rightStick, stickPosition);
    [self setStick:WiimoteClassicControllerStickTypeRight position:stickPosition];

    WiimoteDeviceNormilizeShift(leftShift, 0, 15, 31, analogShiftPosition);
    [self setAnalogShift:WiimoteClassicControllerAnalogShiftTypeLeft position:analogShiftPosition];

    WiimoteDeviceNormilizeShift(rightShift, 0, 15, 31, analogShiftPosition);
    [self setAnalogShift:WiimoteClassicControllerAnalogShiftTypeRight position:analogShiftPosition];
}

- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length
{
    if(length < sizeof(WiimoteDeviceClassicControllerReport))
        return;

    const WiimoteDeviceClassicControllerReport *classicReport =
                (const WiimoteDeviceClassicControllerReport*)extensionData;

    WiimoteDeviceClassicControllerButtonState state = OSSwapBigToHostConstInt16(classicReport->buttonState);

    [self handleButtonState:state];
    [self handleAnalogData:classicReport->analogData];
}

- (void)handleMotionPlusReport:(const uint8_t*)extensionData
                        length:(NSUInteger)length
{
    if(length < sizeof(WiimoteDeviceClassicControllerReport))
        return;

    uint8_t data[sizeof(WiimoteDeviceClassicControllerReport)];

    // transform to standart classic controller report
    memcpy(data, extensionData, sizeof(data));
    data[5] &= 0xFC;
    data[5] |= ((data[0] & 0x1) << 0);
    data[5] |= ((data[1] & 0x1) << 1);
    data[0] &= 0xFE;
    data[1] &= 0xFE;
    data[4] &= 0xFE;

    [self handleReport:data length:sizeof(data)];
}

@end

@implementation WiimoteClassicController (PrivatePart)

- (void)checkCalibrationData
{
    WiimoteDeviceCheckStickCalibration(m_CalibrationData.leftStick,  0, 31, 63);
    WiimoteDeviceCheckStickCalibration(m_CalibrationData.rightStick, 0, 15, 31);
}

- (void)reset
{
    for(NSUInteger i = 0; i < WiimoteClassicControllerButtonCount; i++)
        m_ButtonState[i] = NO;

    for(NSUInteger i = 0; i < WiimoteClassicControllerStickCount; i++)
        m_StickPositions[i] = NSZeroPoint;

    for(NSUInteger i = 0; i < WiimoteClassicControllerAnalogShiftCount; i++)
        m_AnalogShiftPositions[i] = 0.0f;

    memset(&m_CalibrationData, 0, sizeof(m_CalibrationData));
    [self checkCalibrationData];
}

@end
