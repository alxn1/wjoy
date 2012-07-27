//
//  LoginItemsList.h
//  WJoy
//
//  Created by alxn1 on 12.03.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    LoginItemsListDomainUser,
    LoginItemsListDomainSystem
} LoginItemsListDomain;

@interface LoginItemsList : NSObject
{
    @private
        LSSharedFileListRef     m_List;
        LoginItemsListDomain    m_Domain;
}

+ (LoginItemsList*)userItemsList;
+ (LoginItemsList*)systemItemsList;

- (LoginItemsListDomain)domain;

- (NSArray*)allPaths;

- (BOOL)isItemWithPathExists:(NSString*)path;
- (BOOL)addItemWithPath:(NSString*)path;
- (BOOL)removeItemWithPath:(NSString*)path;

@end
