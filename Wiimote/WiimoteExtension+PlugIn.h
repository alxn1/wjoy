//
//  WiimoteExtension+PlugIn.h
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtension.h"
#import "WiimoteIOManager.h"
#import "WiimoteEventDispatcher.h"

typedef enum
{
    WiimoteExtensionMeritClassSystemHigh    = 1000,
    WiimoteExtensionMeritClassUserHigh      = 10000,
    WiimoteExtensionMeritClassSystem        = 100000,
    WiimoteExtensionMeritClassUser          = 1000000,
    WiimoteExtensionMeritClassUnknown       = 10000000
} WiimoteExtensionMeritClass;

@interface WiimoteExtension (PlugIn)

+ (void)registerExtensionClass:(Class)cls;

+ (NSUInteger)merit;
+ (NSUInteger)minReportDataSize;

+ (void)initialize:(WiimoteIOManager*)ioManager;

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action;

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher;

- (WiimoteEventDispatcher*)eventDispatcher;

- (void)calibrate:(WiimoteIOManager*)ioManager;
- (void)handleReport:(NSData*)extensionData;

@end

@interface WiimoteExtension (CalibrationUtils)

- (BOOL)beginReadCalibrationData:(WiimoteIOManager*)ioManager
                     memoryRange:(NSRange)memoryRange;

- (void)handleCalibrationData:(NSData*)data;

@end

@interface WiimoteExtension (PlugInUtils)

+ (NSUInteger)nextFreedomMeritInClass:(WiimoteExtensionMeritClass)meritClass;

+ (void)probeFinished:(BOOL)result
               target:(id)target
               action:(SEL)action;

@end
