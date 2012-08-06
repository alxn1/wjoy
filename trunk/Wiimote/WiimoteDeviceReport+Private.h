//
//  WiimoteDeviceReport+Private.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReport.h"

@interface WiimoteDeviceReport (Private)

+ (WiimoteDeviceReport*)deviceReportWithType:(NSUInteger)type
                                        data:(const uint8_t*)data
                                      length:(NSUInteger)length
                                      device:(WiimoteDevice*)device;

- (id)initWithDevice:(WiimoteDevice*)device;

- (BOOL)updateFromReportData:(const uint8_t*)data length:(NSUInteger)length;

- (WiimoteDevice*)device;

- (void)setWiimote:(Wiimote*)wiimote;

@end
