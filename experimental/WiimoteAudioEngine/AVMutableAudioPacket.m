//
//  AVMutableAudioPacket.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVMutableAudioPacket.h"

@interface AVAudioPacket (PrivatePart)

- (id)initWithAudioFormat:(AVAudioFormat*)format;

@end

@implementation AVMutableAudioPacket

- (id)initWithAudioFormat:(AVAudioFormat*)format
{
    return [super initWithAudioFormat:format];
}

- (NSMutableData*)mutableData
{
    return [[m_Data retain] autorelease];
}

@end

@implementation AVAudioPacket (PrivatePart)

- (id)initWithAudioFormat:(AVAudioFormat*)format
{
    self = [super init];
    if(self == nil)
        return nil;

    if(format == nil)
    {
        [self release];
        return nil;
    }

    m_Format = [format retain];
    m_Data   = [[NSMutableData alloc] init];

    return self;
}

- (void)dealloc
{
    [m_Format release];
    [m_Data release];
    [super dealloc];
}

@end
