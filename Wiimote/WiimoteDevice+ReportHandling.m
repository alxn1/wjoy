//
//  WiimoteDevice+ReportHandling.m
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice+ReportHandling.h"
#import "WiimoteDevice+Notification.h"
#import "WiimoteDevice+Extension.h"
#import "WiimoteDevice+Hardware.h"
#import "WiimoteDeviceProtocol.h"

#import "WiimoteDeviceExtension+PlugIn.h"

@implementation WiimoteDevice (ReportHandling)

- (BOOL)handleReport:(const unsigned char*)data length:(NSUInteger)length
{
    if(length < WiimoteDeviceReportHeaderSize)
        return NO;

    if(data[0] != WiimoteDevicePacketTypeReport)
        return NO;

    BOOL            result      = NO;
    unsigned char   reportType  = data[1];

    data    += WiimoteDeviceReportHeaderSize;
    length  -= WiimoteDeviceReportHeaderSize;

    switch(reportType)
    {
		case WiimoteDeviceReportTypeCoreButtonsAndExtStat:
			result = [self handleCoreButtonAndExtStat:data length:length];
			break;

        case WiimoteDeviceReportTypeCoreButtons:
            result = [self handleCoreButtonReport:data length:length];
            break;

        case WiimoteDeviceReportTypeStatus:
            result = [self handleStatusReport:data length:length];
            break;

		case WiimoteDeviceReportTypeDataReaded:
			result = [self handleReadMemoryReport:data length:length];
			break;

		case WiimoteDeviceReportTypeAcknowledge:
			result = [self handleAcknowledgeReport:data length:length];
			break;
    }

    return result;
}

- (BOOL)handleCoreButtonReport:(const unsigned char*)data length:(NSUInteger)length
{
    if(length < WiimoteDeviceCoreButtonReportSize)
        return NO;

    [self setButton:WiimoteButtonTypeLeft   pressed:((data[0] & WiimoteDeviceReportButtonFlagLeft)  != 0)];
    [self setButton:WiimoteButtonTypeRight  pressed:((data[0] & WiimoteDeviceReportButtonFlagRight) != 0)];
    [self setButton:WiimoteButtonTypeDown   pressed:((data[0] & WiimoteDeviceReportButtonFlagDown)  != 0)];
    [self setButton:WiimoteButtonTypeUp     pressed:((data[0] & WiimoteDeviceReportButtonFlagUp)    != 0)];
    [self setButton:WiimoteButtonTypePlus   pressed:((data[0] & WiimoteDeviceReportButtonFlagPlus)  != 0)];

    [self setButton:WiimoteButtonTypeTwo    pressed:((data[1] & WiimoteDeviceReportButtonFlagTwo)   != 0)];
    [self setButton:WiimoteButtonTypeOne    pressed:((data[1] & WiimoteDeviceReportButtonFlagOne)   != 0)];
    [self setButton:WiimoteButtonTypeB      pressed:((data[1] & WiimoteDeviceReportButtonFlagB)     != 0)];
    [self setButton:WiimoteButtonTypeA      pressed:((data[1] & WiimoteDeviceReportButtonFlagA)     != 0)];
    [self setButton:WiimoteButtonTypeMinus  pressed:((data[1] & WiimoteDeviceReportButtonFlagMinus) != 0)];
    [self setButton:WiimoteButtonTypeHome   pressed:((data[1] & WiimoteDeviceReportButtonFlagHome)  != 0)];

    return YES;
}

- (BOOL)handleCoreButtonAndExtStat:(const unsigned char*)data length:(NSUInteger)length
{
	if(![self handleCoreButtonReport:data length:length])
		return NO;

	return [m_Extension updateStateFromData:data + 2 length:length - 2];
}

- (BOOL)handleReadMemoryReport:(const unsigned char*)data length:(NSUInteger)length
{
	if(length < WiimoteDeviceMinReadMemoryReportSize)
		return NO;

	[self handleCoreButtonReport:data length:length];

	data	+= WiimoteDeviceMinReadMemoryReportSize;
	length	-= WiimoteDeviceMinReadMemoryReportSize;

	if(length == 0)
		return NO;

	[self processReadedData:data length:length];
	return YES;
}

- (BOOL)handleAcknowledgeReport:(const unsigned char*)data length:(NSUInteger)length
{
	if(length < WiimoteDeviceAknowledgeReportSize)
		return NO;

	[self handleCoreButtonReport:data length:length];

	return (data[3] != WiimoteDeviceAknowledgeError);
}

- (BOOL)handleStatusReport:(const unsigned char*)data length:(NSUInteger)length
{
    if(length < WiimoteDeviceStatusReportSize)
        return NO;

    double  batteryLevel			= ((double)data[5])/((double)WiimoteDeviceMaxBatteryLevel) * 100.0;
    BOOL    isLow					= ((data[2] & WiimoteDeviceStatusReportFlagBatteryIsLow) != 0);
	BOOL	isExtensionConnected	= ((data[2] & WiimoteDeviceStatusReportFlagExtensionConnected) != 0);
    BOOL    isBatteryStateChanged	= ((isLow != m_IsBatteryLevelLow) || (batteryLevel != m_BatteryLevel));

    if(batteryLevel > 100.0)
        batteryLevel = 100.0;

    m_IsUpdateStateStarted  = NO;
    m_IsBatteryLevelLow     = isLow;
    m_BatteryLevel          = batteryLevel;

    [self handleCoreButtonReport:data length:length];

    if(isBatteryStateChanged)
    {
        [self onBatteryLevelUpdated:m_BatteryLevel
                              isLow:m_IsBatteryLevelLow];
    }

	if(isExtensionConnected)
		[self createExtensionDevice];
	else
		[self releaseExtensionDevice];

	return [self enableButtonReport];
}

@end
