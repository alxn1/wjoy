//
//  DMGEULAPathPreprocessor.m
//  DMGEULA
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "DMGEULAPathPreprocessor.h"

@implementation DMGEULAPathPreprocessor

+ (DMGEULAPathPreprocessor*)sharedInstance
{
    static DMGEULAPathPreprocessor *result = nil;

    if(result == nil)
        result = [[DMGEULAPathPreprocessor alloc] init];

    return result;
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Variables = [[NSMutableDictionary alloc] init];

    return self;
}

- (void)dealloc
{
    [m_Variables release];
    [super dealloc];
}

- (NSDictionary*)variables
{
    return [[m_Variables retain] autorelease];
}

- (void)setVariable:(NSString*)name value:(NSString*)value
{
    [m_Variables setObject:value forKey:name];
}

- (void)removeVariable:(NSString*)name
{
    [m_Variables removeObjectForKey:name];
}

- (NSString*)wrapVariableName:(NSString*)name
{
    return [NSString stringWithFormat:@"{%%%@%%}", name];
}

- (NSString*)preprocessString:(NSString*)string
{
    if(string == nil)
        return nil;

    NSEnumerator    *en     = [m_Variables keyEnumerator];
    NSString        *key    = [en nextObject];
    NSMutableString *result = nil;

    while(key != nil)
    {
        if([string rangeOfString:[self wrapVariableName:key]].length != 0)
        {
            result = [[string mutableCopy] autorelease];
            break;
        }

        key = [en nextObject];
    }

    if(result != nil)
    {
        while(key != nil)
        {
            [result replaceOccurrencesOfString:[self wrapVariableName:key]
                                    withString:[m_Variables objectForKey:key]
                                       options:0
                                         range:NSMakeRange(0, [result length])];

            key = [en nextObject];
        }

        return result;
    }

    return string;
}

@end
