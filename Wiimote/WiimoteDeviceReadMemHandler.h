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
		NSRange			 m_MemoryRange;
		NSMutableData	*m_ReadedData;
		id				 m_Target;
		SEL				 m_Action;
}

- (id)initWithMemoryRange:(NSRange)memoryRange
				   target:(id)target
				   action:(SEL)action;

- (NSRange)memoryRange;

- (BOOL)isAllDataReaded;
- (void)handleData:(const uint8_t*)data length:(NSUInteger)length;

- (void)errorOccured;
- (void)disconnected;

@end
