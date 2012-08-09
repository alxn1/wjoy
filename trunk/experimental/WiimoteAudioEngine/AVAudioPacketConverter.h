//
//  AVAudioPacketConverter.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVMutableAudioPacket.h"

#import "avformat.h"
#import "avcodec.h"

@interface AVAudioPacketConverter : NSObject
{
    @private
        AVAudioFormat        *m_InputFormat;
        AVMutableAudioPacket *m_AudioPacket;

        NSUInteger            m_InputSampleSize;
        NSUInteger            m_OutputSampleSize;
        double                m_DataScaleFactor;

        ReSampleContext      *m_Context;
}

+ (enum AVSampleFormat)encodeFFMPEGSampleFormat:(AVAudioSampleFormat)sampleFormat;
+ (NSUInteger)audioSampleSize:(AVAudioSampleFormat)sampleFormat;

- (id)initWithInputAudioFormat:(AVAudioFormat*)inputFormat
             outputAudioFormat:(AVAudioFormat*)outputFormat;

- (AVAudioFormat*)inputFormat;
- (AVAudioFormat*)outputFormat;

- (AVAudioPacket*)convert:(AVAudioPacket*)packet;

@end
