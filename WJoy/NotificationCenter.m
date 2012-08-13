//
//  NotificationCenter.m
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/Wiimote.h>
#import <UserNotification/UserNotificationCenter.h>

#import "NotificationCenter.h"

@interface NotificationCenter (PrivatePart)

- (id)initInternal;

- (void)onDiscoveryBegin;
- (void)onDiscoveryEnd;
- (void)onDeviceConnected;
- (void)onDeviceBatteryStateChanged:(NSNotification*)notification;
- (void)onDeviceDisconnected;

@end

@implementation NotificationCenter

+ (void)start
{
    [[NotificationCenter alloc] initInternal];
}

@end

@implementation NotificationCenter (PrivatePart)

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initInternal
{
    self = [super init];
    if(self == nil)
        return nil;

    [[Wiimote notificationCenter]
                            addObserver:self
                               selector:@selector(onDiscoveryBegin)
                                   name:WiimoteBeginDiscoveryNotification
                                 object:nil];

    [[Wiimote notificationCenter]
                            addObserver:self
                               selector:@selector(onDiscoveryEnd)
                                   name:WiimoteEndDiscoveryNotification
                                 object:nil];

    [[Wiimote notificationCenter]
                            addObserver:self
                               selector:@selector(onDeviceConnected)
                                   name:WiimoteConnectedNotification
                                 object:nil];

    [[Wiimote notificationCenter]
                            addObserver:self
                               selector:@selector(onDeviceBatteryStateChanged:)
                                   name:WiimoteBatteryLevelUpdatedNotification
                                 object:nil];

    [[Wiimote notificationCenter]
                            addObserver:self
                               selector:@selector(onDeviceDisconnected)
                                   name:WiimoteDisconnectedNotification
                                 object:nil];

    [UserNotificationCenter
        deliver:[UserNotification
                    userNotificationWithTitle:@"WJoy started"
                                         text:@"We started :)"]];

    return self;
}

- (void)dealloc
{
    [[Wiimote notificationCenter] removeObserver:self];
    [super dealloc];
}

- (void)onDiscoveryBegin
{
    [UserNotificationCenter
        deliver:[UserNotification
                    userNotificationWithTitle:@"Begin Discovery"
                                         text:@"Begin discovery for new Wiimote :)"]];
}

- (void)onDiscoveryEnd
{
    [UserNotificationCenter
        deliver:[UserNotification
                    userNotificationWithTitle:@"End Discovery"
                                         text:@"Discovery for new Wiimote finished :)"]];
}

- (void)onDeviceConnected
{
    [UserNotificationCenter
        deliver:[UserNotification
                    userNotificationWithTitle:@"Wiimote connected"
                                         text:@"New Wiimote connected :)"]];
}

- (void)onDeviceBatteryStateChanged:(NSNotification*)notification
{
    Wiimote *device = [notification object];

    if([device userInfo] != nil ||
      ![device isBatteryLevelLow])
    {
        return;
    }

    [device setUserInfo:[NSDictionary dictionary]];

    [UserNotificationCenter
        deliver:[UserNotification
                    userNotificationWithTitle:@"Wiimote battery is low"
                                         text:@"Some Wiimote battery is low!!!"]];
}

- (void)onDeviceDisconnected
{
    [UserNotificationCenter
        deliver:[UserNotification
                    userNotificationWithTitle:@"Wiimote disconnected"
                                         text:@"One of connected Wiimotes disconnected :("]];
}

@end
