//
//  DMGEULALanguage+SupportedLanguages.m
//  DMGEULA
//
//  Created by alxn1 on 24.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "DMGEULALanguage+SupportedLanguages.h"

@implementation DMGEULALanguage (SupportedLanguages)

+ (NSMutableDictionary*)languagesByName
{
    static NSMutableDictionary *result = nil;

    if(result == nil)
        result = [[NSMutableDictionary alloc] init];

    return result;
}

+ (NSMutableDictionary*)languagesByCode
{
    static NSMutableDictionary *result = nil;

    if(result == nil)
        result = [[NSMutableDictionary alloc] init];

    return result;
}

+ (NSArray*)supportedLanguages
{
    return [[self languagesByName] allValues];
}

+ (DMGEULALanguage*)findWithName:(NSString*)name
{
    if(name == nil)
        return nil;

    return [[self languagesByName] objectForKey:name];
}

+ (DMGEULALanguage*)findWithCode:(NSUInteger)code
{
    return [[self languagesByCode]
                objectForKey:[NSNumber numberWithInteger:code]];
}

+ (void)addSupportedLanguage:(DMGEULALanguage*)language
{
    if(language != nil)
    {
        [[language retain] autorelease];

        [self removeSupportedLanguage:[self findWithCode:[language code]]];
        [self removeSupportedLanguage:[self findWithName:[language name]]];

        [[self languagesByName] setObject:language forKey:[language name]];
        [[self languagesByCode] setObject:language
                                   forKey:[NSNumber numberWithInteger:[language code]]];
    }
}

+ (void)removeSupportedLanguage:(DMGEULALanguage*)language
{
    if(language != nil)
    {
        [[self languagesByName] removeObjectForKey:[language name]];
        [[self languagesByCode] removeObjectForKey:[NSNumber numberWithInteger:[language code]]];
    }
}

+ (void)removeAllSupportedLanguages
{
    [[self languagesByName] removeAllObjects];
    [[self languagesByCode] removeAllObjects];
}

@end
