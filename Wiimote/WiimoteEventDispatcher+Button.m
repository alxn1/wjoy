//
//  WiimoteEventDispatcher+Button.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+Button.h"

@implementation WiimoteEventDispatcher (Button)

- (void)postButtonPressedNotification:(WiimoteButtonType)button
{
    [[self delegate] wiimote:[self owner] buttonPressed:button];

    if([self isStateNotificationsEnabled])
    {
        [self postNotification:WiimoteButtonPresedNotification
                         param:[NSNumber numberWithInteger:button]
                           key:WiimoteButtonKey];
    }
}

- (void)postButtonReleasedNotification:(WiimoteButtonType)button
{
    [[self delegate] wiimote:[self owner] buttonReleased:button];

    if([self isStateNotificationsEnabled])
    {
        [self postNotification:WiimoteButtonReleasedNotification
                         param:[NSNumber numberWithInteger:button]
                           key:WiimoteButtonKey];
    }
}

@end
