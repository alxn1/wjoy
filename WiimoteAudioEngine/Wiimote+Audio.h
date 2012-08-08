//
//  Wiimote+Audio.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote.h"
#import "WiimoteAudioSource.h"

@interface Wiimote (Audio)

- (BOOL)playAudio:(WiimoteAudioSource*)audioSource volume:(double)volume;
- (BOOL)playAudioFile:(NSString*)filePath volume:(double)volume;

@end
