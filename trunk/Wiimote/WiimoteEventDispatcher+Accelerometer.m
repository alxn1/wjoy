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

- (void)postAccelerometerGravityChangedNotificationX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z
{
    [[self delegate] wiimote:[self owner] accelerometerChangedGravityX:x y:y z:z];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:x],
                                        WiimoteAccelerometerGravityXKey,
                                    [NSNumber numberWithDouble:y],
                                        WiimoteAccelerometerGravityYKey,
                                    [NSNumber numberWithDouble:z],
                                        WiimoteAccelerometerGravityZKey,
                                    nil];

        [self postNotification:WiimoteAccelerometerGravityChangedNotification
                        params:params];
    }
}

- (void)postAccelerometerAnglesChangedNotificationPitch:(CGFloat)pitch roll:(CGFloat)roll
{
    [[self delegate] wiimote:[self owner] accelerometerChangedPitch:pitch roll:roll];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:pitch],
                                        WiimoteAccelerometerPitchKey,
                                    [NSNumber numberWithDouble:roll],
                                        WiimoteAccelerometerRollKey,
                                    nil];

        [self postNotification:WiimoteAccelerometerAnglesChangedNotification
                        params:params];
    }
}

@end
