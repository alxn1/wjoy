//
//  WiimoteInquiry.m
//  Wiimote
//
//  Created by alxn1 on 25.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteInquiry.h"
#import "Wiimote+Create.h"

#import <IOBluetooth/IOBluetooth.h>

#define WIIMOTE_INQUIRY_TIME_IN_SECONDS 20

static NSString *WiimoteDeviceName = @"Nintendo RVL-CNT-01";

@interface WiimoteInquiry (PrivatePart)

- (id)initInternal;

- (void)connectToFindedDevices:(NSArray*)devices;

@end

@interface WiimoteInquiry (IOBluetoothDeviceInquiryDelegate)

- (void)deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry*)sender
						  device:(IOBluetoothDevice*)device;

- (void)deviceInquiryComplete:(IOBluetoothDeviceInquiry*)sender 
						error:(IOReturn)error
					  aborted:(BOOL)aborted;

@end

@implementation WiimoteInquiry

+ (BOOL)isBluetoothEnabled
{
    return IOBluetoothLocalDeviceAvailable();
}

+ (WiimoteInquiry*)sharedInquiry
{
    static WiimoteInquiry *result = nil;

    if(result == nil)
        result = [[WiimoteInquiry alloc] initInternal];

    return result;
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (void)dealloc
{
    [self stop];
    [super dealloc];
}

- (BOOL)isStarted
{
    return (m_Inquiry != nil);
}

- (BOOL)startWithTarget:(id)target didEndAction:(SEL)action
{
    if([self isStarted])
        return YES;

    if(![WiimoteInquiry isBluetoothEnabled])
        return NO;

	m_Inquiry = [[IOBluetoothDeviceInquiry inquiryWithDelegate:self] retain];
	[m_Inquiry setInquiryLength:WIIMOTE_INQUIRY_TIME_IN_SECONDS];
	[m_Inquiry setSearchCriteria:kBluetoothServiceClassMajorAny
                majorDeviceClass:kBluetoothDeviceClassMajorPeripheral
                minorDeviceClass:kBluetoothDeviceClassMinorPeripheral2Joystick];

	[m_Inquiry setUpdateNewDeviceNames:YES];

	if([m_Inquiry start] != kIOReturnSuccess)
    {
		[self stop];
		return NO;
	}

    m_Target = target;
    m_Action = action;
    return YES;
}

- (BOOL)stop
{
    if(![self isStarted])
        return YES;

    [m_Inquiry stop];
	[m_Inquiry setDelegate:nil];
	[m_Inquiry release];
	m_Inquiry = nil;

    return YES;
}

@end

@implementation WiimoteInquiry (PrivatePart)

- (id)initInternal
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Inquiry = nil;
    return self;
}

- (void)connectToFindedDevices:(NSArray*)devices
{
    NSUInteger count = [devices count];

    for(NSUInteger i = 0; i < count; i++)
    {
        IOBluetoothDevice *device = [devices objectAtIndex:i];

        if([[device getName] rangeOfString:WiimoteDeviceName].length != 0)
            [Wiimote connectToBluetoothDevice:device];
    }
}

@end

@implementation WiimoteInquiry (IOBluetoothDeviceInquiryDelegate)

- (void)deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry*)sender
						  device:(IOBluetoothDevice*)device
{
	[m_Inquiry stop];
}

- (void)deviceInquiryComplete:(IOBluetoothDeviceInquiry*)sender 
						error:(IOReturn)error
					  aborted:(BOOL)aborted
{
    if(error == kIOReturnSuccess)
        [self connectToFindedDevices:[m_Inquiry foundDevices]];

    [self stop];

    if(m_Target != nil &&
       m_Action != nil)
    {
        [m_Target performSelector:m_Action withObject:self];
    }

    m_Target = nil;
    m_Action = nil;
}

@end
