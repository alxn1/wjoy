//
//  HIDDevice+Private.m
//  HID
//
//  Created by alxn1 on 24.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "HIDDevice+Private.h"

@implementation HIDDevice (Private)

- (id)propertyForKey:(NSString*)key
{
    if(m_Handle == NULL)
        return nil;

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

- (id)initWithHIDDeviceRef:(IOHIDDeviceRef)handle
{
    self = [super init];

    if(self == nil)
        return nil;

    if(handle == NULL)
    {
        [self release];
        return nil;
    }

    m_Handle        = handle;
    m_Properties    = [[self makePropertiesDictionary] retain];
    m_ReportBuffer  = [[NSMutableData alloc] init];
    m_IsOpened      = NO;
    m_Delegate      = nil;

    CFRetain(m_Handle);

    return self;
}

@end
