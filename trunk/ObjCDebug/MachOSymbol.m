//
//  MachOSymbol.m
//  ObjCDebug
//
//  Created by alxn1 on 26.11.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "MachOSymbol.h"
#import "MachOSymbol+Private.h"

@implementation MachOSymbol

@synthesize name =  m_Name;

+ (MachOSymbol*)symbolWithName:(NSString*)name info32:(const struct nlist*)info
{
    struct nlist_64 tmp;

    tmp.n_un.n_strx = info->n_un.n_strx;
    tmp.n_type      = info->n_type;
    tmp.n_sect      = info->n_sect;
    tmp.n_desc      = info->n_desc;
    tmp.n_value     = info->n_value;

    return [MachOSymbol symbolWithName:name info:&tmp];
}

+ (MachOSymbol*)symbolWithName:(NSString*)name info:(const struct nlist_64*)info
{
    return [[[MachOSymbol alloc] initWithName:name info:info] autorelease];
}

- (id)initWithName:(NSString*)name info:(const struct nlist_64*)info
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Name = [name copy];
    memcpy(&m_Info, info, sizeof(struct nlist_64));

    return self;
}

- (void)dealloc
{
    [m_Name release];
    [super dealloc];
}

- (const struct nlist_64*)info
{
    return (&m_Info);
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"\"%@\": 0x%llX", m_Name, m_Info.n_value];
}

@end
