//
//  WiimoteDeviceTransport.h
//  Wiimote
//
//  Created by alxn1 on 10.07.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WiimoteDeviceTransport;
@class HIDDevice;
@class IOBluetoothDevice;

@interface NSObject (WiimoteDeviceTransportDelegate)

- (void)wiimoteDeviceTransport:(WiimoteDeviceTransport*)transport
            reportDataReceived:(const uint8_t*)bytes
                        length:(NSUInteger)length;

- (void)wiimoteDeviceTransportDisconnected:(WiimoteDeviceTransport*)transport;

@end

@interface WiimoteDeviceTransport : NSObject
{
    @private
        id m_Delegate;
}

+ (WiimoteDeviceTransport*)withHIDDevice:(HIDDevice*)device;
+ (WiimoteDeviceTransport*)withBluetoothDevice:(IOBluetoothDevice*)device;

- (NSString*)name;
- (NSData*)address;
- (NSString*)addressString;

- (id)lowLevelDevice;

- (BOOL)isOpen;
- (BOOL)open;
- (void)close;

- (BOOL)postBytes:(const uint8_t*)bytes length:(NSUInteger)length;

- (id)delegate;
- (void)setDelegate:(id)delegate;

@end
