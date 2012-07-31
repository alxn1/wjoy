//
//  WiimoteIOManager.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteIOManager.h"

#import "Wiimote.h"
#import "WiimoteDevice.h"

@implementation WiimoteIOManager

- (BOOL)postCommand:(WiimoteDeviceCommandType)command
			   data:(NSData*)data
{
    return [m_Device postCommand:command
                            data:data
                  vibrationState:[m_Owner isVibrationEnabled]];
}

- (BOOL)writeMemory:(NSUInteger)address
			   data:(NSData*)data
{
    return [m_Device writeMemory:address
                            data:data
                  vibrationState:[m_Owner isVibrationEnabled]];
}

- (BOOL)readMemory:(NSRange)memoryRange
			target:(id)target
			action:(SEL)action
{
    return [m_Device readMemory:memoryRange
                 vibrationState:[m_Owner isVibrationEnabled]
                         target:target
                         action:action];
}

@end
