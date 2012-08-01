//
//  WiimoteIOManager.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteProtocol.h"

@class Wiimote;
@class WiimoteDevice;

@interface WiimoteIOManager : NSObject
{
    @private
        Wiimote         *m_Owner;
        WiimoteDevice   *m_Device;
}

- (BOOL)postCommand:(WiimoteDeviceCommandType)command
			   data:(NSData*)data;

- (BOOL)writeMemory:(NSUInteger)address
			   data:(NSData*)data;

- (BOOL)readMemory:(NSRange)memoryRange
			target:(id)target
			action:(SEL)action;

- (BOOL)injectReport:(NSUInteger)type
                data:(NSData*)data;

@end
