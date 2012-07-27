//
//  WiimoteDevicesWatchdog.h
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

FOUNDATION_EXPORT NSString *WiimoteDevicesWatchdogEnabledChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteDevicesWatchdogPingNotification;

@interface WiimoteDevicesWatchdog : NSObject
{
    @private
        NSTimer *m_Timer;
        BOOL     m_IsPingNotificationEnabled;
}

+ (WiimoteDevicesWatchdog*)sharedWatchdog;

- (BOOL)isEnabled;
- (void)setEnabled:(BOOL)enabled;

- (BOOL)isPingNotificationEnabled;
- (void)setPingNotificationEnabled:(BOOL)enabled;

@end
