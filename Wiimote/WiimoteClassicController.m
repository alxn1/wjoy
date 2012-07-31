//
//  WiimoteClassicController.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteClassicController.h"

@implementation WiimoteClassicController

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteClassicController class]];
}

+ (NSData*)extensionSignature
{
    static const uint8_t  signature[]   = { 0x00, 0x00, 0xA4, 0x20, 0x01, 0x01 };
    static NSData        *result        = nil;

    if(result == nil)
        result = [[NSData alloc] initWithBytes:signature length:sizeof(signature)];

    return result;
}

+ (NSRange)calibrationDataMemoryRange
{
    // TODO: add support for calibration
    return NSMakeRange(0, 0);
}

+ (WiimoteExtensionMeritClass)meritClass
{
    return WiimoteExtensionMeritClassSystem;
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher];
    if(self == nil)
        return nil;

    // ???

    return self;
}

- (NSString*)name
{
    return @"Classic Controller";
}

- (void)handleCalibrationData:(NSData*)data
{
    // TODO: add support for calibration
}

- (void)handleReport:(NSData*)extensionData
{
    // ???
}

@end
