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
    WiimoteDeviceReportTypeState                    = 0x20,
	WiimoteDeviceReportTypeReadMemory               = 0x21,
	WiimoteDeviceReportTypeAcknowledge              = 0x22,
    WiimoteDeviceReportTypeButtonState              = 0x30,
	WiimoteDeviceReportTypeButtonAndExtensionState  = 0x32
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

#define WiimoteDeviceButtonAndExtensionStateDataSize 8

typedef struct
{
    WiimoteDeviceButtonState    buttonState;
    uint8_t                     data[WiimoteDeviceButtonAndExtensionStateDataSize];
} WiimoteDeviceButtonAndExtensionStateReport;

#define WiimoteRoutineProbeAddress                  0x4A400FA

#define WiimoteRoutineInitAddress1                  0x4A400F0
#define WiimoteRoutineInitAddress2                  0x4A400FB
#define WiimoteRoutineInitValue1                    0x55
#define WiimoteRoutineInitValue2                    0x00

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

#pragma pop(pack)
