//
//  MachOSymbol.h
//  ObjCDebug
//
//  Created by alxn1 on 26.11.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <mach-o/nlist.h>

@interface MachOSymbol : NSObject
{
    @private
        NSString        *m_Name;
        struct nlist_64  m_Info;
}

@property (nonatomic, readonly, copy)   NSString                *name;
@property (nonatomic, readonly, assign) const struct nlist_64   *info;

@end
