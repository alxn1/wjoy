//
//  AVYamahaADPCMEncoder.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioEncoder.h"

#import "avcodec.h"

@interface AVYamahaADPCMEncoder : AVAudioEncoder
{
    @private
        AVAudioFormat   *m_InputFormat;

        NSMutableData   *m_FrameBuffer;
        NSMutableData   *m_OutputBuffer;
        NSUInteger       m_FrameBufferDataSize;

        AVCodecContext  *m_Context;
}

- (id)initWithAudioFormat:(AVAudioFormat*)format;

@end
