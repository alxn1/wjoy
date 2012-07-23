//
//  GrowlUserNotificationCenter.m
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "GrowlUserNotificationCenter.h"
#import <Growl/Growl.h>

#define GrowlNotificationName           @"Notifications"
#define GrowlApplicationBridgeClassName @"GrowlApplicationBridge"

@interface GrowlUserNotificationCenter (PrivatePart)

+ (BOOL)isAvailable;
+ (Class)growlBridgeClass;

- (void)notificationClicked:(UserNotification*)notification;

@end

@interface GrowlUserNotificationCenterGrowlDelegate : NSObject<GrowlApplicationBridgeDelegate> {
@private
    GrowlUserNotificationCenter *owner;
}

- (id)initWithOwner:(GrowlUserNotificationCenter*)obj;

- (NSDictionary*)registrationDictionaryForGrowl;
- (void)growlNotificationWasClicked:(id)clickContext;

@end

@implementation GrowlUserNotificationCenterGrowlDelegate

- (id)initWithOwner:(GrowlUserNotificationCenter*)obj
{
    self = [super init];
    if(self == nil)
        return nil;

    owner = obj;

    return self;
}

- (NSDictionary*)registrationDictionaryForGrowl
{
    NSDictionary *notifications = [NSDictionary dictionaryWithObject:GrowlNotificationName forKey:GrowlNotificationName];
    NSString     *appName       = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

    if(appName == nil)
    {
        appName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
        if(appName == nil)
            appName = [[NSProcessInfo processInfo] processName];
    }

	return [NSDictionary dictionaryWithObjectsAndKeys:
							 appName,                   GROWL_APP_NAME,
							 [notifications allKeys],   GROWL_NOTIFICATIONS_ALL,
							 [notifications allKeys],   GROWL_NOTIFICATIONS_DEFAULT,
							 notifications,             GROWL_NOTIFICATIONS_HUMAN_READABLE_NAMES,
							 nil];
}

- (void)growlNotificationWasClicked:(id)clickContext
{
    UserNotification *notification = [[UserNotification alloc] initWithDictionary:clickContext];
    [owner notificationClicked:notification];
    [notification release];
}

@end


@implementation GrowlUserNotificationCenter

+ (void)load
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if([GrowlUserNotificationCenter isAvailable])
    {
        GrowlUserNotificationCenter *center = [[GrowlUserNotificationCenter alloc] init];
        [UserNotificationCenter registerImpl:center];
        [center release];
    }

    [pool release];
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    growlDelegate = [[GrowlUserNotificationCenterGrowlDelegate alloc] initWithOwner:self];
    [[GrowlUserNotificationCenter growlBridgeClass] setGrowlDelegate:growlDelegate];

    return self;
}

- (void)dealloc
{
    [[GrowlUserNotificationCenter growlBridgeClass] setGrowlDelegate:nil];
    [growlDelegate release];
    [super dealloc];
}

- (BOOL)isAvailable
{
    return [[GrowlUserNotificationCenter growlBridgeClass] isGrowlRunning];
}

- (NSString*)name
{
    return @"growl";
}

- (NSUInteger)merit
{
    return 1;
}

- (void)deliver:(UserNotification*)notification
{
    if(![UserNotificationCenter
                    shouldDeliverNotification:notification
                                       center:self])
    {
        return;
    }

    [[GrowlUserNotificationCenter growlBridgeClass]
                                            notifyWithTitle:[notification title]
                                                description:[notification text]
                                           notificationName:GrowlNotificationName
                                                   iconData:nil
                                                   priority:0
                                                   isSticky:NO
                                               clickContext:[notification asDictionary]];
}

@end

@implementation GrowlUserNotificationCenter (PrivatePart)

+ (BOOL)isAvailable
{
    return ([GrowlUserNotificationCenter growlBridgeClass] != nil);
}

+ (Class)growlBridgeClass
{
    static Class result = nil;

    if(result == nil)
    {
        NSString *frameworksPath        = [[[NSBundle bundleForClass:[GrowlUserNotificationCenter class]] bundlePath]
                                                                    stringByAppendingPathComponent:@"Versions/A/Frameworks"];

        NSString *growlFrameworkPath    = [frameworksPath stringByAppendingPathComponent:@"Growl.framework"];

        if([[NSBundle bundleWithPath:growlFrameworkPath] load])
        {
            result = NSClassFromString(GrowlApplicationBridgeClassName);
            if(result != nil)
                return result;
        }

        growlFrameworkPath = [frameworksPath stringByAppendingPathComponent:@"10.5/Growl.framework"];

        if([[NSBundle bundleWithPath:growlFrameworkPath] load])
            result = NSClassFromString(GrowlApplicationBridgeClassName);
    }

    return result;
}

- (void)notificationClicked:(UserNotification*)notification
{
    [UserNotificationCenter notificationClicked:notification center:self];
}

@end
