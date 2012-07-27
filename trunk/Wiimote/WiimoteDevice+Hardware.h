//
//  WiimoteDevice+Hardware.h
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"
#import "WiimoteDeviceProtocol.h"

#import <IOBluetooth/IOBluetooth.h>

@interface WiimoteDevice (Hardware)

- (IOBluetoothL2CAPChannel*)openChannel:(BluetoothL2CAPPSM)channelID;

- (void)initialize;

- (BOOL)postCommand:(WiimoteDeviceCommandType)command
               data:(const void*)data
             length:(NSUInteger)length;

- (BOOL)updateLEDStates;
- (BOOL)beginUpdateState;
- (BOOL)enableButtonReport;

@end
