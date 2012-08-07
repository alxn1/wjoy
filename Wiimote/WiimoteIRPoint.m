//
//  WiimoteIRPoint.m
//  Wiimote
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteIRPoint.h"

@implementation WiimoteIRPoint

- (NSUInteger)index
{
    return m_Index;
}

- (BOOL)isOutOfView
{
    return m_IsOutOfView;
}

- (NSPoint)position
{
    return m_Position;
}

- (Wiimote*)owner
{
    return m_Owner;
}

@end
