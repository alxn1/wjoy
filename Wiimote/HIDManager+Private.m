//
//  HIDManager+Private.m
//  HID
//
//  Created by alxn1 on 30.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "HIDManager+Private.h"

@implementation HIDManager (Private)

- (void)HIDDeviceDisconnected:(HIDDevice*)device
{
	[[device retain] autorelease];

	[m_ConnectedDevices removeObject:device];

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:HIDManagerDeviceDisconnectedNotification
                                          object:self
                                        userInfo:[NSDictionary
                                                        dictionaryWithObject:device
                                                                      forKey:HIDManagerDeviceKey]];
}

@end
