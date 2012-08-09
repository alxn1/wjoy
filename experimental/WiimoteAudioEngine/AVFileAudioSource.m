//
//  AVFileAudioSource.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVFileAudioSource.h"

@interface AVFileAudioSource (PrivatePart)

- (id)initWithFilePath:(NSString*)filePath;

- (BOOL)decodeNextPacket;

@end

@implementation AVFileAudioSource

+ (AVFileAudioSource*)sourceFromFile:(NSString*)filePath
{
    return [[[AVFileAudioSource alloc] initWithFilePath:filePath] autorelease];
}

- (AVAudioFormat*)format
{
    return [[m_Format retain] autorelease];
}

- (AVAudioPacket*)nextPacket
{
    if(![self decodeNextPacket])
        return nil;

    return [[m_Packet retain] autorelease];
}

@end

@implementation AVFileAudioSource (PrivatePart)

- (AVFormatContext*)openFileAtPath:(NSString*)filePath
{
    AVFormatContext *result = NULL;

    if(av_open_input_file(
                    &result,
                     [filePath fileSystemRepresentation],
                     NULL,
                     0,
                     NULL) != 0)
    {
        return NULL;
    }

    if(av_find_stream_info(result) < 0)
    {
        av_close_input_file(result);
        return NULL;
    }

    return result;
}

- (AVCodecContext*)findAudioStream:(AVFormatContext*)context index:(NSUInteger*)index
{
    for(NSInteger i = 0; i < context->nb_streams; i++)
    {
        if(context->streams[i]->codec->codec_type == CODEC_TYPE_AUDIO)
        {
            if(index != NULL)
                *index = i;

            return context->streams[i]->codec;
        }
    }

    return NULL;
}

- (BOOL)openAudioStream:(AVCodecContext*)context
{
    AVCodec *codec = avcodec_find_decoder(context->codec_id);

    if(codec == NULL)
        return NO;

    if((codec->capabilities & CODEC_CAP_TRUNCATED) != 0)
        context->flags |= CODEC_FLAG_TRUNCATED;

    return (avcodec_open(context, codec) >= 0);
}

- (AVFormatContext*)openFile:(NSString*)filePath
                codecContext:(AVCodecContext**)resultCodecContext
                 streamIndex:(NSUInteger*)index
{
    AVFormatContext *context = [self openFileAtPath:filePath];

    if(context == NULL)
        return NULL;

    AVCodecContext *codecContext = [self findAudioStream:context index:index];
    if(codecContext == NULL)
    {
        av_close_input_file(context);
        return NULL;
    }

    if(![self openAudioStream:codecContext])
    {
        av_close_input_file(context);
        return NULL;
    }

    if(resultCodecContext != NULL)
        *resultCodecContext = codecContext;

    return context;
}

- (void)closeFile
{
    if(m_CodecContext != NULL)
        avcodec_close(m_CodecContext);

    if(m_Context != NULL)
        av_close_input_file(m_Context);

    m_CodecContext  = NULL;
    m_Context       = NULL;
}

- (AVAudioSampleFormat)decodeFFMPEGSampleFormat:(enum AVSampleFormat)sampleFormat
{
    switch(sampleFormat)
    {
        case AV_SAMPLE_FMT_U8:
            return AVAudioSampleFormatUInt8;

        case AV_SAMPLE_FMT_S32:
            return AVAudioSampleFormatSInt32;

        case AV_SAMPLE_FMT_FLT:
            return AVAudioSampleFormatFloat32;

        case AV_SAMPLE_FMT_DBL:
            return AVAudioSampleFormatFloat64;
    }

    return AVAudioSampleFormatSInt16;
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithFilePath:(NSString*)filePath
{
    self = [super init];
    if(self == nil)
        return nil;

    if(filePath == nil)
    {
        [self release];
        return nil;
    }

    m_Context = [self openFile:filePath
                  codecContext:&m_CodecContext
                   streamIndex:&m_AudioStreamIndex];

    if(m_Context == NULL)
    {
        [self release];
        return nil;
    }

    m_Format    = [[AVAudioFormat alloc]
                                initWithSampleRate:m_CodecContext->sample_rate
                                      channelCount:m_CodecContext->channels
                                      sampleFormat:[self decodeFFMPEGSampleFormat:m_CodecContext->sample_fmt]];

    m_Packet    = [[AVMutableAudioPacket alloc] initWithAudioFormat:m_Format];

    return self;
}

- (void)dealloc
{
    [m_Packet release];
    [m_Format release];
    [self closeFile];
    [super dealloc];
}

- (BOOL)readAVPacket:(AVPacket*)packet
{
    BOOL result = NO;

    while(YES)
    {
        if(av_read_frame(m_Context, packet) < 0)
            break;

        if(packet->stream_index == m_AudioStreamIndex)
        {
            result = YES;
            break;
        }

        av_free_packet(packet);
    }

    return result;
}

- (BOOL)decodeNextPacket
{
    [[m_Packet mutableData] setLength:AVCODEC_MAX_AUDIO_FRAME_SIZE];

    uint8_t     *data               = [[m_Packet mutableData] mutableBytes];
    NSUInteger   dataSize           = [[m_Packet mutableData] length];
    NSUInteger   decodedDataSize    = 0;
    BOOL         hasError           = NO;

    AVPacket     packet;
    AVPacket     decodePacket;

    int          frameSize;
    int          readedDataSize;

    while(!hasError)
    {
        if(![self readAVPacket:&packet])
            break;

        decodePacket = packet;
        while(decodePacket.size != 0)
        {
            frameSize = dataSize - decodedDataSize;
            if(frameSize <= 0)
            {
                hasError = YES;
                break;
            }

            readedDataSize  = avcodec_decode_audio3(
                                             m_CodecContext,
                                             (int16_t*)(data + decodedDataSize),
                                            &frameSize,
                                            &decodePacket);

            if(readedDataSize < 0)
            {
                hasError = YES;
                break;
            }

            decodePacket.data   += readedDataSize;
            decodePacket.size   -= readedDataSize;
            decodedDataSize     += frameSize;
        }

        av_free_packet(&packet);

        if(decodedDataSize != 0)
            break;
    }

    [[m_Packet mutableData] setLength:decodedDataSize];
    return (decodedDataSize != 0);
}

@end
