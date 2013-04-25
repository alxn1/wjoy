//
//  DMGEULAResource.h
//  DMGEULA
//
//  Created by alxn1 on 24.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import <DMGEULA/DMGEULALanguage.h>

@interface DMGEULAResource : NSObject
{
    @private
        NSMutableArray  *m_Languages;
        NSMutableArray  *m_LicenseFilePaths;
        DMGEULALanguage *m_DefaultLanguage;
}

- (NSArray*)languages;
- (NSString*)licenseFilePathForLanguage:(DMGEULALanguage*)language;
- (BOOL)containsLanguage:(DMGEULALanguage*)language;
- (void)addLanguage:(DMGEULALanguage*)language licenseFilePath:(NSString*)licenseFilePath;
- (void)removeLanguage:(DMGEULALanguage*)language;
- (void)removeAllLanguages;

- (DMGEULALanguage*)defaultLanguage;
- (void)setDefaultLanguage:(DMGEULALanguage*)language;

- (NSString*)makeExternalForm:(NSError**)error;

@end
