//
//  WiimoteEventDispatcher+LED.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+LED.h"

@implementation WiimoteEventDispatcher (LED)

- (void)postHighlightedLEDMaskChangedNotification:(NSUInteger)mask
{
    [[self delegate] wiimote:[self owner] highlightedLEDMaskChanged:mask];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *userInfo = [NSDictionary
                                    dictionaryWithObject:[NSNumber numberWithInteger:mask]
                                                  forKey:WiimoteHighlightedLEDMaskKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteHighlightedLEDMaskChangedNotification
                                              object:[self owner]
                                            userInfo:userInfo];

    }
}

@end
