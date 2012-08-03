//
//  WiimoteEventDispatcher+Accelerometer.m
//  Wiimote
//
//  Created by alxn1 on 03.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+Accelerometer.h"
#import "WiimoteDelegate.h"

@implementation WiimoteEventDispatcher (Accelerometer)

- (void)postAccelerometerEnabledNotification:(BOOL)enabled
{
    [[self delegate] wiimote:[self owner] accelerometerEnabledStateChanged:enabled];

    [self postNotification:WiimoteAccelerometerEnabledStateChangedNotification
                     param:[NSNumber numberWithBool:enabled]
                       key:WiimoteAccelerometerEnabledStateKey];
}

- (void)postAccelerometerValueChangedNotificationX:(double)x Y:(double)y Z:(double)z
{
    [[self delegate] wiimote:[self owner] accelerometerChangedX:x Y:y Z:z];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:x],
                                        WiimoteAccelerometerValueXKey,
                                    [NSNumber numberWithDouble:y],
                                        WiimoteAccelerometerValueYKey,
                                    [NSNumber numberWithDouble:z],
                                        WiimoteAccelerometerValueZKey,
                                    nil];

        [self postNotification:WiimoteAccelerometerXYZValuesChangedNotification
                        params:params];
    }
}

- (void)postAccelerometerValueChangedNotificationPitch:(double)pitch roll:(double)roll
{
    [[self delegate] wiimote:[self owner] accelerometerChangedPitch:pitch roll:roll];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:pitch],
                                        WiimoteAccelerometerValuePitch,
                                    [NSNumber numberWithDouble:roll],
                                        WiimoteAccelerometerValueRoll,
                                    nil];

        [self postNotification:WiimoteAccelerometerPitchRollValuesChangedNotification
                        params:params];
    }
}

@end
