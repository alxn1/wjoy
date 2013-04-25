//
//  DMGEULAResource+Store.m
//  DMGEULA
//
//  Created by alxn1 on 24.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "DMGEULAResource+Store.h"

#import "NSObject+DMGEULA.h"

NSString *DMGEULAResourceLocalizationsKey       = @"Localizations";
NSString *DMGEULAResourceDefaultLanguageCodeKey = @"DefaultLanguageCode";
NSString *DMGEULAResourceLanguageCodeKey        = @"LanguageCode";
NSString *DMGEULAResourceLicensePathKey         = @"LicensePath";

@implementation DMGEULAResource (Store)

+ (NSDictionary*)decodePList:(NSData*)plistData error:(NSError**)error
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

+ (BOOL)decodeLanguages:(NSDictionary*)plist
               resource:(DMGEULAResource*)resource
                  error:(NSError**)error
{
    NSArray *representations = [[plist objectForKey:DMGEULAResourceLocalizationsKey] asType:[NSArray class]];

    if(representations == nil)
    {
        if(error != NULL)
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

        return NO;
    }
    for(NSDictionary *representation in representations)
    {
        NSNumber        *code           = [[representation objectForKey:DMGEULAResourceLanguageCodeKey] asType:[NSNumber class]];
        NSString        *licensePath    = [[representation objectForKey:DMGEULAResourceLicensePathKey] asType:[NSString class]];
        DMGEULALanguage *lang           = [DMGEULALanguage findWithCode:[code integerValue]];
        

        if(code == nil || licensePath == nil || lang == nil)
        {
            if(error != NULL)
                *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

            return NO;
        }

        [resource addLanguage:lang licenseFilePath:licensePath];
    }

    return YES;
}

+ (BOOL)decodeDefaultLanguage:(NSDictionary*)plist
                     resource:(DMGEULAResource*)resource
                        error:(NSError**)error
{
    NSNumber *defaultLang = [plist objectForKey:DMGEULAResourceDefaultLanguageCodeKey];

    if(defaultLang == nil)
        return YES;

    if([defaultLang asType:[NSNumber class]] == nil)
    {
        if(error != NULL)
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

        return NO;
    }

    DMGEULALanguage *lang = [DMGEULALanguage findWithCode:[defaultLang integerValue]];

    if(lang == nil)
    {
        if(error != NULL)
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

        return NO;
    }

    [resource setDefaultLanguage:lang];
    return YES;
}

+ (DMGEULAResource*)fromPList:(NSData*)plistData error:(NSError**)error
{
    DMGEULAResource *result = [[[DMGEULAResource alloc] init] autorelease];
    NSDictionary    *plist  = [self decodePList:plistData error:error];

    if(plist == nil                                             ||
     ![self decodeLanguages:plist resource:result error:error]  ||
     ![self decodeDefaultLanguage:plist resource:result error:error])
    {
        result = nil;
    }

    return result;
}

- (NSData*)asPList:(NSError**)error
{
    NSArray             *languages  = [self languages];
    NSMutableDictionary *plist      = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableArray      *langs      = [NSMutableArray arrayWithCapacity:[languages count]];

    for(DMGEULALanguage *lang in languages)
    {
        NSMutableDictionary *representation = [NSMutableDictionary dictionaryWithCapacity:2];

        [representation setObject:[NSNumber numberWithInteger:[lang code]] forKey:DMGEULAResourceLanguageCodeKey];
        [representation setObject:[self licenseFilePathForLanguage:lang] forKey:DMGEULAResourceLicensePathKey];

        [langs addObject:representation];
    }

    [plist setObject:langs forKey:DMGEULAResourceLocalizationsKey];
    [plist setObject:[NSNumber numberWithInteger:[[self defaultLanguage] code]]
              forKey:DMGEULAResourceDefaultLanguageCodeKey];

    return [NSPropertyListSerialization
                            dataWithPropertyList:plist
                                          format:NSPropertyListXMLFormat_v1_0
                                         options:0
                                           error:error];
}

@end
