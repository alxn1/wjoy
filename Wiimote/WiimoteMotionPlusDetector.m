//
//  WiimoteMotionPlusDetector.m
//  WMouse
//
//  Created by alxn1 on 12.09.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteMotionPlusDetector.h"

#define WiimoteDeviceMotionPlusDetectTriesCount      4
#define WiimoteDeviceMotionPlusLastTryDelay          8.0

@interface WiimoteMotionPlusDetector (PrivatePart)

- (void)initializeMotionPlus;
- (void)beginReadSignature;
- (void)signatureReaded:(NSData*)data;
- (void)detectionFinished:(BOOL)detected;

@end

@implementation WiimoteMotionPlusDetector

+ (NSData*)motionPlusSignature
{ 
    static const uint8_t  signature[]   = { 0x00, 0x00, 0xA6, 0x20, 0x00, 0x05 };
    static NSData        *result        = nil;

    if(result == nil)
        result = [[NSData alloc] initWithBytes:signature length:sizeof(signature)];

    return result;

}

+ (NSRange)motionPlusSignatureMemRange
{
    return NSMakeRange(
                WiimoteDeviceMotionPlusExtensionProbeAddress,
                [[WiimoteMotionPlusDetector motionPlusSignature] length]);
}

+ (void)activateMotionPlus:(WiimoteIOManager*)ioManager
              subExtension:(WiimoteExtension*)subExtension
{
    uint8_t data = WiimoteDeviceMotionPlusModeNormal;

    if(subExtension != nil &&
      [subExtension isSupportMotionPlus])
    {
        data = [subExtension motionPlusMode];
    }

    [ioManager writeMemory:WiimoteDeviceMotionPlusExtensionSetModeAddress
                      data:&data
                    length:sizeof(data)];

    usleep(50000);
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithIOManager:(WiimoteIOManager*)ioManager
                 target:(id)target
                 action:(SEL)action
{
    self = [super init];
    if(self == nil)
        return nil;

    m_IOManager     = [ioManager retain];
    m_Target        = target;
    m_Action        = action;
    m_IsRun         = NO;
    m_CancelCount   = 0;

    return self;
}

- (void)dealloc
{
    [self cancel];
    [m_IOManager release];
    [super dealloc];
}

- (BOOL)isRun
{
    return m_IsRun;
}

- (void)run
{
    if(m_IsRun)
        return;

    m_IsRun = YES;
    m_ReadTryCount = 0;
    [self initializeMotionPlus];
    [self beginReadSignature];
}

- (void)cancel
{
    if(!m_IsRun)
        return;

    m_CancelCount++;
    if(m_LastTryTimer != nil)
    {
        [m_LastTryTimer invalidate];
        m_CancelCount--;
    }

    m_IsRun = NO;
}

@end

@implementation WiimoteMotionPlusDetector (PrivatePart)

- (void)initializeMotionPlus
{
    uint8_t data = WiimoteDeviceMotionPlusExtensionInitOrResetValue;

    [m_IOManager writeMemory:WiimoteDeviceMotionPlusExtensionInitAddress
                        data:&data
                      length:sizeof(data)];

    usleep(50000);
}

- (void)beginReadSignature
{
    m_ReadTryCount++;
    m_LastTryTimer = nil;

    [m_IOManager readMemory:[WiimoteMotionPlusDetector motionPlusSignatureMemRange]
                     target:self
                     action:@selector(signatureReaded:)];

    [self retain];
}

- (void)signatureReaded:(NSData*)data
{
    [self autorelease];

    if(m_CancelCount > 0)
    {
        m_CancelCount--;
        return;
    }

    if(data == nil)
    {
        [self detectionFinished:NO];
        return;
    }

    if([data isEqualToData:[WiimoteMotionPlusDetector motionPlusSignature]])
    {
        [self detectionFinished:YES];
        return;
    }

    if(m_ReadTryCount >= WiimoteDeviceMotionPlusDetectTriesCount)
    {
        [self detectionFinished:NO];
        return;
    }

    if(m_ReadTryCount < (WiimoteDeviceMotionPlusDetectTriesCount - 1))
    {
        usleep(50000);
        [self beginReadSignature];
        return;
    }

    m_LastTryTimer = [NSTimer scheduledTimerWithTimeInterval:WiimoteDeviceMotionPlusLastTryDelay
                                                      target:self
                                                    selector:@selector(beginReadSignature)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void)detectionFinished:(BOOL)detected
{
    m_IsRun = NO;
    [m_Target performSelector:m_Action
                   withObject:[NSNumber numberWithBool:detected]];
}

@end
