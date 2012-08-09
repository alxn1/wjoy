//
//  AVAudioSourceConverter.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioSourceConverter.h"

@implementation AVAudioSourceConverter

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithAudioSource:(AVAudioSource*)source format:(AVAudioFormat*)format
{
    self = [super init];
    if(self == nil)
        return nil;

    if(source == nil || format == nil)
    {
        [self release];
        return nil;
    }

    m_Source = [source retain];
    if(![[m_Source format] isEqualToAudioFormat:format])
    {
        m_Converter = [[AVAudioPacketConverter alloc]
                                        initWithInputAudioFormat:[source format]
                                               outputAudioFormat:format];

        if(m_Converter == nil)
        {
            [self release];
            return nil;
        }
    }

    return self;
}

- (void)dealloc
{
    [m_Converter release];
    [m_Source release];
    [super dealloc];
}

- (AVAudioFormat*)format
{
    if(m_Converter == nil)
        return [m_Source format];

    return [m_Converter outputFormat];
}

- (AVAudioPacket*)nextPacket
{
    AVAudioPacket *packet = [m_Source nextPacket];

    if(packet       == nil ||
       m_Converter  == nil)
    {
        return packet;
    }

    return [m_Converter convert:packet];
}

+ (AVAudioSourceConverter*)wrapAudioSource:(AVAudioSource*)source
                                    format:(AVAudioFormat*)format
{
    return [[[AVAudioSourceConverter alloc]
                                initWithAudioSource:source
                                             format:format] autorelease];
}

@end
