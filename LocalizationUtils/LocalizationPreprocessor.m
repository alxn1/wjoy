//
//  LocalizationPreprocessor.m
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "LocalizationPreprocessor.h"

#import "LocalizationHook.h"

@interface LocalizationPreprocessorHook : LocalizationHook<LocalizationHookDelegate>

@end

@implementation LocalizationPreprocessorHook

+ (void)load
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [[[LocalizationPreprocessorHook alloc] init] setEnabled:YES];
    [pool release];
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    [self setDelegate:self];
    return self;
}

- (NSString*)localizationHook:(LocalizationHook*)hook
           stringWillLocalize:(NSString*)string
                        table:(NSString*)tableName
{
    return string;
}

- (NSString*)localizationHook:(LocalizationHook*)hook
            stringDidLocalize:(NSString*)string
                        table:(NSString*)tableName
{
    return [[LocalizationPreprocessor sharedInstance] preprocessString:string];
}

@end

@implementation LocalizationPreprocessor

+ (LocalizationPreprocessor*)sharedInstance
{
    static LocalizationPreprocessor *result = nil;

    if(result == nil)
        result = [[LocalizationPreprocessor alloc] init];

    return result;
}

- (NSString*)appName
{
    NSString *appName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];

    if(appName != nil)
        return appName;

    appName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleName"];

    if(appName != nil)
        return appName;

    appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];

    if(appName != nil)
        return appName;

    appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];

    if(appName != nil)
        return appName;

    return [[NSProcessInfo processInfo] processName];
}

- (NSString*)appShortVersion
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary]
                                    objectForKey:@"CFBundleShortVersionString"];

    if(appVersion == nil)
        appVersion = @"0.0";

    return appVersion;
}

- (NSString*)appVersion
{
    NSString *appVersion    = [self appShortVersion];;
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary]
                                    objectForKey:@"CFBundleVersion"];

    if(bundleVersion == nil)
        bundleVersion = @"0";

    return [NSString stringWithFormat:@"%@ (%@)", appVersion, bundleVersion];
}

- (void)initDefaultVariables
{
    [self setVariable:@"APP_NAME" value:[self appName]];
    [self setVariable:@"APP_VERSION" value:[self appVersion]];
    [self setVariable:@"APP_SHORT_VERSION" value:[self appShortVersion]];
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Variables = [[NSMutableDictionary alloc] init];

    [self initDefaultVariables];
    return self;
}

- (void)dealloc
{
    [m_Variables release];
    [super dealloc];
}

- (NSDictionary*)variables
{
    return [[m_Variables retain] autorelease];
}

- (void)setVariable:(NSString*)name value:(NSString*)value
{
    [m_Variables setObject:value forKey:name];
}

- (void)removeVariable:(NSString*)name
{
    [m_Variables removeObjectForKey:name];
}

- (NSString*)wrapVariableName:(NSString*)name
{
    return [NSString stringWithFormat:@"{%%%@%%}", name];
}

- (NSString*)preprocessString:(NSString*)string
{
    if(string == nil)
        return nil;

    NSEnumerator    *en     = [m_Variables keyEnumerator];
    NSString        *key    = [en nextObject];
    NSMutableString *result = nil;

    while(key != nil)
    {
        if([string rangeOfString:[self wrapVariableName:key]].length != 0)
        {
            result = [[string mutableCopy] autorelease];
            break;
        }

        key = [en nextObject];
    }

    if(result != nil)
    {
        while(key != nil)
        {
            [result replaceOccurrencesOfString:[self wrapVariableName:key]
                                    withString:[m_Variables objectForKey:key]
                                       options:0
                                         range:NSMakeRange(0, [result length])];

            key = [en nextObject];
        }

        return result;
    }

    return string;
}

@end
