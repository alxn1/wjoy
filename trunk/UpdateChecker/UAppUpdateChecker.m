//
//  UAppUpdateChecker.m
//  UpdateChecker
//
//  Created by alxn1 on 17.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UAppUpdateChecker.h"
#import "NSString+UAppVersion.h"

NSString *UAppUpdateCheckerWillStartNotification    = @"UAppUpdateCheckerWillStartNotification";
NSString *UAppUpdateCheckerDidFinishNotification    = @"UAppUpdateCheckerDidFinishNotification";

NSString *UAppUpdateCheckerLatestVersionKey         = @"UAppUpdateCheckerLatestVersionKey";
NSString *UAppUpdateCheckerDownloadURLKey           = @"UAppUpdateCheckerDownloadURLKey";
NSString *UAppUpdateCheckerHasNewVersionKey         = @"UAppUpdateCheckerHasNewVersionKey";
NSString *UAppUpdateCheckerErrorKey                 = @"UAppUpdateCheckerErrorKey";

NSString *UALatesVersionPlistURLKey                 = @"UALatesVersionPlistURL";

NSString *UAVersionKey                              = @"UAVersion";
NSString *UAURLKey                                  = @"UAURL";

@interface UAppUpdateChecker (PrivatePart)

- (BOOL)hasNewVersion:(const UAppVersion*)latestVersion;

- (void)postDidFinishNotificationWithLatestVersion:(NSString*)latestVersion
                                       downloadURL:(NSURL*)downloadURL
                                     hasNewVersion:(BOOL)hasNewVersion;

- (void)postDidFinishNotificationWithError:(NSError*)error;

@end

@implementation UAppUpdateChecker

+ (UAppUpdateChecker*)sharedInstance
{
    static UAppUpdateChecker *result = nil;

    if(result == nil)
        result = [[UAppUpdateChecker alloc] init];

    return result;
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    m_LatestVersionPlistURL = [[infoDictionary objectForKey:UALatesVersionPlistURLKey] retain];
    m_CurrentConnection     = nil;
    m_LoadedData            = [[NSMutableData alloc] init];

    [[infoDictionary objectForKey:@"CFBundleShortVersionString"] parseAppVersion:&m_AppVersion];

    return self;
}

- (void)dealloc
{
    [m_CurrentConnection cancel];
    [m_CurrentConnection release];
    [m_LatestVersionPlistURL release];
    [m_LoadedData release];
    [super dealloc];
}

- (BOOL)isRun
{
    return (m_CurrentConnection != nil);
}

- (BOOL)run
{
    if([self isRun])
        return YES;

    if(m_LatestVersionPlistURL == nil)
        return NO;

    [m_LoadedData setLength:0];

    NSMutableURLRequest *request =
                          [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:m_LatestVersionPlistURL]
                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                   timeoutInterval:60.0];

    [request setHTTPMethod:@"GET"];

    m_CurrentConnection = [[NSURLConnection alloc]
                                    initWithRequest:request
                                           delegate:self];

    if(m_CurrentConnection == NULL)
        return NO;

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:UAppUpdateCheckerWillStartNotification
                                          object:self];

    return YES;
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    if([data length] != 0)
        [m_LoadedData appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    [m_CurrentConnection release];
    m_CurrentConnection = nil;

    [self postDidFinishNotificationWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [m_CurrentConnection release];
    m_CurrentConnection = nil;

    NSDictionary *info = [NSPropertyListSerialization
                                                propertyListFromData:m_LoadedData
                                                    mutabilityOption:NSPropertyListImmutable
                                                              format:NULL
                                                    errorDescription:NULL];

    NSString *latestVersion = [info objectForKey:UAVersionKey];
    NSString *downloadURL   = [info objectForKey:UAURLKey];

    if(latestVersion    == nil ||
       downloadURL      == nil)
    {
        NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];
        [self postDidFinishNotificationWithError:error];
        return;
    }

    UAppVersion parsedLatestVersion;
    [latestVersion parseAppVersion:&parsedLatestVersion];

    [self postDidFinishNotificationWithLatestVersion:latestVersion
                                         downloadURL:[NSURL URLWithString:downloadURL]
                                       hasNewVersion:[self hasNewVersion:&parsedLatestVersion]];
}

@end

@implementation UAppUpdateChecker (PrivatePart)

- (BOOL)hasNewVersion:(const UAppVersion*)latestVersion
{
    // TODO: optimize it

    if(m_AppVersion.major > latestVersion->major)
        return NO;

    if(m_AppVersion.major < latestVersion->major)
        return YES;

    if(m_AppVersion.minor > latestVersion->minor)
        return NO;

    if(m_AppVersion.minor < latestVersion->minor)
        return YES;

    if(m_AppVersion.patch > latestVersion->patch)
        return NO;

    if(m_AppVersion.patch < latestVersion->patch)
        return YES;

    if(m_AppVersion.subPatch > latestVersion->subPatch)
        return NO;

    if(m_AppVersion.subPatch < latestVersion->subPatch)
        return YES;

    return NO;
}

- (void)postDidFinishNotificationWithLatestVersion:(NSString*)latestVersion
                                       downloadURL:(NSURL*)downloadURL
                                     hasNewVersion:(BOOL)hasNewVersion
{
    NSDictionary *userInfo = [NSDictionary
                                dictionaryWithObjectsAndKeys:
                                                latestVersion,                              UAppUpdateCheckerLatestVersionKey,
                                                downloadURL,                                UAppUpdateCheckerDownloadURLKey,
                                                [NSNumber numberWithBool:hasNewVersion],    UAppUpdateCheckerHasNewVersionKey,
                                                nil];

    [[NSNotificationCenter defaultCenter]
                                postNotificationName:UAppUpdateCheckerDidFinishNotification
                                              object:self
                                            userInfo:userInfo];
}

- (void)postDidFinishNotificationWithError:(NSError*)error
{
    NSDictionary *userInfo = [NSDictionary
                                dictionaryWithObject:error
                                              forKey:UAppUpdateCheckerErrorKey];

    [[NSNotificationCenter defaultCenter]
                                postNotificationName:UAppUpdateCheckerDidFinishNotification
                                              object:self
                                            userInfo:userInfo];
}

@end
