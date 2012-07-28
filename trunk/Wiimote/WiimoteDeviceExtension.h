//
//  WiimoteDeviceExtension.h
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
	WiimoteExtensionTypeNone				=	 0,

	WiimoteExtensionTypeNunchuck			=	 1,
	WiimoteExtensionTypeClassicController	=	 2,

	WiimoteExtensionTypeUnknown				= 0xFF
} WiimoteExtensionType;

@class WiimoteDevice;

@interface WiimoteDeviceExtension : NSObject
{
	@private
		WiimoteDevice *m_Device;
}

- (NSUInteger)type; // WiimoteExtensionType or other value
- (WiimoteDevice*)device;

@end
