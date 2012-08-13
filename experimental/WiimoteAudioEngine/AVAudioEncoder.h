//
//  AVAudioEncoder.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <WiimoteAudioEngine/AVAudioPacket.h>

@interface AVAudioEncoder : NSObject
{
}

+ (AVAudioEncoder*)yamahaADPCMEncoderWithAudioFormat:(AVAudioFormat*)format;

- (NSString*)name;
- (AVAudioFormat*)inputFormat;

- (NSData*)encodePacket:(AVAudioPacket*)packet;

@end
