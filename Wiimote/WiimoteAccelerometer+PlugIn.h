//
//  WiimoteAccelerometer+PlugIn.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAccelerometer.h"
#import "WiimoteProtocol.h"

@class WiimoteAccelerometer;

@interface NSObject (WiimoteAccelerometerDelegate)

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
         enabledStateChanged:(BOOL)enabled;

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
             gravityChangedX:(double)x
                           y:(double)y
                           z:(double)z;

- (void)wiimoteAccelerometer:(WiimoteAccelerometer*)accelerometer
                pitchChanged:(double)pitch
                        roll:(double)roll;

@end

@interface WiimoteAccelerometer (PlugIn)

- (uint16_t)zeroX;
- (uint16_t)zeroY;
- (uint16_t)zeroZ;

- (uint16_t)gX;
- (uint16_t)gY;
- (uint16_t)gZ;

- (void)setHardwareValueX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z;

- (void)setHardwareZeroX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z;
- (void)setHardware1gX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z;

- (void)setCalibrationData:(const WiimoteDeviceAccelerometerCalibrationData*)calibrationData;

- (void)reset;

- (id)delegate;
- (void)setDelegate:(id)delegate;

@end
