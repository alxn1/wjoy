//
//  WiimoteDeviceReport.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WiimoteDevice;
@class Wiimote;

@interface WiimoteDeviceReport : NSObject
{
	@private
		NSUInteger		 m_Type;
		WiimoteDevice	*m_Device;
		Wiimote			*m_Wiimote;
        const uint8_t   *m_Data;
        NSUInteger       m_DataLength;
}

- (NSUInteger)type; // WiimoteDeviceReportType

- (const uint8_t*)data;
- (NSUInteger)length;

- (Wiimote*)wiimote;

@end
