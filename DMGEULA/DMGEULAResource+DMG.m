//
//  DMGEULAResource+DMG.m
//  DMGEULA
//
//  Created by alxn1 on 25.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "DMGEULAResource+DMG.h"

@implementation DMGEULAResource (DMG)

- (NSString*)makeTempFileWithContent:(NSString*)content error:(NSError**)error
{
    CFUUIDRef    uuid   = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef  string = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    NSString    *path   = [[NSTemporaryDirectory() stringByAppendingPathComponent:(NSString*)string] stringByAppendingPathExtension:@"r"];

    if(![content writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:error])
        path = nil;

    CFRelease(string);
    CFRelease(uuid);

    return path;
}

- (NSError*)applyToDMG:(NSString*)pathToDMG
{
    BOOL isDirectory = NO;

    if(![[NSFileManager defaultManager] fileExistsAtPath:pathToDMG isDirectory:&isDirectory])
        return [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOENT userInfo:nil];

    if(isDirectory)
        return [NSError errorWithDomain:NSPOSIXErrorDomain code:EISDIR userInfo:nil];

    NSError     *error      = nil;
    NSString    *rc         = [self makeExternalForm:&error];

    if(rc == nil)
        return error;

    NSString   *tempFile    = [self makeTempFileWithContent:rc error:&error];

    if(tempFile == nil)
        return error;

    system([[NSString stringWithFormat:@"hdiutil unflatten \"%@\" >> /dev/null 2>> /dev/null", pathToDMG] UTF8String]);
    system([[NSString stringWithFormat:@"Rez /Developer/Headers/FlatCarbon/Carbon.r \"%@\" -a -o \"%@\"", tempFile, pathToDMG] UTF8String]);
    system([[NSString stringWithFormat:@"hdiutil flatten \"%@\" >> /dev/null 2>> /dev/null", pathToDMG] UTF8String]);

    [[NSFileManager defaultManager] removeItemAtPath:tempFile error:NULL];
    return error;
}

@end
