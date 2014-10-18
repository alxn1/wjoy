//
//  HIDDevice+Private.h
//  HID
//
//  Created by alxn1 on 24.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "HIDDevice.h"

@interface HIDDevice (Private)

- (id)initWithOwner:(HIDManager*)manager
          deviceRef:(IOHIDDeviceRef)handle
            options:(IOOptionBits)options;

- (BOOL)openDevice;
- (void)closeDevice;

- (void)handleReport:(uint8_t*)report length:(CFIndex)length;
- (void)disconnected;

@end
