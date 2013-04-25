//
//  DMGEULAPathPreprocessor.h
//  DMGEULA
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DMGEULAPathPreprocessor : NSObject
{
    @private
        NSMutableDictionary *m_Variables;
}

+ (DMGEULAPathPreprocessor*)sharedInstance;

- (NSDictionary*)variables;
- (void)setVariable:(NSString*)name value:(NSString*)value;
- (void)removeVariable:(NSString*)name;

- (NSString*)preprocessString:(NSString*)string;

@end
