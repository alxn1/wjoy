//
//  UserNotification.m
//  UserNotification
//
//  Created by alxn1 on 18.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UserNotification.h"

@interface UserNotification (PrivatePart)

- (void)checkFields;

@end

@implementation UserNotification

+ (UserNotification*)userNotificationWithTitle:(NSString*)aTitle text:(NSString*)aText
{
    return [[[UserNotification alloc] initWithTitle:aTitle text:aText userInfo:nil] autorelease];
}

+ (UserNotification*)userNotificationWithTitle:(NSString*)aTitle text:(NSString*)aText userInfo:(NSDictionary*)aUserInfo
{
    return [[[UserNotification alloc] initWithTitle:aTitle text:aText userInfo:aUserInfo] autorelease];
}

- (id)initWithTitle:(NSString*)aTitle text:(NSString*)aText userInfo:(NSDictionary*)aUserInfo
{
    self = [super init];
    if(self == nil)
        return nil;

    title       = [aTitle copy];
    text        = [aText copy];
    userInfo    = [aUserInfo copy];

    [self checkFields];

    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self == nil)
        return nil;

    title       = [[dictionary objectForKey:@"title"] retain];
    text        = [[dictionary objectForKey:@"text"] retain];
    userInfo    = [[dictionary objectForKey:@"userInfo"] retain];

    [self checkFields];

    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super init];
    if(self == nil)
        return nil;

    if([decoder allowsKeyedCoding])
    {
        title       = [[decoder decodeObjectForKey:@"title"] retain];
        text        = [[decoder decodeObjectForKey:@"text"] retain];
        userInfo    = [[decoder decodeObjectForKey:@"userInfo"] retain];
    }
    else
    {
        title       = [[decoder decodeObject] retain];
        text        = [[decoder decodeObject] retain];
        userInfo    = [[decoder decodeObject] retain];
    }

    [self checkFields];

    return self;
}

- (void)dealloc
{
    [title release];
    [text release];
    [userInfo release];
    [super dealloc];
}

- (NSString*)title
{
    return [[title retain] autorelease];
}

- (NSString*)text
{
    return [[text retain] autorelease];
}

- (NSDictionary*)userInfo
{
    return [[userInfo retain] autorelease];
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    if([coder allowsKeyedCoding])
    {
        [coder encodeObject:title forKey:@"title"];
        [coder encodeObject:text forKey:@"text"];
        [coder encodeObject:userInfo forKey:@"userInfo"];
    }
    else
    {
        [coder encodeObject:title];
        [coder encodeObject:text];
        [coder encodeObject:userInfo];
    }
}

- (NSDictionary*)asDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
                                                title,      @"title",
                                                text,       @"text",
                                                userInfo,   @"userInfo",
                                                nil];
}

- (NSString*)description
{
    return [[self asDictionary] description];
}

@end

@implementation UserNotification (PrivatePart)

- (void)checkFields
{
    if(title == nil)
        title = @"";

    if(text == nil)
        text = @"";

    if(userInfo == nil)
        userInfo = [[NSDictionary alloc] init];
}

@end
