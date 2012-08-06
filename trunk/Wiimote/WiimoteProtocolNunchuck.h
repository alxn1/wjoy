//
//  WiimoteProtocolNunchuck.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

typedef enum
{
	WiimoteDeviceNunchuckReportButtonMaskC  = 0x2,
	WiimoteDeviceNunchuckReportButtonMaskZ  = 0x1
} WiimoteDeviceNunchuckReportButtonMask;

typedef struct
{
    uint8_t stickX;
    uint8_t stickY;
    uint8_t accelerometerX;
    uint8_t accelerometerY;
    uint8_t accelerometerZ;
    uint8_t acceleromererXYZAndButtonState;
} WiimoteDeviceNunchuckReport;

typedef struct
{
    WiimoteDeviceAccelerometerCalibrationData   accelerometer;
    WiimoteDeviceStickCalibrationData           stick;
} WiimoteDeviceNunchuckCalibrationData;
