//
//  DMGEULALanguage+SupportedLanguages.h
//  DMGEULA
//
//  Created by alxn1 on 24.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <DMGEULA/DMGEULALanguage.h>

@interface DMGEULALanguage (SupportedLanguages)

+ (NSArray*)supportedLanguages;

+ (DMGEULALanguage*)findWithName:(NSString*)name;
+ (DMGEULALanguage*)findWithCode:(NSUInteger)code;

+ (void)addSupportedLanguage:(DMGEULALanguage*)language;
+ (void)removeSupportedLanguage:(DMGEULALanguage*)language;
+ (void)removeAllSupportedLanguages;

@end
