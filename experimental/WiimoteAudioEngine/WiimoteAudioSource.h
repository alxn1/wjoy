//
//  WiimoteAudioSource.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioSource.h"

@interface WiimoteAudioSource : NSObject
{
}

+ (WiimoteAudioSource*)sourceFromFile:(NSString*)filePath;
+ (WiimoteAudioSource*)sourceFromAVAudioSource:(AVAudioSource*)source;

- (NSData*)nextAudioPacket; // must be 4000Hz Yamaha ADPCM data

- (NSData*)getAllAudioData; // already implemented

@end
