//
//  WiimoteDevicePair.h
//  Wiimote
//
//  Created by alxn1 on 30.06.13.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IOBluetoothDevice;

@interface WiimoteDevicePair : NSObject
{
	@private
		BOOL m_IsFirstAttempt;
}

+ (void)pairWithDevice:(IOBluetoothDevice*)device;

@end
