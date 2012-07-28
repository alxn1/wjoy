//
//  WiimoteDeviceProtocol.h
//  Wiimote
//
//  Created by alxn1 on 26.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WiimoteDeviceMaxBatteryLevel					0xC0

#define WiimoteDeviceReportHeaderSize				2
#define WiimoteDeviceStatusReportSize				6
#define WiimoteDeviceMinReadMemoryReportSize			5
#define WiimoteDeviceCoreButtonReportSize			2
#define WiimoteDeviceAknowledgeReportSize			4

#define WiimoteDeviceWriteMemotyDataSize				16

#define WiimoteDeviceAknowledgeError					0x03

typedef enum
{
    WiimoteDevicePacketTypeCommand					= 0xA2,
    WiimoteDevicePacketTypeReport					= 0xA1
} WiimoteDevicePacketType;

typedef enum
{
    WiimoteDeviceCommandTypeSetLEDStates				= 0x11,
    WiimoteDeviceCommandTypeEnableButtonReport		= 0x12,
    WiimoteDeviceCommandTypeGetStatus				= 0x15,
	WiimoteDeviceCommandTypeWriteMemory				= 0x16,
	WiimoteDeviceCommandTypeReadMemory				= 0x17
} WiimoteDeviceCommandType;

typedef enum
{
    WiimoteDeviceCommandFlagVibraEnabled				= 0x01,

    WiimoteDeviceCommandFlagPeriodic					= 0x04,

    WiimoteDeviceCommandFlagLEDOneEnabled			= 0x10,
    WiimoteDeviceCommandFlagLEDTwoEnabled			= 0x20,
    WiimoteDeviceCommandFlagLEDThreeEnabled			= 0x40,
    WiimoteDeviceCommandFlagLEDFourEnabled			= 0x80
} WiimoteDeviceCommandFlag;

typedef enum
{
    WiimoteDeviceReportTypeStatus					= 0x20,
	WiimoteDeviceReportTypeDataReaded				= 0x21,
	WiimoteDeviceReportTypeAcknowledge				= 0x22,
    WiimoteDeviceReportTypeCoreButtons				= 0x30,
	WiimoteDeviceReportTypeCoreButtonsAndExtStat		= 0x32
} WiimoteDeviceReportType;

typedef enum
{
    // first byte
    WiimoteDeviceReportButtonFlagLeft				= 0x01,
    WiimoteDeviceReportButtonFlagRight				= 0x02,
    WiimoteDeviceReportButtonFlagDown				= 0x04,
    WiimoteDeviceReportButtonFlagUp					= 0x08,
    WiimoteDeviceReportButtonFlagPlus				= 0x10,

    // second byte
    WiimoteDeviceReportButtonFlagTwo					= 0x01,
    WiimoteDeviceReportButtonFlagOne					= 0x02,
    WiimoteDeviceReportButtonFlagB					= 0x04,
    WiimoteDeviceReportButtonFlagA					= 0x08,
    WiimoteDeviceReportButtonFlagMinus				= 0x10,
    WiimoteDeviceReportButtonFlagHome				= 0x80
} WiimoteDeviceReportButtonFlag;

typedef enum
{
    WiimoteDeviceStatusReportFlagBatteryIsLow		= 0x01,
    WiimoteDeviceStatusReportFlagExtensionConnected	= 0x02,
    WiimoteDeviceStatusReportFlagSpeakerEnabled		= 0x04,
    WiimoteDeviceStatusReportFlagIRCameraEnabled		= 0x08
} WiimoteDeviceStatusReportFlag;
