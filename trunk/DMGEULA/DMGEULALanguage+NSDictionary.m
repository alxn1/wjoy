//
//  DMGEULALanguage+NSDictionary.m
//  DMGEULA
//
//  Created by alxn1 on 25.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "DMGEULALanguage+NSDictionary.h"

#import "NSObject+DMGEULA.h"

NSString *DMGEULALanguageNameKey                = @"LanguageName";
NSString *DMGEULALanguageCodeKey                = @"LanguageCode";
NSString *DMGEULALanguageLocalizedStringsKey    = @"LocalizedStrings";
NSString *DMGEULALanguageEncodingKey            = @"Encoding";
NSString *DMGEULALanguageUserDataKey            = @"Additional";

@implementation DMGEULALanguage (NSDictionary)

+ (DMGEULALanguage*)withDictionary:(NSDictionary*)dictionary
{
    NSString        *name       = [[dictionary objectForKey:DMGEULALanguageNameKey] asType:[NSString class]];
    NSNumber        *code       = [[dictionary objectForKey:DMGEULALanguageCodeKey] asType:[NSNumber class]];
    NSDictionary    *strings    = [[dictionary objectForKey:DMGEULALanguageLocalizedStringsKey] asType:[NSDictionary class]];
    NSNumber        *encoding   = [[dictionary objectForKey:DMGEULALanguageEncodingKey] asType:[NSNumber class]];

    if(name     == nil ||
       code     == nil ||
       strings  == nil ||
       encoding == nil)
    {
        return nil;
    }

    DMGEULALanguage *lang = [DMGEULALanguage
                                        withName:name
                                            code:[code integerValue]
                                localizedStrings:strings
                                        encoding:[encoding integerValue]];

    [lang setUserData:[[dictionary objectForKey:DMGEULALanguageUserDataKey] asType:[NSDictionary class]]];

    return lang;
}

- (NSDictionary*)asDictionary
{
    NSMutableDictionary *representation = [NSMutableDictionary dictionaryWithCapacity:5];

    [representation setObject:[self name] forKey:DMGEULALanguageNameKey];
    [representation setObject:[NSNumber numberWithInteger:[self code]] forKey:DMGEULALanguageCodeKey];
    [representation setObject:[self localizedStrings] forKey:DMGEULALanguageLocalizedStringsKey];
    [representation setObject:[NSNumber numberWithInteger:[self encoding]] forKey:DMGEULALanguageEncodingKey];

    if([self userData] != nil)
        [representation setObject:[self userData] forKey:DMGEULALanguageUserDataKey];

    return representation;
}

@end
