//
//  WiimoteGenericExtension.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteGenericExtension.h"

@implementation WiimoteGenericExtension

+ (NSUInteger)merit
{
    static NSUInteger result = 0;

    if(result == 0)
        result = [WiimoteExtension nextFreedomMeritInClass:[self meritClass]];

    return result;
}

+ (NSData*)extensionSignature
{
    return nil;
}

+ (NSRange)calibrationDataMemoryRange
{
    return NSMakeRange(0, 0);
}

+ (WiimoteExtensionMeritClass)meritClass
{
    return WiimoteExtensionMeritClassUnknown;
}

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action
{
    [WiimoteExtension routineProbe:ioManager
                         signature:[self extensionSignature]
                            target:target
                            action:action];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    return [super initWithOwner:owner eventDispatcher:dispatcher];
}

- (void)initialize:(WiimoteIOManager*)ioManager
            target:(id)target
            action:(SEL)action
{
    [WiimoteExtension routineInit:ioManager
                           target:target
                           action:action];

    NSRange calibrationMemoryRange = [[self class] calibrationDataMemoryRange];

    if(calibrationMemoryRange.length != 0)
    {
        [self beginReadCalibrationData:ioManager
                           memoryRange:calibrationMemoryRange];
    }
}

- (WiimoteEventDispatcher*)eventDispatcher
{
    return [super eventDispatcher];
}

- (void)handleCalibrationData:(NSData*)data
{
}

- (void)handleReport:(NSData*)extensionData
{
}

@end
