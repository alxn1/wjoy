//
//  VHIDGameController+Private.h
//  VHID2
//
//  Created by alxn1 on 28.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDGameController.h"

#import "VHIDDevice+Private.h"

@interface VHIDGameController (Private)

+ (CGFloat)UInt16ToFloat:(uint16_t)value;
+ (uint16_t)FloatToUInt16:(CGFloat)value;

- (id)initWithDescriptor:(NSData*)descriptor
               stateSize:(NSUInteger)stateSize
                    axes:(VHIDGameControllerAxisSet)axes
             buttonCount:(NSUInteger)buttonCount;

@end
