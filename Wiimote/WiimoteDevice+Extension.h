//
//  WiimoteDevice+Extension.h
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"

@interface WiimoteDevice (Extension)

- (void)createExtensionDevice;
- (void)releaseExtensionDevice;

- (void)processReadedData:(const unsigned char*)data length:(NSUInteger)length;

@end
