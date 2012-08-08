//
//  WiimoteAudioPart.m
//  WiimoteAudioEngine
//
//  Created by alxn1 on 08.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteAudioPart.h"
#import <sys/time.h>

@implementation WiimoteAudioPart

+ (void)load
{
    [WiimotePart registerPartClass:[self class]];
}

- (void)enableHardwareWithVolume:(double)volume
{
    // TODO: magic :)

    if(volume < 0.0) volume = 0.0;
    if(volume > 1.0) volume = 1.0;

    uint8_t     adpcmFormatCode     = 0x00;
    uint16_t    sampleRateCode      = OSSwapHostToLittleConstInt16(6000000 / 4000);
    uint8_t     volumeCode          = (uint8_t)(volume * 0x40);

    uint8_t     setupData[7]        = { 0 };

    setupData[0]    = 0x00;
    setupData[1]    = adpcmFormatCode;
    setupData[4]    = volumeCode;
    setupData[5]    = 0x00;
    setupData[6]    = 0x00;
    memcpy(setupData + 2, &sampleRateCode, sizeof(sampleRateCode));

    uint8_t data = 0x04;
    [[self ioManager] postCommand:WiimoteDeviceCommandTypeEnableSpeaker data:&data length:sizeof(data)];
    usleep(50000);

    [[self ioManager] postCommand:WiimoteDeviceCommandTypeMuteSpeaker data:&data length:sizeof(data)];
    usleep(50000);

    data = 0x01;
    [[self ioManager] writeMemory:0x04A20009 data:&data length:sizeof(data)];
    usleep(50000);

    data = 0x08;
    [[self ioManager] writeMemory:0x04A20001 data:&data length:sizeof(data)];
    usleep(50000);

    [[self ioManager] writeMemory:0x04A20001 data:setupData length:sizeof(setupData)];
    usleep(50000);

    data = 0x01;
    [[self ioManager] writeMemory:0x04A20008 data:&data length:sizeof(data)];
    usleep(50000);

    data = 0;
    [[self ioManager] postCommand:WiimoteDeviceCommandTypeMuteSpeaker data:&data length:sizeof(data)];
}

- (NSInteger)currentTime
{
	struct timeval time;
	gettimeofday(&time, NULL);
	return ((time.tv_sec * 1000000) + (time.tv_usec));
}

- (BOOL)postAudioData:(const uint8_t*)data length:(NSUInteger)length
{
    NSUInteger  chunkLength;
    uint8_t     buffer[21];
	NSInteger	startTime;

    while(length > 0)
    {
		startTime	= [self currentTime];
        chunkLength = length;

        if(chunkLength > (sizeof(buffer) - 1))
            chunkLength = sizeof(buffer) - 1;

        buffer[0] = chunkLength << 3;
        memcpy(buffer + 1, data, chunkLength);

        if(![[self ioManager]
                    postCommand:WiimoteDeviceCommandTypeSpeakerData
                           data:buffer
                         length:sizeof(buffer)])
        {
            return NO;
        }

        data    += chunkLength;
        length  -= chunkLength;

		NSInteger delay = [self currentTime] - startTime;
		if(delay >= 0 && delay < 10000)
			usleep(10000 - delay);
    }

    return YES;
}

- (void)disableHardware
{
    uint8_t data = 0x00;
    [[self ioManager] postCommand:WiimoteDeviceCommandTypeEnableSpeaker data:&data length:sizeof(data)];
    usleep(50000);
}

- (BOOL)playAudio:(WiimoteAudioSource*)audioSource volume:(double)volume
{
    if(![[self owner] isConnected] || audioSource == nil)
        return NO;

    NSData *data = [audioSource getAllAudioData];

    if(data == nil || [data length] == 0)
        return NO;

    [self enableHardwareWithVolume:volume];

    BOOL result = [self postAudioData:(const uint8_t*)[data bytes]
                               length:[data length]];

    [self disableHardware];
    return result;
}

@end
