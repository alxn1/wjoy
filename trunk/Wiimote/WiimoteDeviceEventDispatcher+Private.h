//
//  WiimoteDeviceEventDispatcher+Private.h
//  Wiimote
//
//  Created by alxn1 on 03.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceEventDispatcher.h"

@interface WiimoteDeviceEventDispatcher (Private)

- (void)handleReport:(WiimoteDeviceReport*)report;
- (void)handleDisconnect;

@end
