//
//  WiimoteIRPoint+Private.m
//  Wiimote
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteIRPoint+Private.h"

@implementation WiimoteIRPoint (Private)

+ (WiimoteIRPoint*)pointWithOwner:(Wiimote*)owner index:(NSUInteger)index
{
    return [[[WiimoteIRPoint alloc] initWithOwner:owner index:index] autorelease];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithOwner:(Wiimote*)owner index:(NSUInteger)index
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Owner         = owner;
    m_Position      = NSZeroPoint;
    m_IsOutOfView   = YES;
    m_Index         = index;

    return self;
}

- (void)setPosition:(NSPoint)position
{
    m_Position = position;
}

- (void)setOutOfView:(BOOL)outOfView
{
    m_IsOutOfView = outOfView;
}

@end
