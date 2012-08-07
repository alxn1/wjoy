//
//  AVAudioFormat.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioFormat.h"

@implementation AVAudioFormat

- (id)initWithSampleRate:(NSUInteger)sampleRate
            channelCount:(NSUInteger)channelCount
            sampleFormat:(AVAudioSampleFormat)sampleFormat
{
    self = [super init];
    if(self == nil)
        return nil;

    m_SampleRate    = sampleRate;
    m_ChannelCount  = channelCount;
    m_SampleFormat  = sampleFormat;

    return self;
}

- (NSUInteger)sampleRate
{
    return m_SampleRate;
}

- (NSUInteger)channelCount
{
    return m_ChannelCount;
}

- (AVAudioSampleFormat)sampleFormat
{
    return m_SampleFormat;
}

- (BOOL)isEqual:(id)object
{
    if(![object isKindOfClass:[self class]])
        return NO;

    AVAudioFormat *fmt = object;

    return (m_SampleRate    == fmt->m_SampleRate &&
            m_ChannelCount  == fmt->m_ChannelCount &&
            m_SampleFormat  == fmt->m_SampleFormat);
}

- (BOOL)isEqualToAudioFormat:(AVAudioFormat*)format
{
    return [self isEqual:format];
}

@end
