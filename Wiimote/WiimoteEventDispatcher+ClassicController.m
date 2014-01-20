//
//  WiimoteEventDispatcher+ClassicController.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+ClassicController.h"

@implementation WiimoteEventDispatcher (ClassicController)

- (void)postClassicController:(WiimoteClassicControllerExtension*)classic
                buttonPressed:(WiimoteClassicControllerButtonType)button
{
    [[self delegate] wiimote:[self owner]
           classicController:classic
               buttonPressed:button];

    if([self isStateNotificationsEnabled])
    {
        [self postNotification:WiimoteClassicControllerButtonPressedNotification
                         param:[NSNumber numberWithInteger:button]
                           key:WiimoteClassicControllerButtonKey
                        sender:classic];
    }
}

- (void)postClassicController:(WiimoteClassicControllerExtension*)classic
               buttonReleased:(WiimoteClassicControllerButtonType)button
{
    [[self delegate] wiimote:[self owner]
           classicController:classic
			  buttonReleased:button];

    if([self isStateNotificationsEnabled])
    {
        [self postNotification:WiimoteClassicControllerButtonReleasedNotification
                         param:[NSNumber numberWithInteger:button]
                           key:WiimoteClassicControllerButtonKey
                        sender:classic];
    }
}

- (void)postClassicController:(WiimoteClassicControllerExtension*)classic
                        stick:(WiimoteClassicControllerStickType)stick
              positionChanged:(NSPoint)position
{
    [[self delegate] wiimote:[self owner]
           classicController:classic
                       stick:stick
             positionChanged:position];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NSValue valueWithPoint:position],
                                                        WiimoteClassicControllerStickPositionKey,
                                                    [NSNumber numberWithInteger:stick],
                                                        WiimoteClassicControllerStickKey,
                                                    nil];

        [self postNotification:WiimoteClassicControllerStickPositionChangedNotification
                        params:userInfo
                        sender:classic];
    }
}

- (void)postClassicController:(WiimoteClassicControllerExtension*)classic
                  analogShift:(WiimoteClassicControllerAnalogShiftType)shift
              positionChanged:(CGFloat)position
{
    [[self delegate] wiimote:[self owner]
           classicController:classic
                 analogShift:shift
             positionChanged:position];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NSNumber numberWithFloat:position],
                                                        WiimoteClassicControllerAnalogShiftPositionKey,
                                                    [NSNumber numberWithInteger:shift],
                                                        WiimoteClassicControllerAnalogShiftKey,
                                                    nil];

        [self postNotification:WiimoteClassicControllerAnalogShiftPositionChangedNotification
                        params:userInfo
                        sender:classic];
    }
}

@end
