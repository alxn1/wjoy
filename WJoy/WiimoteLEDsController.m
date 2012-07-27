//
//  WiimoteLEDsController.m
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteLEDsController.h"
#import "WiimoteDevice.h"

@interface WiimoteLEDsController (PrivatePart)

+ (void)recountConnectedDevices;

- (id)initInternal;

- (void)onDeviceConnected;
- (void)onDeviceDisconnected;

@end

@implementation WiimoteLEDsController

+ (void)start
{
    [[WiimoteLEDsController alloc] initInternal];
}

@end

@implementation WiimoteLEDsController (PrivatePart)

+ (void)recountConnectedDevices
{
    NSArray     *connectedDevices = [WiimoteDevice connectedDevices];
    NSUInteger   countConnected   = [connectedDevices count];
    NSUInteger   counter          = 0;

    for(NSUInteger i = 0; i < countConnected; i++)
    {
        WiimoteDevice *device = [connectedDevices objectAtIndex:i];

        if([device isConnected])
        {
            [device setHighlightedLEDMask:(1 << counter)];
            counter++;
        }
    }
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initInternal
{
    self = [super init];
    if(self == nil)
        return nil;

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(onDeviceConnected)
                                           name:WiimoteDeviceConnectedNotification
                                         object:nil];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(onDeviceDisconnected)
                                           name:WiimoteDeviceDisconnectedNotification
                                         object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)onDeviceConnected
{
    [WiimoteLEDsController recountConnectedDevices];
}

- (void)onDeviceDisconnected
{
    [WiimoteLEDsController recountConnectedDevices];
}

@end
