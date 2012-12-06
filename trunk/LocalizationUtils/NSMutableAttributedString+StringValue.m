//
//  NSMutableAttributedString+StringValue.m
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NSMutableAttributedString+StringValue.h"

@implementation NSMutableAttributedString (StringValue)

- (NSString*)stringValue
{
    return [self string];
}

- (void)setStringValue:(NSString*)string
{
    [self replaceCharactersInRange:NSMakeRange(0, [self length]) withString:string];
}

@end
