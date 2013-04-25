//
//  DMGEULALanguage+SupportedLanguagesStore.m
//  DMGEULA
//
//  Created by alxn1 on 24.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "DMGEULALanguage+SupportedLanguagesStore.h"

#import "NSObject+DMGEULA.h"

@implementation DMGEULALanguage (SupportedLanguagesStore)

+ (NSData*)saveSupportedLanguagesToPList:(NSError**)error
{
    NSArray         *languages  = [self supportedLanguages];
    NSMutableArray  *plist      = [NSMutableArray arrayWithCapacity:[languages count]];

    for(DMGEULALanguage *lang in languages)
        [plist addObject:[lang asDictionary]];

    return [NSPropertyListSerialization
                            dataWithPropertyList:plist
                                          format:NSPropertyListXMLFormat_v1_0
                                         options:0
                                           error:error];
}

+ (NSError*)loadSupportedLanguagesFromPList:(NSData*)plistData
{
    NSError                 *error  = nil;
    NSPropertyListFormat     format = NSPropertyListXMLFormat_v1_0;
    NSArray                 *plist  = [[NSPropertyListSerialization
                                            propertyListWithData:plistData
                                                         options:NSPropertyListImmutable
                                                          format:&format
                                                           error:&error] asType:[NSArray class]];

    if(plist == nil && error == nil)
        error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];

    if(error != nil)
    {
        [self removeAllSupportedLanguages];

        for(NSDictionary *representation in plist)
        {
            DMGEULALanguage *lang = [DMGEULALanguage withDictionary:representation];

            if(lang == nil)
            {
                error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EFTYPE userInfo:nil];
                break;
            }

            [self addSupportedLanguage:lang];
        }
    }

    return error;
}

@end
