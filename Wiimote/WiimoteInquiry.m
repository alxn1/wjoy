//
//  WiimoteInquiry.m
//  Wiimote
//
//  Created by alxn1 on 25.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteInquiry.h"
#import "WiimoteDevicePair.h"
#import "Wiimote+Create.h"

#import <IOBluetooth/IOBluetooth.h>

#import <HID/HIDManager.h>

#import <dlfcn.h>

#define WIIMOTE_INQUIRY_TIME_IN_SECONDS 10

NSString *WiimoteDeviceName     = @"Nintendo RVL-CNT-01";
NSString *WiimoteDeviceNameTR   = @"Nintendo RVL-CNT-01-TR";
NSString *WiimoteDeviceNameUPro = @"Nintendo RVL-CNT-01-UC";

@interface WiimoteInquiry (PrivatePart)

- (id)initInternal;

- (void)connectToPairedDevices;

@end

@interface WiimoteInquiry (IOBluetoothDeviceInquiryDelegate)

- (void)deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry*)sender
						  device:(IOBluetoothDevice*)device;

- (void)deviceInquiryComplete:(IOBluetoothDeviceInquiry*)sender 
						error:(IOReturn)error
					  aborted:(BOOL)aborted;

@end

@implementation WiimoteInquiry

+ (void)load
{
    [WiimoteInquiry registerSupportedModelName:WiimoteDeviceName];
    [WiimoteInquiry registerSupportedModelName:WiimoteDeviceNameTR];
	[WiimoteInquiry registerSupportedModelName:WiimoteDeviceNameUPro];
}

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

+ (NSMutableArray*)mutableSupportedModelNames
{
    static NSMutableArray *result = nil;

    if(result == nil)
        result = [[NSMutableArray alloc] init];

    return result;
}

+ (NSArray*)supportedModelNames
{
    return [WiimoteInquiry mutableSupportedModelNames];
}

+ (void)registerSupportedModelName:(NSString*)name
{
    if(![[WiimoteInquiry mutableSupportedModelNames] containsObject:name])
        [[WiimoteInquiry mutableSupportedModelNames] addObject:name];
}

+ (BOOL)isModelSupported:(NSString*)name
{
    return [[self supportedModelNames] containsObject:name];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (void)dealloc
{
    [self stop];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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

    [m_Inquiry setUpdateNewDeviceNames:YES];
	[m_Inquiry setInquiryLength:WIIMOTE_INQUIRY_TIME_IN_SECONDS];
	[m_Inquiry setSearchCriteria:kBluetoothServiceClassMajorAny
                majorDeviceClass:kBluetoothDeviceClassMajorAny
                minorDeviceClass:kBluetoothDeviceClassMinorAny];

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

- (BOOL)isUseOneButtonClickConnection
{
    return m_IsUseOneButtonClickConnection;
}

- (void)setUseOneButtonClickConnection:(BOOL)useOneButtonClickConnection
{
    if(m_IsUseOneButtonClickConnection == useOneButtonClickConnection)
        return;

    m_IsUseOneButtonClickConnection = useOneButtonClickConnection;

    if(m_IsUseOneButtonClickConnection)
        [self connectToPairedDevices];
}

- (void)hidManagerDeviceConnectedNotification:(NSNotification*)notification
{
    if(![self isUseOneButtonClickConnection])
        return;

	HIDDevice	*device		= [[notification userInfo] objectForKey:HIDManagerDeviceKey];
	NSString	*deviceName	= [device name];

	if([WiimoteInquiry isModelSupported:deviceName])
		[Wiimote connectToHIDDevice:device];
}

@end

@implementation WiimoteInquiry (PrivatePart)

- (id)initInternal
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Inquiry                       = nil;
    m_IsUseOneButtonClickConnection = NO;

	[[NSNotificationCenter defaultCenter]
								addObserver:self
								   selector:@selector(hidManagerDeviceConnectedNotification:)
									   name:HIDManagerDeviceConnectedNotification
									 object:[HIDManager manager]];

    return self;
}

- (void)postIgnoreHintToSystem:(IOBluetoothDeviceRef)device
{
    static BOOL isInit                                              = NO;
    static void (*ignoreHIDDeviceFn)(IOBluetoothDeviceRef device)   = NULL;

    if(!isInit)
    {
		ignoreHIDDeviceFn	= dlsym(RTLD_DEFAULT, "IOBluetoothIgnoreHIDDevice");
        isInit				= YES;
    }

    if(ignoreHIDDeviceFn != NULL)
        ignoreHIDDeviceFn(device);
}

- (void)connectToDevices:(NSArray*)devices
{
    NSUInteger count = [devices count];

    for(NSUInteger i = 0; i < count; i++)
    {
        IOBluetoothDevice *device = [devices objectAtIndex:i];

        if([WiimoteInquiry isModelSupported:[device getName]])
		{
            [self postIgnoreHintToSystem:[device getDeviceRef]];
            [Wiimote connectToBluetoothDevice:device];
		}
    }
}

- (void)pairWithDevices:(NSArray*)devices
{
    NSUInteger count = [devices count];

    for(NSUInteger i = 0; i < count; i++)
    {
        IOBluetoothDevice *device = [devices objectAtIndex:i];

        if([WiimoteInquiry isModelSupported:[device getName]])
		{
			if(![device isPaired])
				[WiimoteDevicePair pairWithDevice:device];
		}
    }
}

- (BOOL)isHIDDeviceAlreadyConnected:(HIDDevice*)device wiimotes:(NSArray*)wiimotes
{
    NSUInteger count = [wiimotes count];

    for(NSUInteger i = 0; i < count; i++)
    {
        if([[wiimotes objectAtIndex:i] lowLevelDevice] == device)
            return YES;
    }

    return NO;
}

- (void)connectToPairedDevices
{
    NSEnumerator	*en         = [[[HIDManager manager] connectedDevices] objectEnumerator];
    HIDDevice		*device     = [en nextObject];
    NSArray         *wiimotes   = [Wiimote connectedDevices];

    while(device != nil)
    {
        if([WiimoteInquiry isModelSupported:[device name]] &&
          ![self isHIDDeviceAlreadyConnected:device wiimotes:wiimotes])
        {
            [Wiimote connectToHIDDevice:device];
        }

        device = [en nextObject];
    }
}

@end

@implementation WiimoteInquiry (IOBluetoothDeviceInquiryDelegate)

- (void)deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry*)sender
						  device:(IOBluetoothDevice*)device
{
	if([WiimoteInquiry isModelSupported:[device getName]])
		[m_Inquiry stop];
}

- (void)deviceInquiryComplete:(IOBluetoothDeviceInquiry*)sender 
						error:(IOReturn)error
					  aborted:(BOOL)aborted
{
    [m_Inquiry stop];
	[m_Inquiry setDelegate:nil];

    if(error == kIOReturnSuccess)
    {
        if([self isUseOneButtonClickConnection])
            [self pairWithDevices:[m_Inquiry foundDevices]];
        else
            [self connectToDevices:[m_Inquiry foundDevices]];
    }

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
