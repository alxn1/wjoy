//
//  HIDManager.h
//  HID
//
//  Created by alxn1 on 24.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <HID/HIDDevice.h>

FOUNDATION_EXPORT NSString *HIDManagerDeviceConnectedNotification;
FOUNDATION_EXPORT NSString *HIDManagerDeviceDisconnectedNotification;

FOUNDATION_EXPORT NSString *HIDManagerDeviceKey;

@interface HIDManager : NSObject
{
    @private
        IOHIDManagerRef  m_Handle;
        NSMutableSet    *m_ConnectedDevices;
}

+ (HIDManager*)manager;

- (NSSet*)connectedDevices;

@end
