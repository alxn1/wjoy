//
//  WiimoteEventDispatcher+Battery.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+Battery.h"

@implementation WiimoteEventDispatcher (Battery)

- (void)postBatteryLevelUpdateNotification:(double)batteryLevel isLow:(BOOL)isLow
{
    [[self delegate] wiimote:[self owner] batteryLevelUpdated:batteryLevel isLow:isLow];

    NSDictionary *userInfo = [NSDictionary
                                dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithDouble:batteryLevel],
                                            WiimoteBatteryLevelKey,
                                        [NSNumber numberWithBool:isLow],
                                            WiimoteIsBatteryLevelLowKey,
                                        nil];

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteBatteryLevelUpdatedNotification
                                          object:[self owner]
                                        userInfo:userInfo];
}

@end
