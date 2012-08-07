//
//  AVAudioSource.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVFileAudioSource.h"

@implementation AVAudioSource

+ (AVAudioSource*)sourceWithFile:(NSString*)filePath
{
    return [AVFileAudioSource sourceWithFile:filePath];
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
