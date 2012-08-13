//
//  AVAudioSource.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <WiimoteAudioEngine/AVAudioPacket.h>

@interface AVAudioSource : NSObject
{
}

+ (AVAudioSource*)sourceFromFile:(NSString*)filePath;
+ (AVAudioSource*)sourceFromFile:(NSString*)filePath format:(AVAudioFormat*)format;

+ (AVAudioSource*)convertAudioSourceFormat:(AVAudioSource*)audioSource format:(AVAudioFormat*)format;

- (AVAudioFormat*)format;
- (AVAudioPacket*)nextPacket;

@end
