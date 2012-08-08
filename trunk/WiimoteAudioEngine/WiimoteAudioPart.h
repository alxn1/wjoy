//
//  WiimoteAudioPart.h
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote+PlugIn.h"
#import "WiimoteAudioSource.h"

@interface WiimoteAudioPart : WiimotePart
{
}

- (BOOL)playAudio:(WiimoteAudioSource*)audioSource volume:(double)volume;

@end
