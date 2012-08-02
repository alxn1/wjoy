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
@class WiimoteDeviceReadMemHandler;

@interface WiimoteDevice : NSObject
{
	@private
		BOOL						 m_IsConnected;
		IOBluetoothDevice			*m_Device;
		IOBluetoothL2CAPChannel     *m_DataChannel;
        IOBluetoothL2CAPChannel     *m_ControlChannel;

		NSMutableArray				*m_ReportHandlers;
		NSMutableArray				*m_DisconnectHandlers;

        BOOL                         m_IsVibrationEnabled;

        NSMutableArray              *m_ReadMemHandlersQueue;
        WiimoteDeviceReadMemHandler *m_CurrentMemHandler;
}

- (id)initWithBluetoothDevice:(IOBluetoothDevice*)device;

- (BOOL)isConnected;

- (BOOL)connect;
- (void)disconnect;

- (NSData*)address;
- (NSString*)addressString;

- (BOOL)isVibrationEnabled;
- (void)setVibrationEnabled:(BOOL)enabled;

- (BOOL)postCommand:(WiimoteDeviceCommandType)command data:(NSData*)data;

- (BOOL)writeMemory:(NSUInteger)address data:(NSData*)data;
- (BOOL)readMemory:(NSRange)memoryRange target:(id)target action:(SEL)action;

- (BOOL)injectReport:(NSUInteger)type data:(NSData*)data;

- (BOOL)requestStateReport;

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
