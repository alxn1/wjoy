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

- (void)setHardwareValueX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z;

- (void)setHardwareZeroX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z;
- (void)setHardware1gX:(uint16_t)x y:(uint16_t)y z:(uint16_t)z;

- (void)setCalibrationData:(const WiimoteDeviceAccelerometerCalibrationData*)calibrationData;

- (void)reset;

- (id)delegate;
- (void)setDelegate:(id)delegate;

@end

/*

    Additional methods, that can be called from WiimotePart or WiimoteExtension.
    But it can be called only for instance, what you created in extension or part for
    it's internal needs. Don't call it's methods, what created in Wiimote of Nunchuck :)
    You broke this accelerometers :)

*/
