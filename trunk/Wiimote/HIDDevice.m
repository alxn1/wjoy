//
//  HIDDevice.m
//  HID
//
//  Created by alxn1 on 24.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "HIDDevice.h"

#import "HIDManager+Private.h"

@implementation NSObject (HIDDeviceDelegate)

- (void)hidDevice:(HIDDevice*)device reportDataReceived:(const uint8_t*)bytes length:(NSUInteger)length
{
}

- (void)hidDeviceClosed:(HIDDevice*)device
{
}

@end

@implementation HIDDevice

static void HIDDeviceReportCallback(
                                void            *context, 
                                IOReturn         result, 
                                void            *sender, 
                                IOHIDReportType  type, 
                                uint32_t         reportID,
                                uint8_t         *report, 
                                CFIndex          reportLength)
{
    if(reportLength > 0)
    {
        HIDDevice *device = (HIDDevice*)context;

        [[device delegate]
					hidDevice:device
		   reportDataReceived:report
					   length:reportLength];
    }
}

- (id)init
{
    [[self init] release];
    return nil;
}

- (void)dealloc
{
    [self close];
    [m_Properties release];
    [m_ReportBuffer release];
    [super dealloc];
}

- (BOOL)isOpened
{
    return m_IsOpened;
}

- (BOOL)open
{
    return [self openWithOptions:kIOHIDOptionsTypeNone];
}

- (BOOL)openWithOptions:(IOHIDOptionsType)options
{
    if(m_IsOpened || m_Handle == NULL)
        return NO;

    IOHIDDeviceScheduleWithRunLoop(
                                m_Handle,
                                [[NSRunLoop currentRunLoop] getCFRunLoop],
                                (CFStringRef)NSRunLoopCommonModes);

    NSUInteger maxReportSize = [[[self properties]
                                            objectForKey:(id)CFSTR(kIOHIDMaxInputReportSizeKey)]
                                        unsignedIntegerValue];

    if(maxReportSize == 0)
        maxReportSize = 128;

    [m_ReportBuffer setLength:maxReportSize];

    IOHIDDeviceRegisterInputReportCallback( 
                                m_Handle, 
                                [m_ReportBuffer mutableBytes], 
                                [m_ReportBuffer length],
                                HIDDeviceReportCallback, 
                                self);

    if(IOHIDDeviceOpen(m_Handle, options) != kIOReturnSuccess)
    {
        [self close];
        return NO;
    }

	m_IsOpened = YES;

    return YES;
}

- (void)close
{
    if(m_Handle != NULL)
    {
        BOOL isOpened = m_IsOpened;

        if(isOpened)
        {
            IOHIDDeviceUnscheduleFromRunLoop(
                                m_Handle,
                                [[NSRunLoop currentRunLoop] getCFRunLoop],
                                (CFStringRef)NSRunLoopCommonModes);

            IOHIDDeviceClose(m_Handle, 0);
        }

        CFRelease(m_Handle);
        m_Handle    = NULL;
        m_IsOpened  = NO;

		[[HIDManager manager] hidDeviceDisconnected:self];

        if(isOpened)
            [m_Delegate hidDeviceClosed:self];
    }
}

- (BOOL)postBytes:(const uint8_t*)bytes length:(NSUInteger)length
{
    BOOL result = NO;

    if([self isOpened])
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
