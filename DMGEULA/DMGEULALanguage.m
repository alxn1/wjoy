//
//  DMGEULALanguage.m
//  DMGEULA
//
//  Created by alxn1 on 24.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "DMGEULALanguage.h"

NSString *DMGEULAStringTypeLanguage     = @"Language";
NSString *DMGEULAStringTypeAgree        = @"Agree";
NSString *DMGEULAStringTypeDisagree     = @"Disagree";
NSString *DMGEULAStringTypePrint        = @"Print";
NSString *DMGEULAStringTypeSave         = @"Save";
NSString *DMGEULAStringTypeMessage      = @"Message";
NSString *DMGEULAStringTypeMessageTitle = @"MessageTitle";
NSString *DMGEULAStringTypeSaveError    = @"SaveError";
NSString *DMGEULAStringTypePrintError   = @"PrintError";

@implementation DMGEULALanguage

+ (BOOL)checkLocalizedStrings:(NSDictionary*)strings
{
    NSArray *keys = [NSArray arrayWithObjects:
                        DMGEULAStringTypeLanguage,
                        DMGEULAStringTypeAgree,
                        DMGEULAStringTypeDisagree,
                        DMGEULAStringTypePrint,
                        DMGEULAStringTypeSave,
                        DMGEULAStringTypeMessage,
                        DMGEULAStringTypeMessageTitle,
                        DMGEULAStringTypeSaveError,
                        DMGEULAStringTypePrintError,
                        nil];

    for(NSString *key in keys)
    {
        if([strings objectForKey:key] == nil)
            return NO;
    }

    return YES;
}

- (id)init
{
    [self release];
    return nil;
}

- (id)initWithName:(NSString*)name
              code:(NSUInteger)code
  localizedStrings:(NSDictionary*)localizedStrings
          encoding:(CFStringEncoding)encoding
{
    self = [super init];

    if(self == nil)
        return nil;

    if(name             == nil ||
       localizedStrings == nil ||
      ![DMGEULALanguage checkLocalizedStrings:localizedStrings])
    {
        [self release];
        return nil;
    }

    m_Name              = [name copy];
    m_Code              = code;
    m_LocalizedStrings  = [localizedStrings copy];
    m_Encoding          = encoding;

    return self;
}

+ (DMGEULALanguage*)withName:(NSString*)name
                        code:(NSUInteger)code
            localizedStrings:(NSDictionary*)localizedStrings
                    encoding:(CFStringEncoding)encoding
{
    return [[[self alloc]
                    initWithName:name
                            code:code
                localizedStrings:localizedStrings
                        encoding:encoding] autorelease];
}

- (void)dealloc
{
    [m_UserData release];
    [m_LocalizedStrings release];
    [m_Name release];

    [super dealloc];
}

- (NSString*)name
{
    return [[m_Name retain] autorelease];
}

- (NSUInteger)code
{
    return m_Code;
}

- (NSDictionary*)localizedStrings
{
    return [[m_LocalizedStrings retain] autorelease];
}

- (CFStringEncoding)encoding
{
    return m_Encoding;
}

- (NSString*)localizedStringWithType:(NSString*)stringType
{
    return [m_LocalizedStrings objectForKey:stringType];
}

@end

@implementation DMGEULALanguage (UserData)

- (NSDictionary*)userData
{
    return [[m_UserData retain] autorelease];
}

- (void)setUserData:(NSDictionary*)userData
{
    [m_UserData autorelease];
    m_UserData = [userData retain];
}

@end
