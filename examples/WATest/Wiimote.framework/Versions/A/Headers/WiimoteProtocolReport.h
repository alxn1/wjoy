//
//  WiimoteProtocolReport.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#define WiimoteDeviceAccelerometerDataSize              3

#define WiimoteDeviceReadMemoryReportErrorMask          0x0F
#define WiimoteDeviceReadMemoryReportDataSizeMask       0xF0
#define WiimoteDeviceReadMemoryReportErrorOffset        0
#define WiimoteDeviceReadMemoryReportDataSizeOffset     4
#define WiimoteDeviceReadMemoryReportMaxDataSize        16
#define WiimoteDeviceReadMemoryReportErrorOk            0

#define WiimoteDeviceMaxBatteryLevel                    0xC0

typedef uint16_t WiimoteDeviceButtonState;

typedef enum
{
    WiimoteDeviceReportTypeState                                                = 0x20,
	WiimoteDeviceReportTypeReadMemory                                           = 0x21,
	WiimoteDeviceReportTypeAcknowledge                                          = 0x22,

    WiimoteDeviceReportTypeButtonState                                          = 0x30,
    WiimoteDeviceReportTypeButtonAndAccelerometerState                          = 0x31,
	WiimoteDeviceReportTypeButtonAndExtension8BytesState                        = 0x32,
    WiimoteDeviceReportTypeButtonAndAccelerometerAndIR12BytesState              = 0x33,
    WiimoteDeviceReportTypeButtonAndExtension19BytesState                       = 0x34,
    WiimoteDeviceReportTypeButtonAndAccelerometerAndExtension16BytesState       = 0x35,
    WiimoteDeviceReportTypeButtonAndIR10BytesAndExtension9BytesState            = 0x36,
    WiimoteDeviceReportTypeButtonAndAccelerometerAndIR10BytesAndExtension6Bytes = 0x37
} WiimoteDeviceReportType;

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

typedef enum
{
    WiimoteDeviceStateReportFlagBatteryIsLow		= 0x01,
    WiimoteDeviceStateReportFlagExtensionConnected	= 0x02,
    WiimoteDeviceStateReportFlagSpeakerEnabled		= 0x04,
    WiimoteDeviceStateReportFlagIREnabled           = 0x08
} WiimoteDeviceStateReportFlag;

typedef struct
{
    WiimoteDeviceButtonState buttonState;
    uint8_t                  errorAndDataSize;
    uint16_t                 dataOffset;
    uint8_t                  data[WiimoteDeviceReadMemoryReportMaxDataSize];
} WiimoteDeviceReadMemoryReport;

typedef struct
{
    WiimoteDeviceButtonState buttonState;
    uint8_t                  flagsAndLEDState;
    uint16_t                 reserved;
    uint8_t                  batteryLevel;
} WiimoteDeviceStateReport;

typedef struct
{
    uint8_t accelerometerAdditionalX;
    uint8_t accelerometerAdditionalYZ;
    uint8_t accelerometerX;
    uint8_t accelerometerY;
    uint8_t accelerometerZ;
} WiimoteDeviceButtonAndAccelerometerStateReport;
