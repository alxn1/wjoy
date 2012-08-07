//
//  AVAudioSource.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioPacket.h"

@interface AVAudioSource : NSObject
{
}

+ (AVAudioSource*)sourceWithFile:(NSString*)filePath;

- (AVAudioFormat*)format;
- (AVAudioPacket*)nextPacket;

@end
