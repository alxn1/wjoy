//
//  WiimoteAnalogNormalizer.m
//  Wiimote
//
//  Created by alxn1 on 21.06.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "WiimoteAnalogNormalizer.h"

NSString *WiimoteNormalizerPropertyMinKey           = @"min";
NSString *WiimoteNormalizerPropertyMaxKey           = @"max";
NSString *WiimoteNormalizerPropertyCenterKey        = @"center";
NSString *WiimoteNormalizerPropertyDeadZoneKey      = @"deadZone";

@interface WiimoteAnalogNormalizer ()

- (NSValue*)defaultPropertyValueForKey:(NSString*)key;
- (BOOL)checkPropertyValue:(NSValue*)value forKey:(NSString*)key;

@end

@interface WiimoteAnalogStickNormalizer : WiimoteMutableAnalogNormalizer

@end

@implementation WiimoteAnalogStickNormalizer : WiimoteMutableAnalogNormalizer

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    [self resetPropertyValueForKey:WiimoteNormalizerPropertyMinKey];
    [self resetPropertyValueForKey:WiimoteNormalizerPropertyMaxKey];
    [self resetPropertyValueForKey:WiimoteNormalizerPropertyCenterKey];
    [self resetPropertyValueForKey:WiimoteNormalizerPropertyDeadZoneKey];

    return self;
}

- (NSValue*)defaultPropertyValueForKey:(NSString*)key
{
    static NSDictionary *defaultProperties = nil;

    if(defaultProperties == nil)
    {
        defaultProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSValue valueWithPoint:NSMakePoint(-1.0f, -1.0f)],
                                    WiimoteNormalizerPropertyMinKey,
                                [NSValue valueWithPoint:NSMakePoint(1.0f, 1.0f)],
                                    WiimoteNormalizerPropertyMaxKey,
                                [NSValue valueWithPoint:NSMakePoint(0.0f, 0.0f)],
                                    WiimoteNormalizerPropertyCenterKey,
                                [NSValue valueWithPoint:NSMakePoint(0.0f, 0.0f)],
                                    WiimoteNormalizerPropertyDeadZoneKey,
                                nil];
    }

    return [defaultProperties objectForKey:key];
}

- (NSPoint)pointPropertyValueForKey:(NSString*)key
{
    return [[self propertyValueForKey:key] pointValue];
}

- (BOOL)checkPropertyValue:(NSValue*)value forKey:(NSString*)key
{
    NSPoint newValue = [value pointValue];
    BOOL    result   = NO;

    if([key isEqualToString:WiimoteNormalizerPropertyMinKey]) {
    }
    else if([key isEqualToString:WiimoteNormalizerPropertyMaxKey]) {
    }
    else if([key isEqualToString:WiimoteNormalizerPropertyCenterKey]) {
    }
    else if([key isEqualToString:WiimoteNormalizerPropertyDeadZoneKey]) {
    }

    // ???
    return result;
}

- (NSValue*)normalize:(NSValue*)value
{
    // ???
}

- (WiimoteAnalogNormalizerType)type
{
    return WiimoteAnalogNormalizerTypeStick;
}

@end

@interface WiimoteAnalogShiftNormalizer : WiimoteMutableAnalogNormalizer

@end

@implementation WiimoteAnalogShiftNormalizer : WiimoteMutableAnalogNormalizer

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    [self resetPropertyValueForKey:WiimoteNormalizerPropertyMaxKey];
    [self resetPropertyValueForKey:WiimoteNormalizerPropertyDeadZoneKey];

    return self;
}

- (NSValue*)defaultPropertyValueForKey:(NSString*)key
{
    static NSDictionary *defaultProperties = nil;

    if(defaultProperties == nil)
    {
        defaultProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithFloat:1.0f],
                                    WiimoteNormalizerPropertyMaxKey,
                                [NSNumber numberWithFloat:0.0f],
                                    WiimoteNormalizerPropertyDeadZoneKey,
                                nil];
    }

    return [defaultProperties objectForKey:key];
}

- (float)floatPropertyValueForKey:(NSString*)key
{
    return [(NSNumber*)[self propertyValueForKey:key] floatValue];
}

- (BOOL)checkPropertyValue:(NSValue*)value forKey:(NSString*)key
{
    float   newValue = [(NSNumber*)value floatValue];
    BOOL    result   = NO;

    if([key isEqualToString:WiimoteNormalizerPropertyDeadZoneKey]) {
        result = (newValue < [self floatPropertyValueForKey:WiimoteNormalizerPropertyMaxKey]);
    }
    else if([key isEqualToString:WiimoteNormalizerPropertyMaxKey]) {
        result = (newValue > [self floatPropertyValueForKey:WiimoteNormalizerPropertyDeadZoneKey]);
    }

    return result;
}

- (NSValue*)normalize:(NSValue*)value
{
    float max       = [self floatPropertyValueForKey:WiimoteNormalizerPropertyMaxKey];
    float deadZone  = [self floatPropertyValueForKey:WiimoteNormalizerPropertyDeadZoneKey];
    float newValue  = [(NSNumber*)value floatValue];

    newValue = (newValue - deadZone) / (max - deadZone);

    if(newValue < 0.0f) newValue = 0.0f;
    if(newValue > 1.0f) newValue = 1.0f;

    return [NSNumber numberWithFloat:newValue];
}

- (WiimoteAnalogNormalizerType)type
{
    return WiimoteAnalogNormalizerTypeShift;
}

@end

@implementation WiimoteAnalogNormalizer

+ (id)stickNormalizer
{
    return [[[WiimoteAnalogStickNormalizer alloc] init] autorelease];
}

+ (id)shiftNormalizer
{
    return [[[WiimoteAnalogShiftNormalizer alloc] init] autorelease];
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Properties = [[NSMutableDictionary alloc] initWithCapacity:4];

    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];

    if(self == nil)
        return nil;

    if([decoder allowsKeyedCoding])
        m_Properties = [[decoder decodeObjectForKey:@"properties"] retain];
    else
        m_Properties = [[decoder decodeObject] retain];

    return self;
}

- (void)dealloc
{
    [m_Properties release];
    [super dealloc];
}

- (NSDictionary*)properties
{
    return [[m_Properties retain] autorelease];
}

- (NSValue*)propertyValueForKey:(NSString*)key
{
    return [m_Properties objectForKey:key];
}

- (NSValue*)defaultPropertyValueForKey:(NSString*)key
{
    return nil;
}

- (BOOL)checkPropertyValue:(NSValue*)value forKey:(NSString*)key
{
    return YES;
}

- (BOOL)setPropertyValue:(NSValue*)value forKey:(NSString*)key
{
    if([self checkPropertyValue:value forKey:key])
    {
        [m_Properties setObject:value forKey:key];
        return YES;
    }

    return NO;
}

- (void)resetPropertyValueForKey:(NSString*)key
{
    NSValue *defaultValue = [self defaultPropertyValueForKey:key];

    if(defaultValue != nil)
        [self checkPropertyValue:defaultValue forKey:key];
    else
        [m_Properties removeObjectForKey:key];
}

- (NSValue*)normalize:(NSValue*)value
{
    return value;
}

- (WiimoteAnalogNormalizerType)type
{
    return WiimoteAnalogNormalizerTypeUnknown;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    if([coder allowsKeyedCoding])
        [coder encodeObject:m_Properties forKey:@"properties"];
    else
        [coder encodeObject:m_Properties];
}

@end

@implementation WiimoteMutableAnalogNormalizer

- (BOOL)setPropertyValue:(NSValue*)property forKey:(NSString*)key
{
    return [super setPropertyValue:property forKey:key];
}

- (void)resetPropertyValueForKey:(NSString*)key
{
    [super resetPropertyValueForKey:key];
}

@end
