//
//  WiimoteDevice+Notification.m
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice+Notification.h"

@implementation WiimoteDevice (Notification)

+ (void)onBeginDiscovery
{
    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteDeviceBeginDiscoveryNotification
                                          object:self];
}

+ (void)onEndDiscovery
{
    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteDeviceEndDiscoveryNotification
                                          object:self];
}

- (void)onConnected
{
    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteDeviceConnectedNotification
                                          object:self];
}

- (void)onButtonPressed:(WiimoteButtonType)button
{
    [m_Delegate wiimoteDevice:self buttonPressed:button];

    if(m_IsStateChangeNotificationsEnabled)
    {
        NSDictionary *userInfo =
                  [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:button]
                                              forKey:WiimoteDeviceButtonKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteDeviceButtonPresedNotification
                                              object:self
                                            userInfo:userInfo];
    }
}

- (void)onButtonReleased:(WiimoteButtonType)button
{
    [m_Delegate wiimoteDevice:self buttonReleased:button];

    if(m_IsStateChangeNotificationsEnabled)
    {
        NSDictionary *userInfo =
                  [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:button]
                                              forKey:WiimoteDeviceButtonKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteDeviceButtonReleasedNotification
                                              object:self
                                            userInfo:userInfo];
    }
}

- (void)onHighlightedLEDMaskChanged:(NSUInteger)mask
{
    [m_Delegate wiimoteDevice:self highlightedLEDMaskChanged:mask];

    if(m_IsStateChangeNotificationsEnabled)
    {
        NSDictionary *userInfo =
                  [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:mask]
                                              forKey:WiimoteDeviceHighlightedLEDMaskKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteDeviceHighlightedLEDMaskChangedNotification
                                              object:self
                                            userInfo:userInfo];
    }
}

- (void)onVibrationStateChanged:(BOOL)isVibrationEnabled
{
    [m_Delegate wiimoteDevice:self vibrationStateChanged:isVibrationEnabled];

    if(m_IsStateChangeNotificationsEnabled)
    {
        NSDictionary *userInfo =
                  [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:isVibrationEnabled]
                                              forKey:WiimoteDeviceVibrationStateKey];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteDeviceVibrationStateChangedNotification
                                              object:self
                                            userInfo:userInfo];
    }
}

- (void)onBatteryLevelUpdated:(double)batteryLevel isLow:(BOOL)isLow
{
    [m_Delegate wiimoteDevice:self
          batteryLevelUpdated:batteryLevel
                        isLow:isLow];

    if(m_IsStateChangeNotificationsEnabled)
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithDouble:batteryLevel],   WiimoteDeviceBatteryLevelKey,
                                        [NSNumber numberWithBool:isLow],            WiimoteDeviceIsBatteryLevelLowKey,
                                        nil];

        [[NSNotificationCenter defaultCenter]
                                postNotificationName:WiimoteDeviceBatteryLevelUpdatedNotification
                                              object:self
                                            userInfo:userInfo];

    }
}

- (void)onDisconnected
{
    [m_Delegate wiimoteDeviceDisconnected:self];

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteDeviceDisconnectedNotification
                                          object:self];
}

- (void)setButton:(WiimoteButtonType)button pressed:(BOOL)pressed
{
    if(m_ButtonState[button] == pressed)
        return;

    m_ButtonState[button] = pressed;

    if(pressed)
        [self onButtonPressed:button];
    else
        [self onButtonReleased:button];
}

@end
