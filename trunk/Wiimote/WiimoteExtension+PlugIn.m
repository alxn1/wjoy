//
//  WiimoteExtension+PlugIn.m
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtension+PlugIn.h"

#import "Wiimote.h"
#import "WiimoteExtensionPart.h"
#import "WiimoteExtensionProbeHandler.h"

@implementation WiimoteExtension (PlugIn)

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteExtension class]];
}

+ (NSUInteger)merit
{
    static NSUInteger result = 0;

    if(result == 0)
    {
        result = [WiimoteExtension
                        nextFreedomMeritInClass:
                                WiimoteExtensionMeritClassUnknown];
    }

    return result;
}

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action
{
    [WiimoteExtension probeFinished:YES target:target action:action];
}

- (id)init
{
	[[super init] release];
	return nil;
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Owner             = owner;
    m_EventDispatcher   = dispatcher;

    return self;
}

- (WiimoteEventDispatcher*)eventDispatcher
{
    return m_EventDispatcher;
}

- (void)initialize:(WiimoteIOManager*)ioManager
            target:(id)target
            action:(SEL)action
{
    [WiimoteExtension initFinished:YES target:target action:action];
}

- (void)handleReport:(NSData*)extensionData
{
}

@end

@implementation WiimoteExtension (CalibrationUtils)

- (void)ioManagerCalibrationDataReaded:(NSData*)data
{
    [self autorelease];

    if(data != nil)
        [self handleCalibrationData:data];
}

- (BOOL)beginReadCalibrationData:(WiimoteIOManager*)ioManager
                     memoryRange:(NSRange)memoryRange
{
    [self retain];

    if(![ioManager readMemory:memoryRange
                       target:self
                       action:@selector(ioManagerCalibrationDataReaded:)])
    {
        [self release];
        return NO;
    }

    return YES;
}

- (void)handleCalibrationData:(NSData*)data
{
}

@end

@implementation WiimoteExtension (PlugInUtils)

+ (void)registerExtensionClass:(Class)cls
{
    [WiimoteExtensionPart registerExtensionClass:cls];
}

+ (NSUInteger)nextFreedomMeritInClass:(WiimoteExtensionMeritClass)meritClass
{
    static NSMutableDictionary *counterDict = nil;

    if(counterDict == nil)
        counterDict = [[NSMutableDictionary alloc] initWithCapacity:5];

    NSNumber *key   = [NSNumber numberWithInteger:meritClass];
    NSNumber *merit = [counterDict objectForKey:key];

    if(merit == nil)
        merit = [NSNumber numberWithInteger:meritClass + 1];
    else
        merit = [NSNumber numberWithInteger:[merit integerValue] + 1];

    [counterDict setObject:merit forKey:key];

    return [merit integerValue];
}

+ (void)routineProbe:(WiimoteIOManager*)manager
           signature:(NSData*)signature
              target:(id)target
              action:(SEL)action
{
    return [WiimoteExtensionProbeHandler
                                    routineProbe:manager
                                       signature:signature
                                          target:target
                                          action:action];
}

+ (void)routineInit:(WiimoteIOManager*)ioManager
             target:(id)target
             action:(SEL)action
{
    NSMutableData *data = [NSMutableData dataWithLength:1];

    *((uint8_t*)[data mutableBytes]) = WiimoteRoutineInitValue1;
    if(![ioManager writeMemory:WiimoteRoutineInitAddress1 data:data])
    {
        [WiimoteExtension initFinished:NO target:target action:action];
        return;
    }

    *((uint8_t*)[data mutableBytes]) = WiimoteRoutineInitValue2;
    if(![ioManager writeMemory:WiimoteRoutineInitAddress2 data:data])
    {
        [WiimoteExtension initFinished:NO target:target action:action];
        return;
    }

    [WiimoteExtension initFinished:YES target:target action:action];
}

+ (void)probeFinished:(BOOL)result
               target:(id)target
               action:(SEL)action
{
    if(target == nil || action == nil)
        return;

    [target performSelector:action
                 withObject:[NSNumber numberWithBool:result]
                 afterDelay:0.0];
}

+ (void)initFinished:(BOOL)result
              target:(id)target
              action:(SEL)action
{
    if(target == nil || action == nil)
        return;

    [target performSelector:action
                 withObject:[NSNumber numberWithBool:result]
                 afterDelay:0.0];
}

@end
