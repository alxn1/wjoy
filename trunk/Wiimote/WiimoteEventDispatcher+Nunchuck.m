//
//  WiimoteEventDispatcher+Nunchuck.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+Nunchuck.h"

@implementation WiimoteEventDispatcher (Nunchuck)

- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button
{
    [[self delegate] wiimote:[self owner] nunchuck:nunchuck buttonPressed:button];

    if([self isStateNotificationsEnabled])
    {
        [self postNotification:WiimoteNunchuckButtonPressedNotification
                         param:[NSNumber numberWithInteger:button]
                           key:WiimoteNunchuckButtonKey
                        sender:nunchuck];
    }
}

- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button
{
    [[self delegate] wiimote:[self owner] nunchuck:nunchuck buttonReleased:button];

    if([self isStateNotificationsEnabled])
    {
        [self postNotification:WiimoteNunchuckButtonReleasedNotification
                         param:[NSNumber numberWithInteger:button]
                           key:WiimoteNunchuckButtonKey
                        sender:nunchuck];
    }
}

- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position
{
    [[self delegate] wiimote:[self owner] nunchuck:nunchuck stickPositionChanged:position];

    if([self isStateNotificationsEnabled])
    {
        [self postNotification:WiimoteNunchuckStickPositionChangedNotification
                         param:[NSValue valueWithPoint:position]
                           key:WiimoteNunchuckStickPositionKey
                        sender:nunchuck];
    }
}

@end
