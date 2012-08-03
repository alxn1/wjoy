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
                            data:data];
}

- (BOOL)writeMemory:(NSUInteger)address
			   data:(NSData*)data
{
    return [m_Device writeMemory:address
                            data:data];
}

- (BOOL)readMemory:(NSRange)memoryRange
			target:(id)target
			action:(SEL)action
{
    return [m_Device readMemory:memoryRange
                         target:target
                         action:action];
}

- (BOOL)injectReport:(NSUInteger)type
                data:(NSData*)data
{
    return [m_Device injectReport:type data:data];
}

- (Wiimote*)owner
{
	return m_Owner;
}

@end
