//
//  NSString+UAppVersion.h
//  UpdateChecker
//
//  Created by alxn1 on 17.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <UpdateChecker/UAppVersion.h>

@interface NSString (UAppVersion)

+ (NSString*)stringWithAppVersion:(const UAppVersion*)version;

- (id)initWithAppVersion:(const UAppVersion*)version;

- (BOOL)parseAppVersion:(UAppVersion*)version;

@end
