//
//  DMGEULALanguage+NSDictionary.h
//  DMGEULA
//
//  Created by alxn1 on 25.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <DMGEULA/DMGEULALanguage.h>

FOUNDATION_EXTERN NSString *DMGEULALanguageNameKey;
FOUNDATION_EXTERN NSString *DMGEULALanguageCodeKey;
FOUNDATION_EXTERN NSString *DMGEULALanguageLocalizedStringsKey;
FOUNDATION_EXTERN NSString *DMGEULALanguageEncodingKey;
FOUNDATION_EXTERN NSString *DMGEULALanguageUserDataKey;

@interface DMGEULALanguage (NSDictionary)

+ (DMGEULALanguage*)withDictionary:(NSDictionary*)dictionary;

- (NSDictionary*)asDictionary;

@end
