//
//  WiimoteDevice.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteProtocol.h"
#import "WiimoteDeviceReport.h"
#import "WiimoteDeviceEventDispatcher.h"

@class IOBluetoothDevice;
@class IOBluetoothL2CAPChannel;

@class WiimoteDeviceReadMemQueue;

@interface WiimoteDevice : NSObject
{
	@private
		BOOL							 m_IsConnected;

		IOBluetoothDevice				*m_Device;
		IOBluetoothL2CAPChannel			*m_DataChannel;
        IOBluetoothL2CAPChannel			*m_ControlChannel;

		WiimoteDeviceEventDispatcher	*m_EventDispatcher;
		WiimoteDeviceReadMemQueue		*m_ReadMemQueue;

        BOOL							 m_IsVibrationEnabled;
        uint8_t                          m_LEDsState;
}

- (id)initWithBluetoothDevice:(IOBluetoothDevice*)device;

- (BOOL)isConnected;

- (BOOL)connect;
- (void)disconnect;

- (NSData*)address;
- (NSString*)addressString;

- (BOOL)postCommand:(WiimoteDeviceCommandType)command data:(NSData*)data;

- (BOOL)writeMemory:(NSUInteger)address data:(NSData*)data;
- (BOOL)readMemory:(NSRange)memoryRange target:(id)target action:(SEL)action;

- (BOOL)injectReport:(NSUInteger)type data:(NSData*)data;

- (BOOL)requestStateReport;
- (BOOL)requestReportType:(WiimoteDeviceReportType)type;

- (BOOL)isVibrationEnabled;
- (BOOL)setVibrationEnabled:(BOOL)enabled;

// WiimoteDeviceSetLEDStateCommandFlag mask
- (uint8_t)LEDsState;
- (BOOL)setLEDsState:(uint8_t)state;

- (WiimoteDeviceEventDispatcher*)eventDispatcher;

@end
