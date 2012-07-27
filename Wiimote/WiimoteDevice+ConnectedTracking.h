//
//  WiimoteDevice+ConnectedTracking.h
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"

@interface WiimoteDevice (ConnectedTracking)

+ (NSArray*)allConnectedDevices;
+ (void)addNewConnectedDevice:(WiimoteDevice*)device;
+ (void)removeConnectedDevice:(WiimoteDevice*)device;

@end
