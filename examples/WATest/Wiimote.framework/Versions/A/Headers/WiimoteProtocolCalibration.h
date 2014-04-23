
//
//  WiimoteProtocolCalibration.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#define WiimoteDeviceCalibrationDataAddress 0x0020

typedef struct
{
    uint8_t x;
    uint8_t y;
    uint8_t z;
    uint8_t additionalXYZ;
} WiimoteDeviceAccelerometerCalibrationValue;

typedef struct
{
    WiimoteDeviceAccelerometerCalibrationValue zero;
    WiimoteDeviceAccelerometerCalibrationValue oneG;
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
