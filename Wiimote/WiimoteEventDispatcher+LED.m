//
//  WiimoteEventDispatcher+LED.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+LED.h"
#import "WiimoteDelegate.h"

@implementation WiimoteEventDispatcher (LED)

- (void)postHighlightedLEDMaskChangedNotification:(NSUInteger)mask
{
    [[self delegate] wiimote:[self owner] highlightedLEDMaskChanged:mask];

    if([self isStateNotificationsEnabled])
    {
        [self postNotification:WiimoteHighlightedLEDMaskChangedNotification
                         param:[NSNumber numberWithInteger:mask]
                           key:WiimoteHighlightedLEDMaskKey];
    }
}

@end
