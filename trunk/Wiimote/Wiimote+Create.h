//
//  Wiimote+Create.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote.h"

@class HIDDevice;
@class IOBluetoothDevice;

@interface Wiimote (Create)

+ (void)connectToHIDDevice:(HIDDevice*)device;
+ (void)connectToBluetoothDevice:(IOBluetoothDevice*)device;

- (id)lowLevelDevice;

@end
