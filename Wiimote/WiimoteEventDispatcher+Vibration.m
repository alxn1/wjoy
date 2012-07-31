//
//  WiimoteEventDispatcher+Vibration.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+Vibration.h"

@implementation WiimoteEventDispatcher (Vibration)

- (void)postVibrationStateChangedNotification:(BOOL)state
{
    [[self delegate] wiimote:[self owner] vibrationStateChanged:state];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *userInfo = [NSDictionary
                                    dictionaryWithObject:[NSNumber numberWithBool:state]
                                                  forKey:WiimoteVibrationStateKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteVibrationStateChangedNotification
                                              object:[self owner]
                                            userInfo:userInfo];
    }
}

@end
