//
//  AVMutableAudioPacket.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <WiimoteAudioEngine/AVAudioPacket.h>

@interface AVMutableAudioPacket : AVAudioPacket
{
}

- (id)initWithAudioFormat:(AVAudioFormat*)format;

- (NSMutableData*)mutableData;

@end
