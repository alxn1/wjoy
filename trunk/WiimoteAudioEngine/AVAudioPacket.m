//
//  AVAudioPacket.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioPacket.h"

@implementation AVAudioPacket

- (id)init
{
    [[super init] release];
    return nil;
}

- (AVAudioFormat*)format
{
    return [[m_Format retain] autorelease];
}

- (NSData*)data
{
    return [[m_Data retain] autorelease];
}

@end
