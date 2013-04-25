//
//  DMGEULAResource+DeepStore.m
//  DMGEULA
//
//  Created by alxn1 on 25.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "DMGEULAResource+DeepStore.h"

#import "NSObject+DMGEULA.h"

NSString *DMGEULAResourceDeepStoreLanguagesKey              = @"Languages";
NSString *DMGEULAResourceDeepStoreDefaultLanguageNameKey    = @"DefaultLanguageName";
NSString *DMGEULAResourceDeepStoreLanguageLicensePathKey    = @"LicensePath";

@implementation DMGEULAResource (DeepStore)

+ (NSDictionary*)decodeDeepStorePList:(NSData*)plistData error:(NSError**)error
{
    NSPropertyListFormat     format = NSPropertyListXMLFormat_v1_0;
    NSDictionary            *plist  = [[NSPropertyListSerialization
                                            propertyListWithData:plistData
                                                         options:NSPropertyListImmutable
                                                          format:&format
                                                           error:error] asType:[NSDictionary class]];

    if(plist == nil  && error != NULL && *error == nil)
        *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

    return plist;
}

+ (BOOL)decodeDeepStoreLanguages:(NSDictionary*)plist
                        resource:(DMGEULAResource*)resource
                           error:(NSError**)error
{
    NSArray *representations = [[plist objectForKey:DMGEULAResourceDeepStoreLanguagesKey] asType:[NSArray class]];

    if(representations == nil)
    {
        if(error != NULL)
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

        return NO;
    }

    for(NSDictionary *representation in representations)
    {
        DMGEULALanguage *lang           = [DMGEULALanguage withDictionary:representation];
        NSString        *licensePath    = [[[lang userData] objectForKey:DMGEULAResourceDeepStoreLanguageLicensePathKey]
                                                asType:[NSString class]];
    
        if(lang == nil || licensePath == nil)
        {
            if(error != NULL)
                *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

            return NO;
        }

        [resource addLanguage:lang licenseFilePath:licensePath];
    }

    return YES;
}

+ (BOOL)decodeDeepStoreDefaultLanguage:(NSDictionary*)plist
                              resource:(DMGEULAResource*)resource
                                 error:(NSError**)error
{
    NSString *defaultLang = [plist objectForKey:DMGEULAResourceDeepStoreDefaultLanguageNameKey];

    if(defaultLang == nil)
        return YES;

    if([defaultLang asType:[NSString class]] == nil)
    {
        if(error != NULL)
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

        return NO;
    }

    NSArray         *langs  = [resource languages];
    DMGEULALanguage *lang   = nil;

    for(DMGEULALanguage *l in langs)
    {
        if([[l name] isEqualToString:defaultLang])
        {
            lang = l;
            break;
        }
    }

    if(lang == nil)
    {
        if(error != NULL)
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

        return NO;
    }

    [resource setDefaultLanguage:lang];
    return YES;
}

+ (DMGEULAResource*)fromDeepPList:(NSData*)plistData error:(NSError**)error
{
    DMGEULAResource *result = [[[DMGEULAResource alloc] init] autorelease];
    NSDictionary    *plist  = [self decodeDeepStorePList:plistData error:error];

    if(plist == nil                                             ||
     ![self decodeDeepStoreLanguages:plist resource:result error:error]  ||
     ![self decodeDeepStoreDefaultLanguage:plist resource:result error:error])
    {
        result = nil;
    }

    return result;
}

- (NSData*)asDeepPList:(NSError**)error
{
    NSArray             *languages  = [self languages];
    NSMutableDictionary *plist      = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableArray      *langs      = [NSMutableArray arrayWithCapacity:[languages count]];

    for(DMGEULALanguage *lang in languages)
    {
        NSDictionary        *lastUserData   = [lang userData];
        NSMutableDictionary *userData       = [NSMutableDictionary dictionaryWithDictionary:lastUserData];

        [userData setObject:[self licenseFilePathForLanguage:lang]
                     forKey:DMGEULAResourceDeepStoreLanguageLicensePathKey];

        [lang setUserData:userData];
        [langs addObject:[lang asDictionary]];
        [lang setUserData:lastUserData];
    }

    [plist setObject:langs forKey:DMGEULAResourceDeepStoreLanguagesKey];

    if([self defaultLanguage] != nil)
    {
        [plist setObject:[[self defaultLanguage] name]
                  forKey:DMGEULAResourceDeepStoreDefaultLanguageNameKey];
    }

    return [NSPropertyListSerialization
                            dataWithPropertyList:plist
                                          format:NSPropertyListXMLFormat_v1_0
                                         options:0
                                           error:error];
}

@end
