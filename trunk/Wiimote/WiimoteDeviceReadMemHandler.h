//
//  WiimoteDeviceReadMemHandler.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WiimoteDevice;

@interface WiimoteDeviceReadMemHandler : NSObject
{
	@private
		WiimoteDevice	*m_Device;
		NSRange			 m_MemoryRange;
		NSMutableData	*m_ReadedData;
		BOOL			 m_IsAutorelease;
		id				 m_Target;
		SEL				 m_Action;
}

- (id)initWithMemoryRange:(NSRange)memoryRange
				   target:(id)target
				   action:(SEL)action;

- (BOOL)startWithDevice:(WiimoteDevice*)device
		 vibrationState:(BOOL)vibrationState;

- (BOOL)isAutorelease;
- (void)setAutorelease:(BOOL)flag;

@end
