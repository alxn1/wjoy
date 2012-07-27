//
//  WiimoteDevice+ConnectedTracking.m
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice+ConnectedTracking.h"

@implementation WiimoteDevice (ConnectedTracking)

+ (NSMutableArray*)connectedDevicesArray
{
    static NSMutableArray *result = nil;

    if(result == nil)
        result = [[NSMutableArray alloc] init];

    return result;
}

+ (NSArray*)allConnectedDevices
{
    return [self connectedDevicesArray];
}

+ (void)addNewConnectedDevice:(WiimoteDevice*)device
{
    [[self connectedDevicesArray] addObject:device];
}

+ (void)removeConnectedDevice:(WiimoteDevice*)device
{
    [[self connectedDevicesArray] removeObject:device];
}

@end
