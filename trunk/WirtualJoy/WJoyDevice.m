//
//  WJoyDevice.m
//  driver
//
//  Created by alxn1 on 17.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WJoyDevice.h"

#import "WJoyDeviceImpl.h"

@implementation WJoyDevice

+ (BOOL)prepare
{
    return [WJoyDeviceImpl prepare];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor
{
    return [self initWithHIDDescriptor:HIDDescriptor
                              vendorID:0
                             productID:0
                         productString:nil
             productSerialNumberString:nil];
}

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor
              productString:(NSString*)productString
{
    return [self initWithHIDDescriptor:HIDDescriptor
                              vendorID:0
                             productID:0
                         productString:productString
             productSerialNumberString:nil];
}

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor
              productString:(NSString*)productString
  productSerialNumberString:(NSString*)productSerialNumberString
{
    return [self initWithHIDDescriptor:HIDDescriptor
                              vendorID:0
                             productID:0
                         productString:productString
             productSerialNumberString:productSerialNumberString];
}

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor
                   vendorID:(uint32_t)vendorID
                  productID:(uint32_t)productID
              productString:(NSString*)productString
  productSerialNumberString:(NSString*)productSerialNumberString
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Impl = [[WJoyDeviceImpl alloc] init];

    if(m_Impl == nil)
    {
        [self release];
        return nil;
    }

    if(vendorID != 0 || productID != 0)
    {
        char data[sizeof(uint32_t) * 2] = { 0 };

        memcpy(data, vendorID, sizeof(uint32_t));
        memcpy(data + sizeof(uint32_t), productID, sizeof(uint32_t));

        [m_Impl call:WJoyDeviceMethodSelectorSetDeviceVendorAndProductID
                data:[NSData dataWithBytes:data length:sizeof(data)]];
    }

    if(productSerialNumberString != nil)
    {
        const char *data = [productSerialNumberString UTF8String];
        size_t      size = strlen(data) + 1; // zero-terminator

        [m_Impl call:WJoyDeviceMethodSelectorSetDeviceSerialNumberString
                data:[NSData dataWithBytes:data length:size]];
    }

    if(productString != nil)
    {
        const char *data = [productString UTF8String];
        size_t      size = strlen(data) + 1; // zero-terminator

        [m_Impl call:WJoyDeviceMethodSelectorSetDeviceProductString
                data:[NSData dataWithBytes:data length:size]];
    }

    if(![m_Impl call:WJoyDeviceMethodSelectorEnable data:HIDDescriptor])
    {
        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc
{
    [m_Impl release];
    [super dealloc];
}

- (BOOL)updateHIDState:(NSData*)HIDState
{
    return [m_Impl call:WJoyDeviceMethodSelectorUpdateState data:HIDState];
}

@end
