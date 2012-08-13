//
//  AVAudioPacket.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <WiimoteAudioEngine/AVAudioFormat.h>

@interface AVAudioPacket : NSObject
{
    @protected
        AVAudioFormat   *m_Format;
        NSMutableData   *m_Data;
}

- (AVAudioFormat*)format;
- (NSData*)data;

@end
