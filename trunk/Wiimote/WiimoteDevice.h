//
//  WiimoteDevice.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteProtocol.h"
#import "WiimoteDeviceReport.h"

@class IOBluetoothDevice;
@class IOBluetoothL2CAPChannel;

@interface WiimoteDevice : NSObject
{
	@private
		BOOL						 m_IsConnected;
		IOBluetoothDevice			*m_Device;
		IOBluetoothL2CAPChannel     *m_DataChannel;
        IOBluetoothL2CAPChannel     *m_ControlChannel;

		NSMutableArray				*m_ReportHandlers;
		NSMutableArray				*m_DisconnectHandlers;
}

- (id)initWithBluetoothDevice:(IOBluetoothDevice*)device;

- (BOOL)isConnected;

- (BOOL)connect;
- (void)disconnect;

- (NSData*)address;
- (NSString*)addressString;

- (BOOL)postCommand:(WiimoteDeviceCommandType)command
			   data:(NSData*)data
     vibrationState:(BOOL)vibrationState;

- (BOOL)writeMemory:(NSUInteger)address
			   data:(NSData*)data
	 vibrationState:(BOOL)vibrationState;

- (BOOL)readMemory:(NSRange)memoryRange
	vibrationState:(BOOL)vibrationState
			target:(id)target
			action:(SEL)action;

- (BOOL)requestStateReportWithVibrationState:(BOOL)vibrationState;

@end

@interface WiimoteDevice (ReportHandling)

- (void)addReportHandler:(id)target action:(SEL)action;
- (void)removeReportHandler:(id)target action:(SEL)action;
- (void)removeReportHandler:(id)target;

- (void)addDisconnectHandler:(id)target action:(SEL)action;
- (void)removeDisconnectHandler:(id)target action:(SEL)action;
- (void)removeDisconnectHandler:(id)target;

- (void)removeHandler:(id)target;

- (void)removeAllHandlers;

@end
