//
//  NotificationCenter.m
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/Wiimote.h>
#import <UpdateChecker/UAppUpdateChecker.h>

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

- (BOOL)userNotificationCenter:(UserNotificationCenter*)center
     shouldDeliverNotification:(UserNotification*)notification
{
    return YES;
}

- (void)userNotificationCenter:(UserNotificationCenter*)center
           notificationClicked:(UserNotification*)notification
{
    NSString *url = [[notification userInfo] objectForKey:@"URL"];
    if(url != nil)
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url]];
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

    [[NSNotificationCenter defaultCenter]
                                addObserver:self
                                   selector:@selector(onCheckNewVersionFinished:)
                                       name:UAppUpdateCheckerDidFinishNotification
                                     object:nil];

    [UserNotificationCenter setDelegate:self];

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

- (void)onCheckNewVersionFinished:(NSNotification*)notification
{
    NSError     *err            = [[notification userInfo] objectForKey:UAppUpdateCheckerErrorKey];
    NSNumber    *hasNewVersion  = [[notification userInfo] objectForKey:UAppUpdateCheckerHasNewVersionKey];
    NSURL       *url            = [[notification userInfo] objectForKey:UAppUpdateCheckerDownloadURLKey];

    if(err != nil)
    {
        [UserNotificationCenter
            deliver:[UserNotification
                        userNotificationWithTitle:@"Error"
                                             text:@"Can't check for update"]];

        return;
    }

    if([hasNewVersion boolValue])
    {
        UserNotification *notification = [UserNotification
                                                userNotificationWithTitle:@"New version available!"
                                                                     text:@"New version available!"
                                                                 userInfo:[NSDictionary dictionaryWithObject:[url absoluteString] forKey:@"URL"]];

        [UserNotificationCenter deliver:notification];
        return;
    }

    [UserNotificationCenter
            deliver:[UserNotification
                        userNotificationWithTitle:@"No new version available"
                                             text:@"No new version available :("]];
}

@end
