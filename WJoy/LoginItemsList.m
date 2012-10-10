//
//  LoginItemsList.m
//  WJoy
//
//  Created by alxn1 on 12.03.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "LoginItemsList.h"

@interface LoginItemsList (PrivatePart)

- (id)initWithDomain:(LoginItemsListDomain)domain;

- (NSString*)itemPath:(LSSharedFileListItemRef)item;
- (LSSharedFileListItemRef)findItemWithPath:(NSString*)path;

@end

@implementation LoginItemsList

+ (LoginItemsList*)userItemsList
{
    static LoginItemsList *result = nil;

    if(result == nil)
        result = [[LoginItemsList alloc] initWithDomain:LoginItemsListDomainUser];

    return result;
}

+ (LoginItemsList*)systemItemsList
{
    static LoginItemsList *result = nil;

    if(result == nil)
        result = [[LoginItemsList alloc] initWithDomain:LoginItemsListDomainSystem];

    return result;
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (void)dealloc
{
    if(m_List != NULL)
        CFRelease(m_List);

    [super dealloc];
}

- (LoginItemsListDomain)domain
{
    return m_Domain;
}

- (NSArray*)allPaths
{
    UInt32           seed   = 0;
    NSArray         *items  = [(NSArray*)LSSharedFileListCopySnapshot(m_List, &seed) autorelease];
    NSMutableArray  *result = [NSMutableArray arrayWithCapacity:[items count]];

    unsigned countItems = [items count];
    for(unsigned i = 0; i < countItems; i++)
    {
        LSSharedFileListItemRef item = (LSSharedFileListItemRef)[items objectAtIndex:i];
        [result addObject:[self itemPath:item]];
    }

    return result;
}

- (BOOL)isItemWithPathExists:(NSString*)path
{
    return ([self findItemWithPath:path] != NULL);
}

- (BOOL)addItemWithPath:(NSString*)path
{
    if([self isItemWithPathExists:path])
        return YES;

    NSURL       *url            = [NSURL fileURLWithPath:path];
    NSString    *displayName    = [[NSFileManager defaultManager] displayNameAtPath:path];
    IconRef      icon           = NULL;
    FSRef        ref;

    if(CFURLGetFSRef((CFURLRef)url, &ref))
    {
        if(GetIconRefFromFileInfo(
                                &ref,
                                 0,
                                 NULL,
                                 kFSCatInfoNone,
                                 NULL,
                                 kIconServicesNormalUsageFlag,
                                &icon,
                                 NULL) != noErr)
        {
            icon = NULL;
        }
    }

    LSSharedFileListItemRef item =
                LSSharedFileListInsertItemURL(
                                            m_List,
                                            kLSSharedFileListItemLast,
                                            (CFStringRef)displayName,
                                            icon,
                                            (CFURLRef)url,
                                            NULL,
                                            NULL);

    if(icon != NULL)
        ReleaseIconRef(icon);

    if(item == NULL)
        return NO;

    CFRelease(item);
    return YES;
}

- (BOOL)removeItemWithPath:(NSString*)path
{
    
    LSSharedFileListItemRef item = [self findItemWithPath:path];

    if(item == NULL)
        return YES;

    return (LSSharedFileListItemRemove(m_List, item) == noErr);
}

@end

@implementation LoginItemsList (PrivatePart)

- (id)initWithDomain:(LoginItemsListDomain)domain
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Domain = domain;
    m_List   = LSSharedFileListCreate(
                            kCFAllocatorDefault,
                            (domain == LoginItemsListDomainUser)?
                                            (kLSSharedFileListSessionLoginItems):
                                            (kLSSharedFileListGlobalLoginItems),
                            NULL);

    if(m_List == NULL)
    {
        [self release];
        return nil;
    }

    return self;
}

- (NSString*)itemPath:(LSSharedFileListItemRef)item
{
    CFURLRef url = NULL;
    if(LSSharedFileListItemResolve(
                                 item,
                                 kLSSharedFileListNoUserInteraction |
                                    kLSSharedFileListDoNotMountVolumes,
                                &url,
                                 NULL) != noErr)
    {
        return nil;
    }

    if(url == NULL)
        return nil;

    NSString *result = [[[(NSURL*)url path] retain] autorelease];
    CFRelease(url);

    return result;
}

- (LSSharedFileListItemRef)findItemWithPath:(NSString*)path
{
    if(path == nil)
        return NULL;

    UInt32       seed   = 0;
    NSArray     *items  = [(NSArray*)LSSharedFileListCopySnapshot(m_List, &seed) autorelease];

    unsigned countItems = [items count];
    for(unsigned i = 0; i < countItems; i++)
    {
        LSSharedFileListItemRef item = (LSSharedFileListItemRef)[items objectAtIndex:i];
        if([[self itemPath:item] isEqualToString:path])
            return item;
    }

    return NULL;
}

@end
