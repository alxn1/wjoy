//
//  HIDDevice+Private.m
//  HID
//
//  Created by alxn1 on 24.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "HIDDevice+Private.h"

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
					HIDDevice:device
		   reportDataReceived:report
					   length:reportLength];
    }
}

static void HIDDeviceDisconnectCallback(
								void			*context, 
								IOReturn		 result, 
								void			*sender)
{
    [(HIDDevice*)context invalidate];
}

@implementation HIDDevice (Private)

- (id)propertyForKey:(NSString*)key
{
    return ((id)IOHIDDeviceGetProperty(m_Handle, (CFStringRef)key));
}

- (NSDictionary*)makePropertiesDictionary
{
    static CFStringRef keys[] =
    {
        CFSTR(kIOHIDTransportKey),
        CFSTR(kIOHIDVendorIDKey),
        CFSTR(kIOHIDVendorIDSourceKey),
        CFSTR(kIOHIDProductIDKey),
        CFSTR(kIOHIDVersionNumberKey),
        CFSTR(kIOHIDManufacturerKey),
        CFSTR(kIOHIDProductKey),
        CFSTR(kIOHIDSerialNumberKey),
        CFSTR(kIOHIDCountryCodeKey),
        CFSTR(kIOHIDLocationIDKey),
        CFSTR(kIOHIDDeviceUsageKey),
        CFSTR(kIOHIDDeviceUsagePageKey),
        CFSTR(kIOHIDDeviceUsagePairsKey),
        CFSTR(kIOHIDPrimaryUsageKey),
        CFSTR(kIOHIDPrimaryUsagePageKey),
        CFSTR(kIOHIDMaxInputReportSizeKey),
        CFSTR(kIOHIDMaxOutputReportSizeKey),
        CFSTR(kIOHIDMaxFeatureReportSizeKey),
        CFSTR(kIOHIDReportIntervalKey),
        NULL
    };

    CFStringRef         *current    = keys;
    NSMutableDictionary *result     = [NSMutableDictionary dictionary];

    while(*current != NULL)
    {
        NSString    *key   = (NSString*)*current;
        id           value = [self propertyForKey:key];

        if(value != nil)
            [result setObject:value forKey:key];

        current++;
    }

    return result;
}

- (NSUInteger)maxInputReportSize
{
    NSUInteger result = [[[self properties]
                                    objectForKey:(id)CFSTR(kIOHIDMaxInputReportSizeKey)]
                                unsignedIntegerValue];

    if(result == 0)
        result = 128;

    return result;
}

- (id)initWithOwner:(HIDManager*)manager
          deviceRef:(IOHIDDeviceRef)handle
            options:(IOOptionBits)options
{
    self = [super init];

    if(self == nil)
        return nil;

    if(handle == NULL)
    {
        [self release];
        return nil;
    }

    m_Owner         = manager;
    m_IsValid       = YES;
    m_Handle        = handle;
    m_Options       = options;
    m_Properties    = [[self makePropertiesDictionary] retain];
    m_ReportBuffer  = [[NSMutableData alloc] initWithLength:[self maxInputReportSize]];
    m_Delegate      = nil;

    CFRetain(m_Handle);

    [self openDevice];

    return self;
}

- (BOOL)openDevice
{
	IOHIDDeviceScheduleWithRunLoop(
                                m_Handle,
                                [[NSRunLoop currentRunLoop] getCFRunLoop],
                                (CFStringRef)NSRunLoopCommonModes);

    IOHIDDeviceRegisterInputReportCallback( 
                                m_Handle, 
                                [m_ReportBuffer mutableBytes], 
                                [m_ReportBuffer length],
                                HIDDeviceReportCallback, 
                                self);

    IOHIDDeviceRegisterRemovalCallback( 
                                m_Handle, 
                                HIDDeviceDisconnectCallback, 
                                self);

	return (IOHIDDeviceOpen(m_Handle, m_Options) == kIOReturnSuccess);
}

- (void)closeDevice
{
	IOHIDDeviceClose(m_Handle, 0);

	IOHIDDeviceUnscheduleFromRunLoop(
								m_Handle,
								[[NSRunLoop currentRunLoop] getCFRunLoop],
								(CFStringRef)NSRunLoopCommonModes);
}

@end
