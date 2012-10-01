//
//  WiimoteProtocolClassicController.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#define WiimoteDeviceClassicControllerAnalogDataSize      4

typedef uint16_t WiimoteDeviceClassicControllerButtonState;

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

typedef struct
{
    WiimoteDeviceStickCalibrationData leftStick;
    WiimoteDeviceStickCalibrationData rightStick;
} WiimoteDeviceClassicControllerCalibrationData;

typedef struct
{
    uint8_t                                     analogData[WiimoteDeviceClassicControllerAnalogDataSize];
    WiimoteDeviceClassicControllerButtonState   buttonState;
} WiimoteDeviceClassicControllerReport;
