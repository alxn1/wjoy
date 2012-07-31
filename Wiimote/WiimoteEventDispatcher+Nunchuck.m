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
        NSDictionary *userInfo = [NSDictionary
                                        dictionaryWithObject:[NSNumber numberWithInteger:button]
                                                      forKey:WiimoteNunchuckButtonKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteNunchuckButtonPressedNotification
                                              object:nunchuck
                                            userInfo:userInfo];
    }
}

- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button
{
    [[self delegate] wiimote:[self owner] nunchuck:nunchuck buttonReleased:button];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *userInfo = [NSDictionary
                                        dictionaryWithObject:[NSNumber numberWithInteger:button]
                                                      forKey:WiimoteNunchuckButtonKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteNunchuckButtonReleasedNotification
                                              object:nunchuck
                                            userInfo:userInfo];
    }
}

- (void)postNunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position
{
    [[self delegate] wiimote:[self owner] nunchuck:nunchuck stickPositionChanged:position];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *userInfo = [NSDictionary
                                        dictionaryWithObject:[NSValue valueWithPoint:position]
                                                      forKey:WiimoteNunchuckStickPositionKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteNunchuckStickPositionChangedNotification
                                              object:nunchuck
                                            userInfo:userInfo];
    }
}

@end
