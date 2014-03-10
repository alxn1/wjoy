//
//  WiimoteDeviceTransport.m
//  Wiimote
//
//  Created by alxn1 on 10.07.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "WiimoteDeviceTransport.h"

#import <IOBluetooth/IOBluetooth.h>

#import <HID/HIDDevice.h>

#import "WiimoteProtocol.h"

@interface WiimoteHIDDeviceTransport : WiimoteDeviceTransport
{
    @private
        HIDDevice *m_Device;
}

- (id)initWithHIDDevice:(HIDDevice*)device;

@end

@interface WiimoteBluetoothDeviceTransport : WiimoteDeviceTransport
{
    @private
        IOBluetoothDevice       *m_Device;
		IOBluetoothL2CAPChannel *m_DataChannel;
        IOBluetoothL2CAPChannel *m_ControlChannel;

        BOOL                     m_IsOpen;
}

- (id)initWithBluetoothDevice:(IOBluetoothDevice*)device;

@end

@implementation WiimoteHIDDeviceTransport

- (id)initWithHIDDevice:(HIDDevice*)device
{
    self = [super init];

    if(self == nil)
        return nil;

    if(device == nil)
    {
        [self release];
        return nil;
    }

    m_Device = [device retain];
    [m_Device setDelegate:self];

    return self;
}

- (void)dealloc
{
    [m_Device release];
    [super dealloc];
}

- (NSString*)name
{
    return [m_Device name];
}

- (NSData*)address
{
	NSString	*address		= [self addressString];
	NSArray		*components		= nil;
	uint8_t		 bytes[6]		= { 0 };
	unsigned int value			= 0;

	components = [address componentsSeparatedByString:@"-"];
	if([components count] != sizeof(bytes))
		return nil;

	for(int i = 0; i < sizeof(bytes); i++)
	{
		NSScanner *scanner = [[NSScanner alloc] initWithString:[components objectAtIndex:i]];
		[scanner scanHexInt:&value];
		[scanner release];
		bytes[i] = (uint8_t)value;
	}

	return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

- (NSString*)addressString
{
    return [m_Device address];
}

- (id)lowLevelDevice
{
    return [[m_Device retain] autorelease];
}

- (BOOL)isOpen
{
    return [m_Device isValid];
}

- (BOOL)open
{
    return [m_Device setOptions:kIOHIDOptionsTypeSeizeDevice];
}

- (void)close
{
    if([self isOpen])
    {
        BluetoothDeviceAddress address = { 0 };

        [[self address] getBytes:address.data length:sizeof(address.data)];
        [[IOBluetoothDevice withAddress:&address] closeConnection];
        [m_Device invalidate];
    }
}

- (BOOL)postBytes:(const uint8_t*)bytes length:(NSUInteger)length
{
    return [m_Device postBytes:bytes length:length];
}

- (void)HIDDevice:(HIDDevice*)device reportDataReceived:(const uint8_t*)bytes length:(NSUInteger)length
{
    [[self delegate] wiimoteDeviceTransport:self reportDataReceived:bytes length:length];
}

- (void)HIDDeviceDisconnected:(HIDDevice*)device
{
    [[self delegate] wiimoteDeviceTransportDisconnected:self];
}

@end

@implementation WiimoteBluetoothDeviceTransport

- (id)initWithBluetoothDevice:(IOBluetoothDevice*)device
{
    self = [super init];

    if(self == nil)
        return nil;

    if(device == nil)
    {
        [self release];
        return nil;
    }

    m_Device            = [device retain];
	m_DataChannel       = nil;
	m_ControlChannel    = nil;
    m_IsOpen            = NO;

    return self;
}

- (void)dealloc
{
    [self close];
    [m_ControlChannel release];
    [m_DataChannel release];
    [m_Device release];
    [super dealloc];
}

- (IOBluetoothL2CAPChannel*)openChannel:(BluetoothL2CAPPSM)channelID
{
	IOBluetoothL2CAPChannel *result = nil;

	if([m_Device openL2CAPChannelSync:&result
                              withPSM:channelID
                             delegate:self] != kIOReturnSuccess)
    {
		return nil;
    }

	return result;
}

- (NSString*)name
{
    return [m_Device getName];
}

- (NSData*)address
{
    const BluetoothDeviceAddress *address = [m_Device getAddress];
    if(address == NULL)
        return nil;

    return [NSData dataWithBytes:address->data
                          length:sizeof(address->data)];
}

- (NSString*)addressString
{
    return [m_Device getAddressString];
}

- (id)lowLevelDevice
{
    return [[m_Device retain] autorelease];
}

- (BOOL)isOpen
{
    return m_IsOpen;
}

- (BOOL)open
{
    if([self isOpen])
		return YES;

	m_IsOpen            = YES;
	m_ControlChannel	= [[self openChannel:kBluetoothL2CAPPSMHIDControl] retain];
	m_DataChannel		= [[self openChannel:kBluetoothL2CAPPSMHIDInterrupt] retain];

	if(m_ControlChannel == nil || m_DataChannel    == nil)
    {
		[self close];
        return NO;
    }

	return YES;
}

- (void)close
{
    if(![self isOpen])
        return;

    [m_ControlChannel setDelegate:nil];
	[m_DataChannel setDelegate:nil];

	[m_ControlChannel closeChannel];
	[m_DataChannel closeChannel];
	[m_Device closeConnection];

	m_IsOpen = NO;

	[[self delegate] wiimoteDeviceTransportDisconnected:self];
}

- (BOOL)postBytes:(const uint8_t*)bytes length:(NSUInteger)length
{
    if(![self isOpen] || bytes == NULL)
		return NO;

    if(length == 0)
		return YES;

    uint8_t buffer[length + 1];

    buffer[0] = 0xA2; // 0xA2 - HID output report
    memcpy(buffer + 1, bytes, length);

    return ([m_DataChannel
                    writeSync:buffer
                       length:sizeof(buffer)] == kIOReturnSuccess);
}

- (void)l2capChannelData:(IOBluetoothL2CAPChannel*)l2capChannel
                    data:(void*)dataPointer
                  length:(size_t)dataLength
{
    const uint8_t *data     = (const uint8_t*)dataPointer;
    size_t         length   = dataLength;

    if(length < 2)
        return;

    [[self delegate] wiimoteDeviceTransport:self reportDataReceived:data + 1 length:length - 1];
}

- (void)l2capChannelClosed:(IOBluetoothL2CAPChannel*)l2capChannel
{
    [self close];
}

@end

@implementation WiimoteDeviceTransport

+ (WiimoteDeviceTransport*)withHIDDevice:(HIDDevice*)device
{
    return [[[WiimoteHIDDeviceTransport alloc] initWithHIDDevice:device] autorelease];
}

+ (WiimoteDeviceTransport*)withBluetoothDevice:(IOBluetoothDevice*)device
{
    return [[[WiimoteBluetoothDeviceTransport alloc] initWithBluetoothDevice:device] autorelease];
}

- (NSString*)name
{
    return nil;
}

- (NSData*)address
{
    return nil;
}

- (NSString*)addressString
{
    return nil;
}

- (id)lowLevelDevice
{
    return nil;
}

- (BOOL)isOpen
{
    return NO;
}

- (BOOL)open
{
    return NO;
}

- (void)close
{
}

- (BOOL)postBytes:(const uint8_t*)bytes length:(NSUInteger)length
{
    return NO;
}

- (id)delegate
{
    return m_Delegate;
}

- (void)setDelegate:(id)delegate
{
    m_Delegate = delegate;
}

@end
