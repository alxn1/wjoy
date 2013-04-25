//
//  DMGEULAResource+Store.h
//  DMGEULA
//
//  Created by alxn1 on 24.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <DMGEULA/DMGEULAResource.h>

#import <DMGEULA/DMGEULALanguage+SupportedLanguages.h>

FOUNDATION_EXTERN NSString *DMGEULAResourceLocalizationsKey;
FOUNDATION_EXTERN NSString *DMGEULAResourceDefaultLanguageCodeKey;
FOUNDATION_EXTERN NSString *DMGEULAResourceLanguageCodeKey;
FOUNDATION_EXTERN NSString *DMGEULAResourceLicensePathKey;

@interface DMGEULAResource (Store)

+ (DMGEULAResource*)fromPList:(NSData*)plistData error:(NSError**)error;

- (NSData*)asPList:(NSError**)error;

@end
