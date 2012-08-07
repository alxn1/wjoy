//
//  AVFileAudioSource.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioSource.h"
#import "AVMutableAudioPacket.h"

#import "avformat.h"
#import "avcodec.h"

@interface AVFileAudioSource : AVAudioSource
{
    @private
        AVAudioFormat           *m_Format;
        AVMutableAudioPacket    *m_Packet;
        AVFormatContext         *m_Context;
        NSUInteger               m_AudioStreamIndex;
        AVCodecContext          *m_CodecContext;
}

+ (AVFileAudioSource*)sourceWithFile:(NSString*)filePath;

@end
