//
//  WiimoteBatteryPart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteBatteryPart.h"
#import "WiimoteEventDispatcher+Battery.h"

@implementation WiimoteBatteryPart

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteBatteryPart class]];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher ioManager:ioManager];
    if(self == nil)
        return nil;

    m_Level = -1.0;
    m_IsLow = NO;

    return self;
}

- (double)batteryLevel
{
    return m_Level;
}

- (BOOL)isBatteryLevelLow
{
    return m_IsLow;
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    if([report type]    != WiimoteDeviceReportTypeState ||
       [report length]  < sizeof(WiimoteDeviceStateReport))
    {
        return;
    }

    const WiimoteDeviceStateReport *state =
                (const WiimoteDeviceStateReport*)[report data];

    double  batteryLevel        = (((double)state->batteryLevel) / ((double)WiimoteDeviceMaxBatteryLevel)) * 100.0f;
    BOOL    isBatteryLevelLow   = ((state->flagsAndLEDState & WiimoteDeviceStateReportFlagBatteryIsLow) != 0);

    if(batteryLevel         != m_Level ||
       isBatteryLevelLow    != m_IsLow)
    {
        m_Level = batteryLevel;
        m_IsLow = isBatteryLevelLow;

        [[self eventDispatcher] postBatteryLevelUpdateNotification:m_Level isLow:m_IsLow];
    }
}

- (void)disconnected
{
    m_Level = -1.0;
    m_IsLow = NO;
}

@end
