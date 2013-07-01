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

@interface NSObject (HIDDeviceDelegate)

- (void)hidDevice:(HIDDevice*)device reportDataReceived:(const uint8_t*)bytes length:(NSUInteger)length;
- (void)hidDeviceClosed:(HIDDevice*)device;

@end

@interface HIDDevice : NSObject
{
    @private
        IOHIDDeviceRef   m_Handle;
        NSDictionary    *m_Properties;
        NSMutableData   *m_ReportBuffer;
        BOOL             m_IsOpened;
        id               m_Delegate;
}

- (BOOL)isOpened;

- (BOOL)open;
- (BOOL)openWithOptions:(IOHIDOptionsType)options;
- (void)close;

- (BOOL)postBytes:(const uint8_t*)bytes length:(NSUInteger)length;

- (NSDictionary*)properties;

- (id)delegate;
- (void)setDelegate:(id)delegate;

@end

@interface HIDDevice (Properties)

- (NSString*)name;
- (NSString*)address;

@end
