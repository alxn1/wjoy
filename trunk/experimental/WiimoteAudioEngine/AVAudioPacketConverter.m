//
//  AVAudioPacketConverter.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioPacketConverter.h"

@implementation AVAudioPacketConverter

+ (void)load
{
    av_log_set_level(AV_LOG_QUIET);
    av_register_all();
}

+ (enum AVSampleFormat)encodeFFMPEGSampleFormat:(AVAudioSampleFormat)sampleFormat
{
    switch(sampleFormat)
    {
        case AVAudioSampleFormatUInt8:
            return AV_SAMPLE_FMT_U8;

        case AVAudioSampleFormatSInt32:
            return AV_SAMPLE_FMT_S32;

        case AVAudioSampleFormatFloat32:
            return AV_SAMPLE_FMT_FLT;

        case AVAudioSampleFormatFloat64:
            return AV_SAMPLE_FMT_DBL;
    }

    return AVAudioSampleFormatSInt16;
}

+ (NSUInteger)audioSampleSize:(AVAudioSampleFormat)sampleFormat
{
    switch(sampleFormat)
    {
        case AVAudioSampleFormatUInt8:
            return sizeof(uint8_t);

        case AVAudioSampleFormatSInt32:
            return sizeof(uint32_t);

        case AVAudioSampleFormatFloat32:
            return sizeof(float);

        case AVAudioSampleFormatFloat64:
            return sizeof(double);
    }

    return sizeof(uint16_t);
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithInputAudioFormat:(AVAudioFormat*)inputFormat
             outputAudioFormat:(AVAudioFormat*)outputFormat;
{
    self = [super init];
    if(self == nil)
        return nil;

    if(inputFormat  == nil ||
       outputFormat == nil ||
      [inputFormat isEqualToAudioFormat:outputFormat])
    {
        [self release];
        return nil;
    }

    m_InputFormat       = [inputFormat retain];
    m_AudioPacket       = [[AVMutableAudioPacket alloc] initWithAudioFormat:outputFormat];
    m_InputSampleSize   = [AVAudioPacketConverter audioSampleSize:[inputFormat sampleFormat]] * [inputFormat channelCount];
    m_OutputSampleSize  = [AVAudioPacketConverter audioSampleSize:[outputFormat sampleFormat]] * [outputFormat channelCount];
    m_DataScaleFactor   = ((double)(m_OutputSampleSize * [outputFormat sampleRate])) /
                          ((double)(m_InputSampleSize * [inputFormat sampleRate]));

    m_Context = av_audio_resample_init(
                                [outputFormat channelCount],
                                [inputFormat channelCount],
                                [outputFormat sampleRate],
                                [inputFormat sampleRate],
                                [AVAudioPacketConverter encodeFFMPEGSampleFormat:[outputFormat sampleFormat]],
                                [AVAudioPacketConverter encodeFFMPEGSampleFormat:[inputFormat sampleFormat]],
                                16, 10, 0, 0.8);

    if(m_Context == NULL)
    {
        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc
{
    if(m_Context != NULL)
        audio_resample_close(m_Context);

    [m_AudioPacket release];
    [m_InputFormat release];
    [super dealloc];
}

- (AVAudioFormat*)inputFormat
{
    return [[m_InputFormat retain] autorelease];
}

- (AVAudioFormat*)outputFormat
{
    return [m_AudioPacket format];
}

- (AVAudioPacket*)convert:(AVAudioPacket*)packet
{
    if(packet == nil || ![[packet format] isEqualToAudioFormat:m_InputFormat])
        return nil;

    NSData          *inputData          = [packet data];
    NSMutableData   *outputData         = [m_AudioPacket mutableData];
    NSUInteger       inputDataLength    = [inputData length];

    if((inputDataLength % m_InputSampleSize) != 0)
        return nil;

    if(inputDataLength == 0)
    {
        [outputData setLength:0];
        return [[m_AudioPacket retain] autorelease];
    }

    NSUInteger sampleCount      = inputDataLength / m_InputSampleSize;
    NSUInteger outputBufferSize = (((double)inputDataLength) * m_DataScaleFactor) + 1024.0;

    [outputData setLength:outputBufferSize];

    int resultSampleCount = audio_resample(
                                    m_Context,
                                    (short*)[outputData mutableBytes],
                                    (short*)[inputData bytes],
                                    sampleCount);

    if(resultSampleCount < 0)
        return nil;

    [outputData setLength:resultSampleCount * m_OutputSampleSize];
    return [[m_AudioPacket retain] autorelease];
}

@end
