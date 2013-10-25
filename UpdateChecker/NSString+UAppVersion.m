//
//  NSString+UAppVersion.m
//  UpdateChecker
//
//  Created by alxn1 on 17.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NSString+UAppVersion.h"

@implementation NSString (UAppVersion)

+ (NSString*)stringWithAppVersion:(const UAppVersion*)version
{
    return [[[NSString alloc] initWithAppVersion:version] autorelease];
}

- (id)initWithAppVersion:(const UAppVersion*)version
{
    if(version == NULL)
    {
        [self release];
        return nil;
    }

    return [self initWithFormat:@"%i.%i.%i.%i",
                                    version->major,
                                    version->minor,
                                    version->patch,
                                    version->subPatch];
}

- (BOOL)parseAppVersion:(UAppVersion*)version
{
    if(version == NULL)
        return NO;

    memset(version, 0, sizeof(UAppVersion));

    NSArray *components = [self componentsSeparatedByString:@"."];
    if(components == NULL       ||
      [components count] == 0   ||
      [components count] > 4)
    {
        return NO;
    }

    version->major = [(NSString*)[components objectAtIndex:0] intValue];

    if([components count] > 1)
        version->minor = [(NSString*)[components objectAtIndex:1] intValue];

    if([components count] > 2)
        version->patch = [(NSString*)[components objectAtIndex:2] intValue];

    if([components count] > 3)
        version->subPatch = [(NSString*)[components objectAtIndex:3] intValue];

    return YES;
}

@end
