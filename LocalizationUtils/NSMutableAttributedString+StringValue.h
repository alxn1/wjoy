//
//  NSMutableAttributedString+StringValue.h
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMutableAttributedString (StringValue)

- (NSString*)stringValue;
- (void)setStringValue:(NSString*)string;

@end
