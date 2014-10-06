//
//  VHIDDevice+Private.m
//  VHID
//
//  Created by alxn1 on 17.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDDevice+Private.h"

@implementation VHIDDevice (Private)

- (id)initWithDescriptor:(NSData*)descriptor stateSize:(NSUInteger)stateSize
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Descriptor = [descriptor copy];
    m_State      = [[NSMutableData alloc] initWithLength:stateSize];

    return self;
}

- (unsigned char*)mutableStateBytes
{
    return ((unsigned char*)[m_State mutableBytes]);
}

- (void)resetState
{
    memset([m_State mutableBytes], 0, [m_State length]);
}

- (void)notifyAboutStateChanged
{
    [m_Delegate VHIDDevice:self stateChanted:m_State];
}

@end
