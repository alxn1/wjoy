//
//  WiimoteAutoWrapper.h
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/Wiimote.h>
#import <WirtualJoy/WJoyDevice.h>
#import <VHID/VHIDDevice.h>

@interface WiimoteAutoWrapper : NSObject<
                                    VHIDDeviceDelegate>
                                    
{
    @private
        Wiimote         *m_Device;
        VHIDDevice      *m_HIDState;
		NSPoint			 m_ShiftsState;
        WJoyDevice      *m_WJoy;
}

// 0 = infinite, default = infinite, if currently connected too many, disconnect last connected
+ (NSUInteger)maxConnectedDevices;
+ (void)setMaxConnectedDevices:(NSUInteger)count;

+ (void)start;

@end
