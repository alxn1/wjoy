//
//  VHIDDevice.h
//  VHID
//
//  Created by alxn1 on 17.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VHIDDevice;

@protocol VHIDDeviceDelegate

- (void)VHIDDevice:(VHIDDevice*)device stateChanted:(NSData*)state;

@end

@interface VHIDDevice : NSObject
{
    @private
        NSData                  *m_Descriptor;
        NSMutableData           *m_State;
        id<VHIDDeviceDelegate>   m_Delegate;
}

- (NSData*)descriptor;
- (NSData*)state;

- (void)reset;

- (id<VHIDDeviceDelegate>)delegate;
- (void)setDelegate:(id<VHIDDeviceDelegate>)delegate;

@end
