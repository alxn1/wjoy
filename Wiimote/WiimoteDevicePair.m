//
//  WiimoteDevicePair.m
//  Wiimote
//
//  Created by alxn1 on 30.06.13.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevicePair.h"

#import <IOBluetooth/IOBluetooth.h>

@protocol IOBluetoothDevicePair_Methods

- (IOReturn)start;

- (IOBluetoothDevice*)device;

- (void)replyPINCode:(ByteCount)PINCodeSize PINCode:(BluetoothPINCode*)PINCode;

- (void)setDelegate:(id)object;

@end

@protocol IOBluetoothDevicePair_ClassMethods

- (id<IOBluetoothDevicePair_Methods>)pairWithDevice:(IOBluetoothDevice*)device;

@end

@interface WiimoteDevicePair (PrivatePart)

- (void)runWithDevice:(IOBluetoothDevice*)device;

@end

@implementation WiimoteDevicePair

+ (void)pairWithDevice:(IOBluetoothDevice*)device
{
	WiimoteDevicePair *pair = [[WiimoteDevicePair alloc] init];

	[pair runWithDevice:device];
}

- (id)init
{
	self = [super init];

	if(self == nil)
		return nil;

	m_IsFirstAttempt = YES;

	return self;
}

@end

@implementation WiimoteDevicePair (PrivatePart)

- (void)runWithDevice:(IOBluetoothDevice*)device
{
	id<IOBluetoothDevicePair_ClassMethods>	factory = (id<IOBluetoothDevicePair_ClassMethods>)
															NSClassFromString(@"IOBluetoothDevicePair");

	id<IOBluetoothDevicePair_Methods>		pair	= [factory pairWithDevice:device];

	[pair setDelegate:self];

	if([pair start] != kIOReturnSuccess)
		[self release];
}

- (NSData*)makePINCodeForDevice:(IOBluetoothDevice*)device
{
	NSString	*address		= [[IOBluetoothHostController defaultController] addressAsString];
	NSArray		*components		= nil;
	uint8_t		 bytes[6]		= { 0 };
	unsigned int value			= 0;

	if(!m_IsFirstAttempt)
		address = [device addressString];

	components = [address componentsSeparatedByString:@"-"];
	if([components count] != 6)
		return nil;

	for(int i = 0; i < 6; i++)
	{
		NSScanner *scanner = [[NSScanner alloc] initWithString:[components objectAtIndex:i]];
		[scanner scanHexInt:&value];
		[scanner release];
		bytes[5 - i] = (uint8_t)value;
	}

	return [NSData dataWithBytes:bytes length:sizeof(bytes)];
}

- (void)devicePairingPINCodeRequest:(id<IOBluetoothDevicePair_Methods>)sender
{
	BluetoothPINCode	 PIN	= { 0 };
	NSData				*data	= [self makePINCodeForDevice:[sender device]];

	[data getBytes:PIN.data];
	[sender replyPINCode:[data length] PINCode:&PIN];
}

- (void)devicePairingFinished:(id<IOBluetoothDevicePair_Methods>)sender error:(IOReturn)error
{
	if(error != kIOReturnSuccess)
	{
		if(m_IsFirstAttempt)
		{
			m_IsFirstAttempt = NO;
			[self runWithDevice:[sender device]];
			return;
		}
	}

	[self release];
}

@end
