//
//  VHIDGameController+Private.m
//  VHID2
//
//  Created by alxn1 on 28.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDGameController+Private.h"

@implementation VHIDGameController (Private)

+ (CGFloat)UInt16ToFloat:(uint16_t)value
{
    CGFloat result = (CGFloat)value;

    result /= (CGFloat)UINT16_MAX;
    result -= 0.5f;
    result *= 2.0f;

    return result;
}

+ (uint16_t)FloatToUInt16:(CGFloat)value
{
    if(value < -1.0f) value = -1.0f;
    if(value >  1.0f) value =  1.0f;

    value /= 2.0f;
    value += 0.5f;
    value *= (CGFloat)UINT16_MAX;

    if(value < 0)           value = 0;
    if(value > UINT16_MAX)  value = UINT16_MAX;

    return (uint16_t)value;
}

- (id)initWithDescriptor:(NSData*)descriptor
               stateSize:(NSUInteger)stateSize
                    axes:(VHIDGameControllerAxisSet)axes
             buttonCount:(NSUInteger)buttonCount
{
    self = [super initWithDescriptor:descriptor
                           stateSize:stateSize];

    if(self == nil)
        return nil;

    m_Axes          = axes;
    m_ButtonCount   = buttonCount;

    return self;
}

@end
