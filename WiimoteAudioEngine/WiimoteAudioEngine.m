//
//  WiimoteAudioEngine.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAudioEngine.h"
#import "AVAudioSource.h"

#import "avformat.h"

@implementation WiimoteAudioEngine

+ (void)load
{
    av_register_all();

#ifdef DEBUG
    av_log_set_level(AV_LOG_DEBUG);
#else
    av_log_set_level(AV_LOG_QUIET);
#endif
}

+ (void)test
{
    // http://cekirdek.pardus.org.tr/~ismail/ffmpeg-docs/api-example_8c-source.html

    AVAudioSource *source = [AVAudioSource sourceWithFile:@"/Users/alxn1/Desktop/test.mp3"];
    while(YES)
    {
        id packet = [source nextPacket];

        if(packet == nil)
            break;

        NSLog(@"%@, %li", packet, [[packet data] length]);
    }
}

@end
