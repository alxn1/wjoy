//
//  DMGEULAResource+DeepStore.h
//  DMGEULA
//
//  Created by alxn1 on 25.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <DMGEULA/DMGEULAResource.h>

#import <DMGEULA/DMGEULALanguage+NSDictionary.h>

FOUNDATION_EXTERN NSString *DMGEULAResourceDeepStoreLanguagesKey;
FOUNDATION_EXTERN NSString *DMGEULAResourceDeepStoreDefaultLanguageNameKey;
FOUNDATION_EXTERN NSString *DMGEULAResourceDeepStoreLanguageLicensePathKey;

@interface DMGEULAResource (DeepStore)

+ (DMGEULAResource*)fromDeepPList:(NSData*)plistData error:(NSError**)error;

- (NSData*)asDeepPList:(NSError**)error;

@end
