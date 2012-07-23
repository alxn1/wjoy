//
//  UserNotificationCenter.m
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UserNotificationCenterProtected.h"

NSString *UserNotificationClickedNotification   = @"UserNotificationClickedNotification";
NSString *UserNotificationCenterTimeoutKey      = @"UserNotificationCenterTimeoutKey";
NSString *UserNotificationCenterScreenCornerKey = @"UserNotificationCenterScreenCornerKey";

static NSMutableArray                       *uncRegistredImpl   = nil;
static id<UserNotificationCenterDelegate>    uncDelegate        = nil;
static BOOL                                  uncIsSoundEnabled  = NO;
static NSString                             *uncSoundName       = nil;
static NSSound                              *uncSound           = nil;

@interface UserNotificationCenter (PrivatePart)

+ (void)postClickedNotification:(UserNotification*)notification;

@end

@implementation UserNotificationCenter

+ (NSArray*)all
{
    return uncRegistredImpl;
}

+ (NSArray*)available
{
    NSMutableArray *result          = [NSMutableArray array];
    NSUInteger      countAvailable  = [uncRegistredImpl count];

    for(NSUInteger i = 0; i < countAvailable; i++)
    {
        UserNotificationCenter *center = [uncRegistredImpl objectAtIndex:i];
        if([center isAvailable])
            [result addObject:center];
    }

    return result;
}

+ (UserNotificationCenter*)withName:(NSString*)name
{
    UserNotificationCenter *result          = nil;
    NSUInteger              countAvailable  = [uncRegistredImpl count];

    for(NSUInteger i = 0; i < countAvailable; i++)
    {
        UserNotificationCenter *center = [uncRegistredImpl objectAtIndex:i];
        if([[center name] isEqualToString:name])
        {
            result = center;
            break;
        }
    }

    return result;
}

+ (UserNotificationCenter*)availableWithName:(NSString*)name
{
    UserNotificationCenter *result          = nil;
    NSUInteger              countAvailable  = [uncRegistredImpl count];

    for(NSUInteger i = 0; i < countAvailable; i++)
    {
        UserNotificationCenter *center = [uncRegistredImpl objectAtIndex:i];
        if(![center isAvailable])
            continue;

        if([[center name] isEqualToString:name])
        {
            result = center;
            break;
        }
    }

    return result;
}

+ (UserNotificationCenter*)best
{
    UserNotificationCenter  *result         = nil;
    NSUInteger               countAvailable = [uncRegistredImpl count];

    for(NSUInteger i = 0; i < countAvailable; i++)
    {
        UserNotificationCenter *center = [uncRegistredImpl objectAtIndex:i];
        if([center isAvailable])
        {
            if(result != nil)
            {
                if([center merit] < [result merit])
                    result = center;
            }
            else
                result = center;
        }
    }

    return result;
}

+ (BOOL)isSoundEnabled
{
    return uncIsSoundEnabled;
}

+ (void)setSoundEnabled:(BOOL)enabled
{
    uncIsSoundEnabled = enabled;
}

+ (NSString*)soundName
{
    return [[uncSoundName retain] autorelease];
}

+ (void)setSoundName:(NSString*)name
{
    if(uncSoundName == name)
        return;

    [uncSoundName release];
    [uncSound release];

    uncSoundName    = [name copy];
    uncSound        = [[NSSound soundNamed:name] retain];
}

+ (void)deliver:(UserNotification*)notification
{
    [[UserNotificationCenter best] deliver:notification];
}

+ (id<UserNotificationCenterDelegate>)delegate
{
    return uncDelegate;
}

+ (void)setDelegate:(id<UserNotificationCenterDelegate>)obj
{
    uncDelegate = obj;
}

@end

@implementation UserNotificationCenter (Instance)

- (BOOL)isAvailable
{
    return NO;
}

- (NSString*)name
{
    return @"";
}

- (NSUInteger)merit
{
    return NSUIntegerMax;
}

- (void)deliver:(UserNotification*)notification
{
}

- (NSDictionary*)customSettings
{
    return nil;
}

- (void)setCustomSettings:(NSDictionary*)preferences
{
}

@end

@implementation UserNotificationCenter (Protected)

+ (void)registerImpl:(UserNotificationCenter*)impl
{
    if(uncRegistredImpl == nil)
        uncRegistredImpl = [[NSMutableArray alloc] init];

    [uncRegistredImpl addObject:impl];
}

+ (BOOL)shouldDeliverNotification:(UserNotification*)notification
                           center:(UserNotificationCenter*)center
{
    BOOL result = YES;

    if([UserNotificationCenter delegate] != nil)
    {
        result = [[UserNotificationCenter delegate]
                                        userNotificationCenter:center
                                     shouldDeliverNotification:notification];
    }

    if(result && [UserNotificationCenter isSoundEnabled])
    {
        if(uncSoundName != nil)
        {
            if(uncSound != nil)
            {
                if(![uncSound isPlaying])
                    [uncSound play];
            }
        }
        else
            NSBeep();
    }

    return result;
}

+ (void)notificationClicked:(UserNotification*)notification
                     center:(UserNotificationCenter*)center
{
    [self postClickedNotification:notification];

    [[UserNotificationCenter delegate]
                         userNotificationCenter:center
                            notificationClicked:notification];
}

@end

@implementation UserNotificationCenter (PrivatePart)

+ (void)postClickedNotification:(UserNotification*)notification
{
    [[NSNotificationCenter defaultCenter]
                        postNotificationName:UserNotificationClickedNotification
                                      object:notification];
}

@end
