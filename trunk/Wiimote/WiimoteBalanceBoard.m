//
//  WiimoteBalanceBoard.m
//  WiimoteBalanceBoard
//
//  Created by alxn1 on 10.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteBalanceBoard.h"

@interface WiimoteBalanceBoard (PrivatePart)

- (void)checkCalibrationData;

@end

@implementation WiimoteBalanceBoard

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteBalanceBoard class]];
}

+ (NSData*)extensionSignature
{
    static const uint8_t  signature[]   = { 0x00, 0x00, 0xA4, 0x20, 0x04, 0x02 };
    static NSData        *result        = nil;

    if(result == nil)
        result = [[NSData alloc] initWithBytes:signature length:sizeof(signature)];

    return result;
}

+ (NSRange)calibrationDataMemoryRange
{
    return NSMakeRange(
				WiimoteBalanceBoardCalibrationDataAddress,
                WiimoteBalanceBoardCalibrationDataSize);
}

+ (WiimoteExtensionMeritClass)meritClass
{
    return WiimoteExtensionMeritClassSystem;
}

+ (NSUInteger)minReportDataSize
{
    return sizeof(WiimoteBalanceBoardReport);
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    self = [super initWithOwner:owner
                eventDispatcher:dispatcher];

    if(self == nil)
        return nil;

    m_IsCalibrationDataReaded   = NO;

    m_TopLeftPress              = 0.0;
    m_TopRightPress             = 0.0;
    m_BottomLeftPress           = 0.0;
    m_BottomRightPress          = 0.0;

    return self;
}

- (NSString*)name
{
    return @"Balance Board";
}

- (double)topLeftPress
{
    return m_TopLeftPress;
}

- (double)topRightPress
{
    return m_TopRightPress;
}

- (double)bottomLeftPress
{
    return m_BottomLeftPress;
}

- (double)bottomRightPress
{
    return m_BottomRightPress;
}

- (void)setPressTopLeft:(double)topLeft
               topRight:(double)topRight
             bottomLeft:(double)bottomLeft
            bottomRight:(double)bottomRight
{
    if(WiimoteDeviceIsFloatEqual(m_TopLeftPress,        topLeft) &&
       WiimoteDeviceIsFloatEqual(m_TopRightPress,       topRight) &&
       WiimoteDeviceIsFloatEqual(m_BottomLeftPress,     bottomLeft) &&
       WiimoteDeviceIsFloatEqual(m_BottomRightPress,    bottomRight))
    {
        return;
    }

    m_TopLeftPress      = topLeft;
    m_TopRightPress     = topRight;
    m_BottomLeftPress   = bottomLeft;
    m_BottomRightPress  = bottomRight;

    [[self eventDispatcher]
                    postBalanceBoard:self
                        topLeftPress:topLeft
                       topRightPress:topRight
                     bottomLeftPress:bottomLeft
                    bottomRightPress:bottomRight];
}

- (void)preprocessReport:(WiimoteBalanceBoardReport*)report
{
    report->topLeftPress        = OSSwapBigToHostConstInt16(report->topLeftPress);
    report->topRightPress       = OSSwapBigToHostConstInt16(report->topRightPress);
    report->bottomLeftPress     = OSSwapBigToHostConstInt16(report->bottomLeftPress);
    report->bottomRightPress    = OSSwapBigToHostConstInt16(report->bottomRightPress);
}

- (double)processPressValue:(double)value kg0:(double)zero kg17:(double)kg17 kg34:(double)kg34
{
    if(value < zero)
        return 0.0;

    if(value < kg17)
        return (value - zero) / ((kg17 - zero) / 17.0);

    if(value < kg34)
        return 17.0 + (value - kg17) / ((kg34 - kg17) / 17.0);

    return 34.0 + (value - kg34) / ((kg34 - zero) / 34.0);
}

- (void)handleCalibrationData:(const uint8_t*)data length:(NSUInteger)length
{
    if(length < sizeof(m_CalibrationData))
        return;

    memcpy(&m_CalibrationData, data, sizeof(m_CalibrationData));

    [self preprocessReport:&(m_CalibrationData.kg0)];
    [self preprocessReport:&(m_CalibrationData.kg17)];
    [self preprocessReport:&(m_CalibrationData.kg34)];
    [self checkCalibrationData];

    m_IsCalibrationDataReaded = YES;
}

- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length
{
    if(!m_IsCalibrationDataReaded ||
       length < sizeof(WiimoteBalanceBoardReport))
    {
        return;
    }

    WiimoteBalanceBoardReport report;

    memcpy(&report, extensionData, sizeof(report));
    [self preprocessReport:&report];

    double topLeft      = [self processPressValue:report.topLeftPress
                                              kg0:m_CalibrationData.kg0.topLeftPress
                                             kg17:m_CalibrationData.kg17.topLeftPress
                                             kg34:m_CalibrationData.kg34.topLeftPress];

    double topRight     = [self processPressValue:report.topRightPress
                                              kg0:m_CalibrationData.kg0.topRightPress
                                             kg17:m_CalibrationData.kg17.topRightPress
                                             kg34:m_CalibrationData.kg34.topRightPress];

    double bottomLeft   = [self processPressValue:report.bottomLeftPress
                                              kg0:m_CalibrationData.kg0.bottomLeftPress
                                             kg17:m_CalibrationData.kg17.bottomLeftPress
                                             kg34:m_CalibrationData.kg34.bottomLeftPress];

    double bottomRight  = [self processPressValue:report.bottomRightPress
                                              kg0:m_CalibrationData.kg0.bottomRightPress
                                             kg17:m_CalibrationData.kg17.bottomRightPress
                                             kg34:m_CalibrationData.kg34.bottomRightPress];

    [self setPressTopLeft:topLeft
                 topRight:topRight
               bottomLeft:bottomLeft
              bottomRight:bottomRight];
}

@end

@implementation WiimoteBalanceBoard (PrivatePart)

- (void)checkCalibrationData
{
    // TODO: add check here, and reset to default values, if data is broken
}

@end
