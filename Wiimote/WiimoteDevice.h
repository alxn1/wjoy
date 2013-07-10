//
//  WiimoteDevice.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteProtocol.h"
#import "WiimoteDeviceReport.h"

@class HIDDevice;
@class IOBluetoothDevice;

@class WiimoteDevice;
@class WiimoteDeviceReadMemQueue;

@class WiimoteDeviceTransport;

@interface NSObject (WiimoteDeviceDelegate)

- (void)wiimoteDevice:(WiimoteDevice*)device handleReport:(WiimoteDeviceReport*)report;
- (void)wiimoteDeviceDisconnected:(WiimoteDevice*)device;

@end

@interface WiimoteDevice : NSObject
{
	@private
		BOOL						 m_IsConnected;

		WiimoteDeviceTransport      *m_Transport;

        WiimoteDeviceReport			*m_Report;
		WiimoteDeviceReadMemQueue	*m_ReadMemQueue;

        BOOL						 m_IsVibrationEnabled;
        uint8_t                      m_LEDsState;

		id							 m_Delegate;
}

- (id)initWithHIDDevice:(HIDDevice*)device;
- (id)initWithBluetoothDevice:(IOBluetoothDevice*)device;

- (BOOL)isConnected;

- (BOOL)connect;
- (void)disconnect;

- (NSString*)name;
- (NSData*)address;
- (NSString*)addressString;

- (id)lowLevelDevice;

- (BOOL)postCommand:(WiimoteDeviceCommandType)command
               data:(const uint8_t*)data
             length:(NSUInteger)length;

- (BOOL)writeMemory:(NSUInteger)address
               data:(const uint8_t*)data
             length:(NSUInteger)length;

- (BOOL)readMemory:(NSRange)memoryRange
            target:(id)target
            action:(SEL)action;

- (BOOL)requestStateReport;
- (BOOL)requestReportType:(WiimoteDeviceReportType)type;

- (BOOL)isVibrationEnabled;
- (BOOL)setVibrationEnabled:(BOOL)enabled;

// WiimoteDeviceSetLEDStateCommandFlag mask
- (uint8_t)LEDsState;
- (BOOL)setLEDsState:(uint8_t)state;

- (id)delegate;
- (void)setDelegate:(id)delegate;

@end
