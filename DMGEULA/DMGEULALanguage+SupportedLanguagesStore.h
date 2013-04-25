//
//  DMGEULALanguage+SupportedLanguagesStore.h
//  DMGEULA
//
//  Created by alxn1 on 24.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <DMGEULA/DMGEULALanguage+SupportedLanguages.h>

#import <DMGEULA/DMGEULALanguage+NSDictionary.h>

@interface DMGEULALanguage (SupportedLanguagesStore)

+ (NSData*)saveSupportedLanguagesToPList:(NSError**)error;
+ (NSError*)loadSupportedLanguagesFromPList:(NSData*)plistData;

@end
