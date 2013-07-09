//
//  HIDDevice.m
//  HID
//
//  Created by alxn1 on 24.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "HIDDevice.h"

#import "HIDManager+Private.h"
#import "HIDDevice+Private.h"

@implementation NSObject (HIDDeviceDelegate)

- (void)HIDDevice:(HIDDevice*)device reportDataReceived:(const uint8_t*)bytes length:(NSUInteger)length
{
}

- (void)HIDDeviceDisconnected:(HIDDevice*)device
{
}

@end

@implementation HIDDevice



- (id)init
{
    [[self init] release];
    return nil;
}

- (void)dealloc
{
    if(m_Handle != NULL)
        CFRelease(m_Handle);

    [m_Properties release];
    [m_ReportBuffer release];
    [super dealloc];
}

- (HIDManager*)owner
{
    return m_Owner;
}

- (BOOL)isValid
{
    return m_IsValid;
}

- (void)invalidate
{
    if([self isValid])
    {
        m_IsValid   = NO;
        m_Options   = kIOHIDOptionsTypeNone;

        [self closeDevice];

        [m_Delegate HIDDeviceDisconnected:self];
		[[HIDManager manager] HIDDeviceDisconnected:self];
    }
}

- (IOOptionBits)options
{
    return m_Options;
}

- (BOOL)setOptions:(IOOptionBits)options
{
    if(![self isValid])
        return NO;

    if(m_Options == options)
        return YES;

	[self closeDevice];

	IOOptionBits oldOptions = m_Options;

	m_Options = options;

    if(![self openDevice])
    {
		m_Options = oldOptions;

        if(![self openDevice])
            [self invalidate];

        return NO;
    }

    m_Options = options;
    return YES;
}

- (BOOL)postBytes:(const uint8_t*)bytes length:(NSUInteger)length
{
    BOOL result = NO;

    if([self isValid])
    {
        if(length > 0)
        {
            result = (IOHIDDeviceSetReport(
                                        m_Handle,
                                        kIOHIDReportTypeOutput,
                                        0,
                                        bytes,
                                        length) == kIOReturnSuccess);
        }
        else
            result = YES;
    }

    return result;
}

- (NSDictionary*)properties
{
    return [[m_Properties retain] autorelease];
}

- (id)delegate
{
    return m_Delegate;
}

- (void)setDelegate:(id)delegate
{
    m_Delegate = delegate;
}

- (NSString*)description
{
    return [NSString stringWithFormat:
                                @"HIDDevice (%p): %@",
                                self,
                                [[self properties] description]];
}

- (NSUInteger)hash
{
	return ((NSUInteger)m_Handle);
}

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[self class]])
        return (m_Handle == ((HIDDevice*)object)->m_Handle);

    if(CFGetTypeID(object) == IOHIDDeviceGetTypeID())
        return (m_Handle == (IOHIDDeviceRef)object);

    return NO;
}

@end

@implementation HIDDevice (Properties)

- (NSString*)name
{
    return [[self properties] objectForKey:(NSString*)CFSTR(kIOHIDProductKey)];
}

- (NSString*)address
{
    return [[self properties] objectForKey:(NSString*)CFSTR(kIOHIDSerialNumberKey)];
}

@end
