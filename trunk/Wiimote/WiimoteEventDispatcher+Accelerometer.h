//
//  WiimoteEventDispatcher+Accelerometer.h
//  Wiimote
//
//  Created by alxn1 on 03.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher.h"

@interface WiimoteEventDispatcher (Accelerometer)

- (void)postAccelerometerEnabledNotification:(BOOL)enabled;
- (void)postAccelerometerGravityChangedNotificationX:(double)x y:(double)y z:(double)z;
- (void)postAccelerometerAnglesChangedNotificationPitch:(double)pitch roll:(double)roll;

@end
