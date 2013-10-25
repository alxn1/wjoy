//
//  WiimoteGenericExtension.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteGenericExtension.h"
#import "WiimoteExtensionProbeHandler.h"

@implementation WiimoteGenericExtension

+ (NSUInteger)merit
{
    static NSMutableDictionary *results = nil;

    if(results == nil)
        results = [[NSMutableDictionary alloc] init];

    NSNumber *merit = [results objectForKey:[self class]];
    if(merit == nil)
    {
        merit = [NSNumber numberWithInteger:
                    [WiimoteExtension nextFreedomMeritInClass:[self meritClass]]];

        [results setObject:merit forKey:(id)[self class]];
    }

    return [merit integerValue];
}

+ (NSData*)extensionSignature
{
    return nil;
}

+ (NSArray*)extensionSignatures
{
    NSData *signature = [self extensionSignature];

    if(signature == nil)
        return nil;

    return [NSArray arrayWithObject:signature];
}

+ (NSRange)calibrationDataMemoryRange
{
    return NSMakeRange(0, 0);
}

+ (WiimoteExtensionMeritClass)meritClass
{
    return WiimoteExtensionMeritClassUnknown;
}

+ (NSUInteger)minReportDataSize
{
    return 0;
}

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action
{
    [WiimoteExtensionProbeHandler
                            routineProbe:ioManager
                              signatures:[self extensionSignatures]
                                  target:target
                                  action:action];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    return [super initWithOwner:owner eventDispatcher:dispatcher];
}

- (void)calibrate:(WiimoteIOManager*)ioManager
{
    NSRange calibrationMemoryRange = [[self class] calibrationDataMemoryRange];

    if(calibrationMemoryRange.length != 0)
    {
        [self beginReadCalibrationData:ioManager
                           memoryRange:calibrationMemoryRange];
    }
}

- (BOOL)isSupportMotionPlus
{
    return [super isSupportMotionPlus];
}

- (WiimoteDeviceMotionPlusMode)motionPlusMode
{
    return [super motionPlusMode];
}

- (void)handleCalibrationData:(const uint8_t*)data length:(NSUInteger)length
{
}

- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length
{
}

- (void)handleMotionPlusReport:(const uint8_t*)extensionData
                        length:(NSUInteger)length
{
}

- (void)disconnected
{
}

@end
