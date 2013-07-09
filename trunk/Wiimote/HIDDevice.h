//
//  HIDDevice.h
//  HID
//
//  Created by alxn1 on 24.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IOKit/hid/IOHIDLib.h>

@class HIDDevice;
@class HIDManager;

@interface NSObject (HIDDeviceDelegate)

- (void)HIDDevice:(HIDDevice*)device reportDataReceived:(const uint8_t*)bytes length:(NSUInteger)length;
- (void)HIDDeviceDisconnected:(HIDDevice*)device;

@end

@interface HIDDevice : NSObject
{
    @private
        HIDManager      *m_Owner;

        BOOL             m_IsValid;
        IOHIDDeviceRef   m_Handle;
        IOOptionBits     m_Options;
        NSDictionary    *m_Properties;

        NSMutableData   *m_ReportBuffer;

        id               m_Delegate;
}

- (HIDManager*)owner;

- (BOOL)isValid;
- (void)invalidate;

// only kIOHIDOptionsTypeNone or kIOHIDOptionsTypeSeizeDevice
- (IOOptionBits)options;
- (BOOL)setOptions:(IOOptionBits)options;

- (NSDictionary*)properties;

- (BOOL)postBytes:(const uint8_t*)bytes length:(NSUInteger)length;

- (id)delegate;
- (void)setDelegate:(id)delegate;

@end

@interface HIDDevice (Properties)

- (NSString*)name;
- (NSString*)address;

@end
