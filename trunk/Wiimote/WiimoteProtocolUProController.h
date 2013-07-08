//
//  WiimoteProtocolUProController.h
//  Wiimote
//
//  Created by alxn1 on 16.06.13.
//
//

typedef enum
{
	WiimoteDeviceUProControllerReportButtonMaskUp		= 0x0100,
    WiimoteDeviceUProControllerReportButtonMaskLeft		= 0x0200,
    WiimoteDeviceUProControllerReportButtonMaskZR		= 0x0400,
    WiimoteDeviceUProControllerReportButtonMaskX		= 0x0800,
    WiimoteDeviceUProControllerReportButtonMaskA		= 0x1000,
    WiimoteDeviceUProControllerReportButtonMaskY		= 0x2000,
    WiimoteDeviceUProControllerReportButtonMaskB		= 0x4000,
    WiimoteDeviceUProControllerReportButtonMaskZL		= 0x8000,
    WiimoteDeviceUProControllerReportButtonMaskR		= 0x0002,
    WiimoteDeviceUProControllerReportButtonMaskL		= 0x0020,
    WiimoteDeviceUProControllerReportButtonMaskDown		= 0x0040,
    WiimoteDeviceUProControllerReportButtonMaskRight	= 0x0080,

	WiimoteDeviceUProControllerReportButtonMaskStrickL	= 0x02,
	WiimoteDeviceUProControllerReportButtonMaskStrickR	= 0x01
} WiimoteDeviceUProControllerReportButtonMask;

typedef struct
{
	uint16_t leftStrickX;
	uint16_t rightStrickX;
	uint16_t leftStrickY;
	uint16_t rightStrickY;
	uint16_t buttonState;
	uint8_t	 additionalButtonState;
} WiimoteDeviceUProControllerReport;
