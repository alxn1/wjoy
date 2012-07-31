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

    NSDictionary *userInfo = [NSDictionary
                                dictionaryWithObject:extension
                                              forKey:WiimoteExtensionKey];

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteExtensionConnectedNotification
                                          object:[self owner]
                                        userInfo:userInfo];
}

- (void)postExtensionDisconnectedNotification:(WiimoteExtension*)extension
{
    [[self delegate] wiimote:[self owner] extensionDisconnected:extension];

    NSDictionary *userInfo = [NSDictionary
                                dictionaryWithObject:extension
                                              forKey:WiimoteExtensionKey];

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteExtensionDisconnectedNotification
                                          object:[self owner]
                                        userInfo:userInfo];
}

@end
