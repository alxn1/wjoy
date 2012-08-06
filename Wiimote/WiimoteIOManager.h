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
			   data:(const uint8_t*)data
             length:(NSUInteger)length;

- (BOOL)writeMemory:(NSUInteger)address
			   data:(const uint8_t*)data
             length:(NSUInteger)length;

- (BOOL)readMemory:(NSRange)memoryRange
			target:(id)target
			action:(SEL)action;

- (BOOL)injectReport:(NSUInteger)type
                data:(const uint8_t*)data
              length:(NSUInteger)length;

- (Wiimote*)owner;

@end

/*

WiimoteIOManager can be used for interact with read hardware. You can read
data from wiimote, write data to it, and post command to wiimote.

In addition, you can inject some data as report, what readed from wiimote real
hardware, and all wiimote parts and extension get this report for processing.

Method

- (BOOL)readMemory:(NSRange)memoryRange
			target:(id)target
			action:(SEL)action;

is asynchonous. It start read some memory, and on complete it call action method
on target. If wiimote disconnected before completion read operation, action called
with nil parameter. If read complete with error - with NSData with zero length.
If all data readed successfully, NSData in parameter will be contain readed data.
*/
