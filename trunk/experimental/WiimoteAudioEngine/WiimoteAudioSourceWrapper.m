//
//  WiimoteAudioSourceWrapper.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAudioSourceWrapper.h"

@implementation WiimoteAudioSourceWrapper

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithAudioSource:(AVAudioSource*)source
{
    self = [super init];
    if(self == nil)
        return nil;

    if(source == nil)
    {
        [self release];
        return nil;
    }

    m_Source = [[AVAudioSource
                    convertAudioSourceFormat:source
                                      format:[AVAudioFormat
                                                    audioFormatWithSampleRate:4000
                                                                 channelCount:1
                                                                 sampleFormat:AVAudioSampleFormatSInt16]] retain];

    m_Encoder = [[AVAudioEncoder yamahaADPCMEncoderWithAudioFormat:[m_Source format]] retain];

    if(m_Source  == nil ||
       m_Encoder == nil)
    {
        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc
{
    [m_Source release];
    [m_Encoder release];
    [super dealloc];
}

- (NSData*)nextAudioPacket
{
    NSData *result = nil;

    while(YES)
    {
        result = [m_Encoder encodePacket:[m_Source nextPacket]];

        if(result == nil || [result length] != 0)
           break;
    }

    return result;
}

+ (WiimoteAudioSourceWrapper*)wrap:(AVAudioSource*)source
{
    return [[[WiimoteAudioSourceWrapper alloc] initWithAudioSource:source] autorelease];
}

@end
