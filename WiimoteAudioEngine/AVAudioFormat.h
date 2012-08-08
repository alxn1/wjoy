//
//  AVAudioFormat.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    AVAudioSampleFormatUInt8,
    AVAudioSampleFormatSInt16,
    AVAudioSampleFormatSInt32,
    AVAudioSampleFormatFloat32,
    AVAudioSampleFormatFloat64
} AVAudioSampleFormat;

@interface AVAudioFormat : NSObject
{
    @private
        NSUInteger          m_SampleRate;
        NSUInteger          m_ChannelCount;
        AVAudioSampleFormat m_SampleFormat;
}

+ (AVAudioFormat*)audioFormatWithSampleRate:(NSUInteger)sampleRate
                               channelCount:(NSUInteger)channelCount
                               sampleFormat:(AVAudioSampleFormat)sampleFormat;

- (id)initWithSampleRate:(NSUInteger)sampleRate
            channelCount:(NSUInteger)channelCount
            sampleFormat:(AVAudioSampleFormat)sampleFormat;

- (NSUInteger)sampleRate;
- (NSUInteger)channelCount;
- (AVAudioSampleFormat)sampleFormat;

- (BOOL)isEqualToAudioFormat:(AVAudioFormat*)format;

@end
