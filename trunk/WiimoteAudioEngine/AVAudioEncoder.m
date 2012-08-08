//
//  AVAudioEncoder.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "AVYamahaADPCMEncoder.h"

@implementation AVAudioEncoder

+ (AVAudioEncoder*)yamahaADPCMEncoderWithAudioFormat:(AVAudioFormat*)format
{
    return [[[AVYamahaADPCMEncoder alloc] initWithAudioFormat:format] autorelease];
}

- (NSString*)name
{
    return nil;
}

- (AVAudioFormat*)inputFormat
{
    return nil;
}

- (NSData*)encodePacket:(AVAudioPacket*)packet
{
    return nil;
}

@end
