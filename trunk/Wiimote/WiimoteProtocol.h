//
//  WiimoteProtocol.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

// WARNING!!! Wiimote use big-endian data format!!!

#pragma push(pack)
#pragma pack(1)

typedef enum
{
    WiimoteDevicePacketTypeCommand                  = 0xA2,
    WiimoteDevicePacketTypeReport                   = 0xA1
} WiimoteDevicePacketType;

typedef enum
{
    WiimoteDeviceCommandTypeSetLEDState             = 0x11,
    WiimoteDeviceCommandTypeSetReportType           = 0x12,
    WiimoteDeviceCommandTypeGetState				= 0x15,
	WiimoteDeviceCommandTypeWriteMemory				= 0x16,
	WiimoteDeviceCommandTypeReadMemory				= 0x17
} WiimoteDeviceCommandType;

typedef enum
{
    WiimoteDeviceCommandFlagVibrationEnabled        = 0x01
} WiimoteDeviceCommandFlag;

typedef enum
{
    WiimoteDeviceSetReportTypeCommandFlagPeriodic   = 0x04,
} WiimoteDeviceSetReportTypeCommandFlag;

typedef enum
{
    WiimoteDeviceSetLEDStateCommandFlagLEDOne       = 0x10,
    WiimoteDeviceSetLEDStateCommandFlagLEDTwo       = 0x20,
    WiimoteDeviceSetLEDStateCommandFlagLEDThree     = 0x40,
    WiimoteDeviceSetLEDStateCommandFlagLEDFour      = 0x80
} WiimoteDeviceSetLEDStateCommandFlag;

typedef enum
{
    WiimoteDeviceReportTypeState                                                    = 0x20,
	WiimoteDeviceReportTypeReadMemory                                               = 0x21,
	WiimoteDeviceReportTypeAcknowledge                                              = 0x22,
    WiimoteDeviceReportTypeButtonState                                              = 0x30,
    WiimoteDeviceReportTypeButtonAndAccelerometerState                              = 0x31,
	WiimoteDeviceReportTypeButtonAndExtension8BytesState                            = 0x32,
    WiimoteDeviceReportTypeButtonAndAccelerometerAndIR12BytesState                  = 0x33,
    WiimoteDeviceReportTypeButtonAndExtension19BytesState                           = 0x34,
    WiimoteDeviceReportTypeButtonAndAccelerometerAndExtension16BytesState           = 0x35,
    WiimoteDeviceReportTypeButtonAndIR10BytesAndExtension9BytesState                = 0x36,
    WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes     = 0x37
} WiimoteDeviceReportType;

typedef struct {
    uint8_t packetType;
    uint8_t commandType;
} WiimoteDeviceCommandHeader;

#define WiimoteDeviceWriteMemoryReportMaxDataSize 16

typedef struct {
    uint32_t address;
    uint8_t  length;
    uint8_t  data[WiimoteDeviceWriteMemoryReportMaxDataSize];
} WiimoteDeviceWriteMemoryParams;

typedef struct
{
    uint32_t address;
    uint16_t length;
} WiimoteDeviceReadMemoryParams;

typedef struct
{
    uint8_t flags;
    uint8_t reportType;
} WiimoteDeviceSetReportTypeParams;

typedef struct {
    uint8_t packetType;
    uint8_t reportType;
} WiimoteDeviceReportHeader;

typedef uint16_t WiimoteDeviceButtonState;

typedef enum
{
    WiimoteDeviceButtonStateFlagTwo                 = 0x0001,
    WiimoteDeviceButtonStateFlagOne                 = 0x0002,
    WiimoteDeviceButtonStateFlagB                   = 0x0004,
    WiimoteDeviceButtonStateFlagA                   = 0x0008,
    WiimoteDeviceButtonStateFlagMinus               = 0x0010,
	WiimoteDeviceButtonStateFlagHome                = 0x0080,

	WiimoteDeviceButtonStateFlagLeft                = 0x0100,
    WiimoteDeviceButtonStateFlagRight               = 0x0200,
    WiimoteDeviceButtonStateFlagDown                = 0x0400,
    WiimoteDeviceButtonStateFlagUp                  = 0x0800,
    WiimoteDeviceButtonStateFlagPlus                = 0x1000
} WiimoteDeviceButtonStateFlag;

#define WiimoteDeviceReadMemoryReportErrorMask          0x0F
#define WiimoteDeviceReadMemoryReportDataSizeMask       0xF0
#define WiimoteDeviceReadMemoryReportErrorOffset        0
#define WiimoteDeviceReadMemoryReportDataSizeOffset     4
#define WiimoteDeviceReadMemoryReportMaxDataSize        16
#define WiimoteDeviceReadMemoryReportErrorOk            0

typedef struct
{
    WiimoteDeviceButtonState buttonState;
    uint8_t                  errorAndDataSize;
    uint16_t                 dataOffset;
    uint8_t                  data[WiimoteDeviceReadMemoryReportMaxDataSize];
} WiimoteDeviceReadMemoryReport;

#define WiimoteDeviceMaxBatteryLevel 0xC0

typedef enum
{
    WiimoteDeviceStateReportFlagBatteryIsLow		= 0x01,
    WiimoteDeviceStateReportFlagExtensionConnected	= 0x02,
    WiimoteDeviceStateReportFlagSpeakerEnabled		= 0x04,
    WiimoteDeviceStateReportFlagIRCameraEnabled     = 0x08
} WiimoteDeviceStateReportFlag;

typedef struct
{
    WiimoteDeviceButtonState buttonState;
    uint8_t                  flagsAndLEDState;
    uint16_t                 reserved;
    uint8_t                  batteryLevel;
} WiimoteDeviceStateReport;

#define WiimoteDeviceRoutineProbeAddress            0x04A400FA
#define WiimoteDeviceRoutineCalibrationDataAddress  0x04A40020
#define WiimoteDeviceRoutineCalibrationDataSize     16
#define WiimoteDeviceRoutineInitAddress1            0x04A400F0
#define WiimoteDeviceRoutineInitAddress2            0x04A400FB
#define WiimoteDeviceRoutineInitValue1              0x55
#define WiimoteDeviceRoutineInitValue2              0x00

#define WiimoteDeviceAccelerometerDataSize          3

typedef struct
{
    uint8_t x;
    uint8_t y;
    uint8_t z;
    uint8_t unknown;
} WiimoteDeviceAccelerometerValue;

typedef struct
{
    WiimoteDeviceAccelerometerValue zero;
    WiimoteDeviceAccelerometerValue oneG;
} WiimoteDeviceAccelerometerCalibrationData;

typedef struct
{
    uint8_t max;
    uint8_t min;
    uint8_t center;
} WiimoteDeviceStickCoordinateCalibrationData;

typedef struct
{
    WiimoteDeviceStickCoordinateCalibrationData x;
    WiimoteDeviceStickCoordinateCalibrationData y;
} WiimoteDeviceStickCalibrationData;

typedef struct
{
    WiimoteDeviceAccelerometerCalibrationData   accelerometer;
    WiimoteDeviceStickCalibrationData           stick;
} WiimoteDeviceNunchuckCalibrationData;

typedef struct
{
    WiimoteDeviceStickCalibrationData leftStick;
    WiimoteDeviceStickCalibrationData rightStick;
} WiimoteDeviceClassicControllerCalibrationData;

typedef struct
{
    uint8_t stickX;
    uint8_t stickY;
    uint8_t accelerometerX;
    uint8_t accelerometerY;
    uint8_t accelerometerZ;
    uint8_t acceleromererXYZAndButtonState;
} WiimoteDeviceNunchuckReport;

typedef enum
{
	WiimoteDeviceNunchuckReportButtonMaskC          = 0x2,
	WiimoteDeviceNunchuckReportButtonMaskZ          = 0x1
} WiimoteDeviceNunchuckReportButtonMask;

#define WiimoteDeviceClassicControllerAnalogDataSize 4

typedef uint16_t WiimoteDeviceClassicControllerButtonState;

typedef struct
{
    uint8_t                                     analogData[WiimoteDeviceClassicControllerAnalogDataSize];
    WiimoteDeviceClassicControllerButtonState   buttonState;
} WiimoteDeviceClassicControllerReport;

typedef enum
{
	WiimoteDeviceClassicControllerReportButtonMaskUp    = 0x0001,
    WiimoteDeviceClassicControllerReportButtonMaskLeft  = 0x0002,
    WiimoteDeviceClassicControllerReportButtonMaskZR    = 0x0004,
    WiimoteDeviceClassicControllerReportButtonMaskX     = 0x0008,
    WiimoteDeviceClassicControllerReportButtonMaskA     = 0x0010,
    WiimoteDeviceClassicControllerReportButtonMaskY     = 0x0020,
    WiimoteDeviceClassicControllerReportButtonMaskB     = 0x0040,
    WiimoteDeviceClassicControllerReportButtonMaskZL    = 0x0080,
    WiimoteDeviceClassicControllerReportButtonMaskR     = 0x0200,
    WiimoteDeviceClassicControllerReportButtonMaskPlus  = 0x0400,
    WiimoteDeviceClassicControllerReportButtonMaskHome  = 0x0800,
    WiimoteDeviceClassicControllerReportButtonMaskMinus = 0x1000,
    WiimoteDeviceClassicControllerReportButtonMaskL     = 0x2000,
    WiimoteDeviceClassicControllerReportButtonMaskDown  = 0x4000,
    WiimoteDeviceClassicControllerReportButtonMaskRight = 0x8000
} WiimoteDeviceClassicControllerReportButtonMask;

#define WiimoteDeviceFloatEpsilon       0.075f
#define WiimoteDeviceIsFloatEqual(a, b) (fabs(((a) - (b))) <= WiimoteDeviceFloatEpsilon)
#define WiimoteDeviceIsPointEqual(a, b) (WiimoteDeviceIsFloatEqual((a).x, (b).x) && \
                                         WiimoteDeviceIsFloatEqual((a).y, (b).y))

#define WiimoteDeviceCheckStickCalibration(stickCalibration, minValue, centerValue, maxValue) \
            { \
                if((stickCalibration).x.center == 0) \
                    (stickCalibration).x.center = (centerValue); \
            \
                if((stickCalibration).y.center == 0) \
                    (stickCalibration).y.center = (centerValue); \
            \
                if((stickCalibration).x.max == 0) \
                    (stickCalibration).x.max = (maxValue); \
            \
                if((stickCalibration).y.max == 0) \
                    (stickCalibration).y.max = (maxValue); \
            }

#define WiimoteDeviceNormalizeStickCoordinateEx(value, min, center, max, result) \
            { \
                float wiimote_device_norm_value_; \
            \
                if((value) <= (center)) \
                { \
                    wiimote_device_norm_value_ = ((float)(value) - (float)(min)) / \
                                                 ((float)(center) - (float)(min)) - 1.0f; \
                } \
                else \
                { \
                    wiimote_device_norm_value_ = ((float)(value) - (float)(center)) / \
                                                 ((float)(max) - (float)(center)); \
                } \
            \
                if(wiimote_device_norm_value_ < -1.0f) \
                    wiimote_device_norm_value_ = -1.0f; \
            \
                if(wiimote_device_norm_value_ > 1.0f) \
                    wiimote_device_norm_value_ = 1.0f; \
            \
                result = wiimote_device_norm_value_; \
            }

#define WiimoteDeviceNormalizeStickCoordinate(value, result) \
                WiimoteDeviceNormalizeStickCoordinateEx((value), 0, 127, 255, (result))

#define WiimoteDeviceNormalizeStick(pointX, pointY, stickCalibrationData, resultPoint) \
            { \
                WiimoteDeviceNormalizeStickCoordinateEx( \
                                                (pointX), \
                                                (stickCalibrationData).x.min, \
                                                (stickCalibrationData).x.center, \
                                                (stickCalibrationData).x.max, \
                                                (resultPoint).x); \
            \
                WiimoteDeviceNormalizeStickCoordinateEx( \
                                                (pointY), \
                                                (stickCalibrationData).y.min, \
                                                (stickCalibrationData).y.center, \
                                                (stickCalibrationData).y.max, \
                                                (resultPoint).y); \
            }

#define WiimoteDeviceNormilizeShift(shiftValue, min, center, max, result) \
            WiimoteDeviceNormalizeStickCoordinateEx((shiftValue), (min), (center), (max), (result)); \
            (result) = ((result) + 1.0f) * 0.5f

#pragma pop(pack)
