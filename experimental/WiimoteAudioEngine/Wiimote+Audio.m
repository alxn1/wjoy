//
//  Wiimote+Audio.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote+Audio.h"
#import "WiimoteAudioPart.h"

@implementation Wiimote (Audio)

- (BOOL)playAudioData:(NSData*)data volume:(double)volume
{
    return [(WiimoteAudioPart*)
                [self partWithClass:[WiimoteAudioPart class]]
                                                        playAudioData:data
                                                               volume:volume];
}

- (BOOL)playAudio:(WiimoteAudioSource*)audioSource volume:(double)volume
{
    return [(WiimoteAudioPart*)
                [self partWithClass:[WiimoteAudioPart class]]
                                                        playAudio:audioSource
                                                           volume:volume];
}

- (BOOL)playAudioFile:(NSString*)filePath volume:(double)volume
{
    return [self playAudio:[WiimoteAudioSource sourceFromFile:filePath]
                    volume:volume];
}

@end
