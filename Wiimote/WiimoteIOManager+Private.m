//
//  WiimoteIOManager+Private.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteIOManager+Private.h"

@implementation WiimoteIOManager (Private)

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithOwner:(Wiimote*)owner device:(WiimoteDevice*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Owner     = owner;
    m_Device    = device;

    return self;
}

@end
