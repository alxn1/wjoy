//
//  WiimoteDeviceEventDispatcher.h
//  Wiimote
//
//  Created by alxn1 on 02.08.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WiimoteDeviceReport;

@interface WiimoteDeviceEventDispatcher : NSObject
{
	@private
		NSMutableArray	*m_ReportHandlers;
		NSMutableArray	*m_DisconnectHandlers;
}

- (void)addReportHandler:(id)target action:(SEL)action;
- (void)removeReportHandler:(id)target action:(SEL)action;
- (void)removeReportHandler:(id)target;

- (void)addDisconnectHandler:(id)target action:(SEL)action;
- (void)removeDisconnectHandler:(id)target action:(SEL)action;
- (void)removeDisconnectHandler:(id)target;

- (void)removeHandler:(id)target;

- (void)removeAllHandlers;

- (void)handleReport:(WiimoteDeviceReport*)report;
- (void)handleDisconnect;

@end
