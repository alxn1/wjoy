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
- (void)postAccelerometerValueChangedNotificationX:(double)x Y:(double)y Z:(double)z;
- (void)postAccelerometerValueChangedNotificationPitch:(double)pitch roll:(double)roll;

@end
