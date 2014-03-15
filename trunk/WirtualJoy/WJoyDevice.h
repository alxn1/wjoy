//
//  WJoyDevice.h
//  driver
//
//  Created by alxn1 on 17.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WJoyDeviceImpl;

@interface WJoyDevice : NSObject
{
    @private
        WJoyDeviceImpl *m_Impl;
}

+ (BOOL)prepare;

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor;

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor
              productString:(NSString*)productString;

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor
              productString:(NSString*)productString
  productSerialNumberString:(NSString*)productSerialNumberString;

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor
                   vendorID:(uint32_t)vendorID
                  productID:(uint32_t)productID
              productString:(NSString*)productString
  productSerialNumberString:(NSString*)productSerialNumberString;

- (BOOL)updateHIDState:(NSData*)HIDState;

@end
