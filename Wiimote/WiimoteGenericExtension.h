//
//  WiimoteGenericExtension.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtension+PlugIn.h"

@interface WiimoteGenericExtension : WiimoteExtension
{
}

+ (NSData*)extensionSignature;
+ (NSRange)calibrationDataMemoryRange;
+ (WiimoteExtensionMeritClass)meritClass;
+ (NSUInteger)minReportDataSize;

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher;

- (void)handleCalibrationData:(const uint8_t*)data length:(NSUInteger)length;
- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length;

@end

/*

WiimoteGenericExtension is subclass of WiimoteExtension. It's simplify process
of creating standart (like nunchuck) extension plugin. It's simplify probe process
(you only need to give extension signature, calibration memory range (if device need calibration),
meritClass (merit number will be generated automatically in class range), and minReportDataSize).
After what you receive readed (if needed) calibration data and device reports.
For additional details, see nunchuck or classic controller extensions.

*/
