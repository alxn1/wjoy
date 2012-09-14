//
//  WiimoteMotionPlus.m
//  Wiimote
//
//  Created by alxn1 on 13.09.12.
//  Copyright 2012 Dr. Web. All rights reserved.
//

#import "WiimoteMotionPlus.h"
#import "WiimoteExtensionProbeHandler.h"

@interface WiimoteMotionPlus (PrivatePart)

- (void)deactivate;

@end

@implementation WiimoteMotionPlus

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteMotionPlus class]];
}

+ (NSUInteger)merit
{
    return WiimoteExtensionMeritClassMotionPlus;
}

+ (NSUInteger)minReportDataSize
{
    // ???
    return 6;
}

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action
{
    static const uint8_t     signature[]           = { 0x00, 0x00, 0xA4, 0x20, 0x04, 0x05 };
    static NSData           *extensionSignature    = nil;

    if(extensionSignature == nil)
        extensionSignature = [[NSData alloc] initWithBytes:signature length:sizeof(signature)];

    [WiimoteExtensionProbeHandler
                            routineProbe:ioManager
                               signature:extensionSignature
                                  target:target
                                  action:action];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher];
    if(self == nil)
        return nil;

    m_SubExtension  = nil;
    m_IOManager     = nil;

    return self;
}

- (void)dealloc
{
    [m_SubExtension release];
    [m_IOManager release];
    [super dealloc];
}

- (void)calibrate:(WiimoteIOManager*)ioManager
{
    m_IOManager = [ioManager retain];
}

- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length
{
    if(length < 6)
        return;

    BOOL isExtensionConnected   = ((extensionData[5] & 0x1) == 1);
    BOOL isExtensionDataReport  = ((extensionData[5] & 0x2) == 0);
    BOOL isSubExtensionPresent  = (m_SubExtension != nil);

    if(isExtensionConnected != isSubExtensionPresent)
    {
        [self deactivate];
        return;
    }

    if(isExtensionDataReport)
    {
        [m_SubExtension handleMotionPlusReport:extensionData length:length];
        return;
    }

    // ???
    // handle motion plus data here
}

- (void)setSubExtension:(WiimoteExtension*)extension
{
    if(extension != nil &&
     ![extension isSupportMotionPlus])
    {
        extension = nil;
    }

    if(m_SubExtension == extension)
        return;

    [m_SubExtension release];
    m_SubExtension = [extension retain];
}

- (NSString*)name
{
    return @"Motion Plus";
}

- (WiimoteExtension*)subExtension
{
    return [[m_SubExtension retain] autorelease];
}

@end

@implementation WiimoteMotionPlus (PrivatePart)

- (void)deactivate
{
    uint8_t data = WiimoteDeviceMotionPlusExtensionInitOrResetValue;

    [m_IOManager writeMemory:WiimoteDeviceMotionPlusExtensionResetAddress
                        data:&data
                      length:sizeof(data)];

    usleep(50000);
}

@end
