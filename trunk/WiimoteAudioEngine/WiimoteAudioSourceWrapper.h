//
//  WiimoteAudioSourceWrapper.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAudioSource.h"
#import "AVAudioEncoder.h"

@interface WiimoteAudioSourceWrapper : WiimoteAudioSource
{
    @private
        AVAudioSource   *m_Source;
        AVAudioEncoder  *m_Encoder;
}

+ (WiimoteAudioSourceWrapper*)wrap:(AVAudioSource*)source;

@end
