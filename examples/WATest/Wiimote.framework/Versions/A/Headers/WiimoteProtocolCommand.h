//
//  WiimoteProtocolCommand.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#define WiimoteDeviceWriteMemoryReportMaxDataSize         16

typedef enum
{
    WiimoteDeviceCommandTypeSetLEDState                 = 0x11,
    WiimoteDeviceCommandTypeSetReportType               = 0x12,
    WiimoteDeviceCommandTypeSetIREnabledState           = 0x13,
    WiimoteDeviceCommandTypeEnableSpeaker               = 0x14,
    WiimoteDeviceCommandTypeGetState                    = 0x15,
	WiimoteDeviceCommandTypeWriteMemory                 = 0x16,
	WiimoteDeviceCommandTypeReadMemory                  = 0x17,
    WiimoteDeviceCommandTypeSpeakerData                 = 0x18,
    WiimoteDeviceCommandTypeMuteSpeaker                 = 0x19,
    WiimoteDeviceCommandTypeSetIREnabledState2          = 0x1A
} WiimoteDeviceCommandType;

typedef enum
{
    WiimoteDeviceCommandFlagVibrationEnabled            = 0x01
} WiimoteDeviceCommandFlag;

typedef enum
{
    WiimoteDeviceSetReportTypeCommandFlagPeriodic       = 0x04
} WiimoteDeviceSetReportTypeCommandFlag;

typedef enum
{
    WiimoteDeviceCommandSetIREnabledStateFlagIREnabled  = 0x04
} WiimoteDeviceCommandSetIREnabledStateFlag;

typedef enum
{
    WiimoteDeviceSetLEDStateCommandFlagLEDOne           = 0x10,
    WiimoteDeviceSetLEDStateCommandFlagLEDTwo           = 0x20,
    WiimoteDeviceSetLEDStateCommandFlagLEDThree         = 0x40,
    WiimoteDeviceSetLEDStateCommandFlagLEDFour          = 0x80
} WiimoteDeviceSetLEDStateCommandFlag;

typedef enum
{
    WiimoteDeviceIRModeBasic                            = 1,
    WiimoteDeviceIRModeExtended                         = 3,
    WiimoteDeviceIRModeFull                             = 5
} WiimoteDeviceIRMode;

typedef struct
{
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
