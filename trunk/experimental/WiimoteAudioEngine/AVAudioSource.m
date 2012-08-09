//
//  AVAudioSource.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVFileAudioSource.h"
#import "AVAudioSourceConverter.h"

@implementation AVAudioSource

+ (AVAudioSource*)sourceFromFile:(NSString*)filePath
{
    return [AVFileAudioSource sourceFromFile:filePath];
}

+ (AVAudioSource*)sourceFromFile:(NSString*)filePath format:(AVAudioFormat*)format
{
    return [AVAudioSourceConverter
                        wrapAudioSource:[AVFileAudioSource sourceFromFile:filePath]
                                 format:format];
}

+ (AVAudioSource*)convertAudioSourceFormat:(AVAudioSource*)audioSource format:(AVAudioFormat*)format
{
    if(audioSource == nil || format == nil)
        return nil;

    if([[audioSource format] isEqualToAudioFormat:format])
        return audioSource;

    return [AVAudioSourceConverter wrapAudioSource:audioSource format:format];
}

- (AVAudioFormat*)format
{
    return nil;
}

- (AVAudioPacket*)nextPacket
{
    return nil;
}

@end
