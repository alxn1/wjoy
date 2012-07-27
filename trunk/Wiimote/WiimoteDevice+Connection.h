//
//  WiimoteDevice+Connection.h
//  Wiimote
//
//  Created by alxn1 on 25.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"

@class IOBluetoothDevice;

@interface WiimoteDevice (Connection)

+ (void)connectToBluetoothDevice:(IOBluetoothDevice*)device;

@end
