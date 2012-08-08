//
//  WiimoteAudioSource.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAudioSourceWrapper.h"

@implementation WiimoteAudioSource

+ (WiimoteAudioSource*)sourceFromFile:(NSString*)filePath
{
    return [self sourceFromAVAudioSource:[AVAudioSource sourceFromFile:filePath]];
}

+ (WiimoteAudioSource*)sourceFromAVAudioSource:(AVAudioSource*)source
{
    return [WiimoteAudioSourceWrapper wrap:source];
}

- (NSData*)nextAudioPacket
{
    return nil;
}

- (NSData*)getAllAudioData
{
    NSMutableData   *result = [NSMutableData data];
    NSData          *data;

    while(YES)
    {
        data = [self nextAudioPacket];

        if(data == nil)
            break;

        [result appendData:data];
    }

    return result;
}

@end
