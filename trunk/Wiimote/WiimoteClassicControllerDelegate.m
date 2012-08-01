//
//  WiimoteClassicControllerDelegate.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteClassicControllerDelegate.h"

NSString *WiimoteClassicControllerButtonPressedNotification                 = @"WiimoteClassicControllerButtonPressedNotification";
NSString *WiimoteClassicControllerButtonReleasedNotification                = @"WiimoteClassicControllerButtonReleasedNotification";
NSString *WiimoteClassicControllerStickPositionChangedNotification          = @"WiimoteClassicControllerStickPositionChangedNotification";
NSString *WiimoteClassicControllerAnalogShiftPositionChangedNotification    = @"WiimoteClassicControllerAnalogShiftPositionChangedNotification";

NSString *WiimoteClassicControllerStickKey                                  = @"WiimoteClassicControllerStickKey";
NSString *WiimoteClassicControllerButtonKey                                 = @"WiimoteClassicControllerButtonKey";
NSString *WiimoteClassicControllerAnalogShiftKey                            = @"WiimoteClassicControllerAnalogShiftKey";
NSString *WiimoteClassicControllerStickPositionKey                          = @"WiimoteClassicControllerStickPositionKey";
NSString *WiimoteClassicControllerAnalogShiftPositionKey                    = @"WiimoteClassicControllerAnalogShiftPositionKey";

@implementation NSObject (WiimoteClassicControllerDelegate)

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
        buttonPressed:(WiimoteClassicControllerButtonType)button
{
}

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
       buttonReleased:(WiimoteClassicControllerButtonType)button
{
}

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
                stick:(WiimoteClassicControllerStickType)stick
      positionChanged:(NSPoint)position
{
}

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
          analogShift:(WiimoteClassicControllerAnalogShiftType)shift
      positionChanged:(float)position
{
}

@end
