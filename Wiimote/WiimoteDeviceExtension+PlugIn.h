//
//  WiimoteDeviceExtension+PlugIn.h
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceExtension.h"

#define WiimoteDeviceExtensionCalibrationDataSize	32

@interface WiimoteDeviceExtension (PlugIn)

+ (NSRange)probeAddressSpace;
+ (BOOL)probe:(const unsigned char*)data length:(NSUInteger)length;

- (id)initWithDevice:(WiimoteDevice*)device;

- (NSRange)calibrationAddressSpace;
- (BOOL)setCalibrationData:(const unsigned char*)data length:(NSUInteger)length;
- (BOOL)updateStateFromData:(const unsigned char*)data length:(NSUInteger)length;

- (void)reset;

@end
