//
//  WiimoteProtocolCommand.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#define WiimoteDeviceWriteMemoryReportMaxDataSize 16

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

typedef struct {
    uint8_t packetType;
    uint8_t commandType;
} WiimoteDeviceCommandHeader;

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
