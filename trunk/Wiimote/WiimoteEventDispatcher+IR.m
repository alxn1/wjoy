//
//  WiimoteEventDispatcher+IR.m
//  Wiimote
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+IR.h"
#import "WiimoteDelegate.h"

@implementation WiimoteEventDispatcher (IR)

- (void)postIREnabledStateChangedNotification:(BOOL)enabled
{
    [self postNotification:WiimoteIREnabledStateChangedNotification
                     param:[NSNumber numberWithBool:enabled]
                       key:WiimoteIREnabledStateKey];
}

- (void)postIRPointPositionChangedNotification:(WiimoteIRPoint*)point
{
    [self postNotification:WiimoteIRPointPositionChangedNotification
                     param:point
                       key:WiimoteIRPointKey];
}

@end