//
//  HIDManager.m
//  HID
//
//  Created by alxn1 on 24.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "HIDManager.h"

#import "HIDDevice+Private.h"

NSString *HIDManagerDeviceConnectedNotification     = @"HIDManagerDeviceConnectedNotification";
NSString *HIDManagerDeviceDisconnectedNotification  = @"HIDManagerDeviceDisconnectedNotification";

NSString *HIDManagerDeviceKey                       = @"HIDManagerDeviceKey";

@interface HIDManager (PrivatePart)

- (void)rawDeviceConnected:(IOHIDDeviceRef)device;
- (void)deviceConnected:(HIDDevice*)device;

@end

@implementation HIDManager

static void HIDManagerDeviceConnected(
                                    void            *context,
                                    IOReturn         result,
                                    void            *sender,
                                    IOHIDDeviceRef   device)
{
    HIDManager *manager = (HIDManager*)context;

    [manager rawDeviceConnected:device];
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

    m_Handle            = IOHIDManagerCreate(kCFAllocatorDefault, 0);
    m_ConnectedDevices  = [[NSMutableSet alloc] init];

    if(m_Handle == nil)
    {
        [self release];
        return nil;
    }

    IOHIDManagerSetDeviceMatching(m_Handle, (CFDictionaryRef)[NSDictionary dictionary]);
    IOHIDManagerRegisterDeviceMatchingCallback(m_Handle, HIDManagerDeviceConnected, self);
    IOHIDManagerScheduleWithRunLoop(
                                m_Handle,
                                [[NSRunLoop currentRunLoop] getCFRunLoop],
                                (CFStringRef)NSRunLoopCommonModes);

    if(IOHIDManagerOpen(m_Handle, kIOHIDOptionsTypeNone) != kIOReturnSuccess)
    {
        [self release];
        return nil;
    }

    return self;
}

- (void)dealloc
{
    if(m_Handle != NULL)
    {
        IOHIDManagerUnscheduleFromRunLoop(
                                m_Handle,
                                [[NSRunLoop currentRunLoop] getCFRunLoop],
                                (CFStringRef)NSRunLoopCommonModes);

        IOHIDManagerClose(m_Handle, 0);
        CFRelease(m_Handle);
    }

    while([m_ConnectedDevices count] != 0)
        [[m_ConnectedDevices anyObject] invalidate];

    [m_ConnectedDevices release];
    [super dealloc];
}

+ (HIDManager*)manager
{
    static HIDManager *result = nil;

    if(result == nil)
        result = [[HIDManager alloc] initInternal];

    return result;
}

- (NSSet*)connectedDevices
{
    return [[m_ConnectedDevices retain] autorelease];
}

@end

@implementation HIDManager (PrivatePart)

- (void)rawDeviceConnected:(IOHIDDeviceRef)device
{
    if([m_ConnectedDevices containsObject:(id)device])
        return;

    HIDDevice *d = [[HIDDevice alloc]
                            initWithOwner:self
                                deviceRef:device
                                  options:kIOHIDOptionsTypeNone];

    [self deviceConnected:d];
    [d release];
}

- (void)deviceConnected:(HIDDevice*)device
{
    [m_ConnectedDevices addObject:device];

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:HIDManagerDeviceConnectedNotification
                                          object:self
                                        userInfo:[NSDictionary
                                                        dictionaryWithObject:device
                                                                      forKey:HIDManagerDeviceKey]];
}

@end
