//
//  Wiimote+Create.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote.h"

@class IOBluetoothDevice;

@interface Wiimote (Create)

+ (void)connectToBluetoothDevice:(IOBluetoothDevice*)device;

@end
