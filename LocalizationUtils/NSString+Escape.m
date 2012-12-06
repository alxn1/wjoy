//
//  NSString+Escape.m
//  LocalizationUtils
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NSString+Escape.h"

typedef struct
{
    NSString *original;
    NSString *replacement;
} EscapableUnichar;

static const EscapableUnichar EscapableUnichars[] =
{
    { @"\a", @"\\a"  },
    { @"\b", @"\\b"  },
    { @"\t", @"\\t"  },
    { @"\n", @"\\n"  },
    { @"\v", @"\\v"  },
    { @"\f", @"\\f"  },
    { @"\r", @"\\r"  },
    { @"\"", @"\\\"" },
    { @"\'", @"\\\'" },
    { @"\?", @"\\\?" },
    { @"\\", @"\\\\" },
    { @"\%", @"\\\%" },
    { nil,   nil     }
};

@implementation NSString (Escape)

+ (NSCharacterSet*)escapableCharacters
{
    NSMutableCharacterSet   *result = [[[NSMutableCharacterSet alloc] init] autorelease];
    const EscapableUnichar  *uchar  = EscapableUnichars;

    while(uchar->original != nil)
    {
        [result addCharactersInString:uchar->original];
        uchar++;
    }

    return result;
}

+ (void)preprocessUnichar:(unichar)character andAddTo:(NSMutableString*)output
{
    const EscapableUnichar *uchar = EscapableUnichars;

    while(uchar->original != nil)
    {
        if([uchar->original characterAtIndex:0] == character)
        {
            [output appendString:uchar->replacement];
            return;
        }

        uchar++;
    }

    [output appendFormat:@"%C", character];
}

- (NSString*)escapedString
{
    NSUInteger           length             = [self length];
    NSCharacterSet      *needToBeEscaped    = nil;
    NSMutableString     *result             = nil;

    if(length == 0)
        return self;

    needToBeEscaped = [NSString escapableCharacters];
    if([self rangeOfCharacterFromSet:needToBeEscaped].length == 0)
        return self;

    result = [NSMutableString stringWithCapacity:length];
    for(NSUInteger i = 0; i < length; i++)
        [NSString preprocessUnichar:[self characterAtIndex:i] andAddTo:result];

    return result;
}

@end
