//
//  VHIDDevice+Private.h
//  VHID
//
//  Created by alxn1 on 17.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDDevice.h"

@interface VHIDDevice (Private)

- (id)initWithDescriptor:(NSData*)descriptor stateSize:(NSUInteger)stateSize;

- (unsigned char*)mutableStateBytes;

- (void)resetState;
- (void)notifyAboutStateChanged;

@end
