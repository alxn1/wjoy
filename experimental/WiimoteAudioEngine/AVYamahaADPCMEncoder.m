//
//  AVYamahaADPCMEncoder.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVYamahaADPCMEncoder.h"
#import "AVAudioPacketConverter.h"

@implementation AVYamahaADPCMEncoder

- (id)init
{
    [[super init] release];
    return nil;
}

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

    m_InputFormat = [format retain];

    AVCodec *codec = avcodec_find_encoder(CODEC_ID_ADPCM_YAMAHA);
    if(codec == NULL)
    {
        [self release];
        return nil;
    }

    AVCodecContext *context = avcodec_alloc_context();
    if(context == NULL)
    {
        [self release];
        return nil;
    }

    context->sample_fmt     = [AVAudioPacketConverter encodeFFMPEGSampleFormat:[format sampleFormat]];
    context->sample_rate    = [format sampleRate];
    context->channels       = [format channelCount];

    if(avcodec_open(context, codec) < 0)
    {
        av_free(context);
        [self release];
        return nil;
    }

    NSUInteger frameSize = context->frame_size *
                                [AVAudioPacketConverter audioSampleSize:[format sampleFormat]] *
                                [format channelCount];

    m_FrameBuffer           = [[NSMutableData alloc] initWithLength:frameSize];
    m_OutputBuffer          = [[NSMutableData alloc] init];
    m_FrameBufferDataSize   = 0;

    m_Context = context;
    return self;
}

- (void)dealloc
{
    if(m_Context != NULL)
    {
        avcodec_close(m_Context);
        av_free(m_Context);
    }

    [m_FrameBuffer release];
    [m_OutputBuffer release];
    [m_InputFormat release];
    [super dealloc];
}

- (NSString*)name
{
    return @"Yamaha ADPCM";
}

- (AVAudioFormat*)inputFormat
{
    return [[m_InputFormat retain] autorelease];
}

- (BOOL)flushFrameBuffer
{
    [m_OutputBuffer setLength:[m_OutputBuffer length] + FF_MIN_BUFFER_SIZE];
    m_FrameBufferDataSize = 0;

    uint8_t *outputBuffer    = ((uint8_t*)[m_OutputBuffer mutableBytes]) +
                                                [m_OutputBuffer length] -
                                                FF_MIN_BUFFER_SIZE;

    int      encodedDataSize = avcodec_encode_audio(
                                            m_Context,
                                            outputBuffer,
                                            FF_MIN_BUFFER_SIZE,
                                            (short*)[m_FrameBuffer bytes]);

    if(encodedDataSize < 0)
        return NO;

    [m_OutputBuffer setLength:
                        [m_OutputBuffer length] -
                        FF_MIN_BUFFER_SIZE +
                        encodedDataSize];

    return YES;
}

- (NSData*)encodePacket:(AVAudioPacket*)packet
{
    if(packet == nil ||
      ![[packet format] isEqualToAudioFormat:m_InputFormat])
    {
        return nil;
    }

    [m_OutputBuffer setLength:0];

    NSData          *packetData     = [packet data];
    NSUInteger       packetDataSize = [packetData length];
    const uint8_t   *packetDataPtr  = (const uint8_t*)[packetData bytes];
    NSUInteger       dataSizeToCopy;

    while(packetDataSize > 0)
    {
        dataSizeToCopy = ([m_FrameBuffer length] - m_FrameBufferDataSize);

        if(dataSizeToCopy > packetDataSize)
            dataSizeToCopy = packetDataSize;

        memcpy(
            ((uint8_t*)[m_FrameBuffer mutableBytes]) + m_FrameBufferDataSize,
            packetDataPtr,
            dataSizeToCopy);

        m_FrameBufferDataSize   += dataSizeToCopy;
        packetDataPtr           += dataSizeToCopy;
        packetDataSize          -= dataSizeToCopy;

        if([m_FrameBuffer length] == m_FrameBufferDataSize)
            [self flushFrameBuffer];
    }

    return [[m_OutputBuffer retain] autorelease];
}

@end
