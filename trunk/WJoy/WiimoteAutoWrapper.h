//
//  WiimoteAutoWrapper.h
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"
#import "WJoyDevice.h"
#import "VHIDDevice.h"

@interface WiimoteAutoWrapper : NSObject<
                                    WiimoteDeviceDelegate,
                                    VHIDDeviceDelegate>
                                    
{
    @private
        WiimoteDevice   *m_Device;
        VHIDDevice      *m_HIDState;
        WJoyDevice      *m_WJoy;
}

// 0 = infinite, default = infinite, if currently connected too many, disconnect last connected
+ (NSUInteger)maxConnectedDevices;
+ (void)setMaxConnectedDevices:(NSUInteger)count;

+ (void)start;

@end
