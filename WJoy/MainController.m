//
//  MainController.m
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "MainController.h"
#import "WiimoteAutoWrapper.h"
#import "StatusBarItemController.h"
#import "NotificationCenter.h"
#import "WiimoteLEDsController.h"
#import "WiimoteDevicesWatchdog.h"

@implementation MainController

- (void)awakeFromNib
{
    [NotificationCenter start];
    [WiimoteLEDsController start];
    [StatusBarItemController start];
    [WiimoteAutoWrapper setMaxConnectedDevices:4];
    [WiimoteAutoWrapper start];

    [[WiimoteDevicesWatchdog sharedWatchdog] setEnabled:YES];
    [WiimoteDevice beginDiscovery];
}

@end
