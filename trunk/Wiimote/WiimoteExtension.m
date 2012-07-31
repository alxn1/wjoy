//
//  WiimoteExtension.m
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtension.h"

@implementation WiimoteExtension

- (Wiimote*)owner
{
	return [[m_Owner retain] autorelease];
}

- (NSString*)name
{
    return @"Unknown";
}

@end
