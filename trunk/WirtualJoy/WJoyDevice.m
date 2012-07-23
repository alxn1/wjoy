//
//  WJoyDevice.m
//  driver
//
//  Created by alxn1 on 17.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WJoyDevice.h"

#import "WJoyDeviceImpl.h"

@implementation WJoyDevice

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithHIDDescriptor:(NSData*)HIDDescriptor
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Impl = [[WJoyDeviceImpl alloc] init];
    if(m_Impl == nil)
    {
        [self release];
        return nil;
    }

    if(![m_Impl call:WJoyDeviceMethodSelectorEnable data:HIDDescriptor])
    {
        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc
{
    [m_Impl release];
    [super dealloc];
}

- (BOOL)updateHIDState:(NSData*)HIDState
{
    return [m_Impl call:WJoyDeviceMethodSelectorUpdateState data:HIDState];
}

@end
