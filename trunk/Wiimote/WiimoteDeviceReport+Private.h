//
//  WiimoteDeviceReport+Private.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReport.h"

@interface WiimoteDeviceReport (Private)

+ (WiimoteDeviceReport*)parseReportData:(const uint8_t*)data
								 length:(NSUInteger)length
								 device:(WiimoteDevice*)device;

+ (WiimoteDeviceReport*)deviceReportWithType:(NSUInteger)type
                                        data:(NSData*)data
                                      device:(WiimoteDevice*)device;

- (WiimoteDevice*)device;

- (void)setWiimote:(Wiimote*)wiimote;

@end
