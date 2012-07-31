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
        NSDictionary *userInfo = [NSDictionary
                                    dictionaryWithObject:[NSNumber numberWithInteger:button]
                                                  forKey:WiimoteButtonKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteButtonPresedNotification
                                              object:[self owner]
                                            userInfo:userInfo];

    }
}

- (void)postButtonReleasedNotification:(WiimoteButtonType)button
{
    [[self delegate] wiimote:[self owner] buttonReleased:button];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *userInfo = [NSDictionary
                                    dictionaryWithObject:[NSNumber numberWithInteger:button]
                                                  forKey:WiimoteButtonKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteButtonReleasedNotification
                                              object:[self owner]
                                            userInfo:userInfo];

    }
}

@end
