//
//  NSBundle+NibLoadNotification.m
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NSBundle+NibLoadNotification.h"

#import "NSObject+ObjCRuntime.h"

NSString *NSBundleNibDidLoadNotification    = @"NSBundleNibDidLoadNotification";

NSString *NSBundleNibNameKey                = @"NSBundleNibNameKey";
NSString *NSBundleNibOwnerKey               = @"NSBundleNibOwnerKey";
NSString *NSBundleNibBundleKey              = @"NSBundleNibBundleKey";
NSString *NSBundleNibFilePathKey            = @"NSBundleNibFilePathKey";
NSString *NSBundleNibRootObjectsKey         = @"NSBundleNibRootObjectsKey";

@implementation NSBundle (NibDidLoadNotification)

+ (void)load
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [[self class]
        swizzleClassMethod:@selector(loadNibFile: externalNameTable: withZone:)
                withMethod:@selector(interceptedLoadNibFile: externalNameTable: withZone:)];

    [pool release];
}

+ (NSBundle*)bundleForNibWithPath:(NSString*)filePath
{
    NSAutoreleasePool   *pool   = [[NSAutoreleasePool alloc] init];
    NSBundle            *result = nil;

    while(result == nil ||
         [result bundleIdentifier] == nil &&
         [filePath length] != 0 &&
        ![filePath isEqualToString:@"/"])
    {
        result      = [NSBundle bundleWithPath:filePath];
        filePath    = [filePath stringByDeletingLastPathComponent];
    }

    if([result bundleIdentifier] == nil)
        result = nil;

    [pool release];
    return result;
}

+ (NSDictionary*)preprocessExternalNameTable:(NSDictionary*)context
{
    NSMutableArray *topLevelObjects = [context objectForKey:NSNibTopLevelObjects];

    if(topLevelObjects != nil)
        return context;

    NSMutableDictionary *mutableContext =
                                [NSMutableDictionary dictionaryWithDictionary:context];

    [mutableContext setObject:[NSMutableArray array]
                       forKey:NSNibTopLevelObjects];

    return mutableContext;
}

+ (void)postDidLoadNotification:(NSString*)fileName
              externalNameTable:(NSDictionary*)context
{
    NSMutableDictionary *info               = [NSMutableDictionary dictionary];
    id                   owner              = [context objectForKey:NSNibOwner];
    NSArray             *topLevelObjects    = [context objectForKey:NSNibTopLevelObjects];
    NSBundle            *bundle             = [self bundleForNibWithPath:fileName];

    if(bundle != nil)
        [info setObject:bundle forKey:NSBundleNibBundleKey];

    if(owner != nil)
        [info setObject:owner forKey:NSBundleNibOwnerKey];

    [info setObject:fileName forKey:NSBundleNibFilePathKey];
    [info setObject:topLevelObjects forKey:NSBundleNibRootObjectsKey];
    [info setObject:[[fileName lastPathComponent] stringByDeletingPathExtension]
             forKey:NSBundleNibNameKey];

    [[NSNotificationCenter defaultCenter]
                                postNotificationName:NSBundleNibDidLoadNotification
                                              object:self
                                            userInfo:info];
}

+ (BOOL)interceptedLoadNibFile:(NSString*)fileName
             externalNameTable:(NSDictionary*)context
                      withZone:(NSZone*)zone
{
    context = [self preprocessExternalNameTable:context];

    BOOL result = [self interceptedLoadNibFile:fileName
                             externalNameTable:context
                                      withZone:zone];

    if(result)
        [self postDidLoadNotification:fileName externalNameTable:context];

    return result;
}

@end
