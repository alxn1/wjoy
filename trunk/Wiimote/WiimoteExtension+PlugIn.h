//
//  WiimoteExtension+PlugIn.h
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/WiimoteExtension.h>
#import <Wiimote/WiimoteIOManager.h>
#import <Wiimote/WiimoteEventDispatcher.h>

typedef enum
{
    WiimoteExtensionMeritClassMotionPlus    = 1,
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

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action;

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher;

- (WiimoteEventDispatcher*)eventDispatcher;

- (void)calibrate:(WiimoteIOManager*)ioManager;
- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length;
- (void)disconnected;

@end

@interface WiimoteExtension (CalibrationUtils)

- (BOOL)beginReadCalibrationData:(WiimoteIOManager*)ioManager
                     memoryRange:(NSRange)memoryRange;

- (void)handleCalibrationData:(const uint8_t*)data length:(NSUInteger)length;

@end

@interface WiimoteExtension (PlugInUtils)

+ (NSUInteger)nextFreedomMeritInClass:(WiimoteExtensionMeritClass)meritClass;

+ (void)probeFinished:(BOOL)result
               target:(id)target
               action:(SEL)action;

@end

@interface WiimoteExtension (SubExtension)

- (void)setSubExtension:(WiimoteExtension*)extension;

@end

@interface WiimoteExtension (MotionPlus)

- (BOOL)isSupportMotionPlus;
- (WiimoteDeviceMotionPlusMode)motionPlusMode;

- (void)handleMotionPlusReport:(const uint8_t*)extensionData
                        length:(NSUInteger)length;

@end
