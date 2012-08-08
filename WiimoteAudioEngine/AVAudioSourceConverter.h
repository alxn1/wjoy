//
//  AVAudioSourceConverter.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVAudioSource.h"
#import "AVAudioPacketConverter.h"

@interface AVAudioSourceConverter : AVAudioSource
{
    @private
        AVAudioSource           *m_Source;
        AVAudioPacketConverter  *m_Converter;
}

+ (AVAudioSourceConverter*)wrapAudioSource:(AVAudioSource*)source
                                    format:(AVAudioFormat*)format;

@end
