//
//  WiimoteEventDispatcher+Extension.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+Extension.h"

@implementation WiimoteEventDispatcher (Extension)

- (void)postExtensionConnectedNotification:(WiimoteExtension*)extension
{
    [[self delegate] wiimote:[self owner] extensionConnected:extension];

    [self postNotification:WiimoteExtensionConnectedNotification
                     param:extension
                       key:WiimoteExtensionKey];
}

- (void)postExtensionDisconnectedNotification:(WiimoteExtension*)extension
{
    [[self delegate] wiimote:[self owner] extensionDisconnected:extension];

    [self postNotification:WiimoteExtensionDisconnectedNotification
                     param:extension
                       key:WiimoteExtensionKey];
}

@end
