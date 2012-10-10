//
//  WiimoteGenericExtension.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/WiimoteExtension+PlugIn.h>

@interface WiimoteGenericExtension : WiimoteExtension
{
}

+ (NSData*)extensionSignature;
+ (NSArray*)extensionSignatures;

+ (NSRange)calibrationDataMemoryRange;

+ (WiimoteExtensionMeritClass)meritClass;
+ (NSUInteger)minReportDataSize;

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher;

- (BOOL)isSupportMotionPlus;
- (WiimoteDeviceMotionPlusMode)motionPlusMode;

- (void)handleCalibrationData:(const uint8_t*)data length:(NSUInteger)length;
- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length;

- (void)handleMotionPlusReport:(const uint8_t*)extensionData
                        length:(NSUInteger)length;

- (void)disconnected;

@end
