//
//  MachOSymbolMap.h
//  ObjCDebug
//
//  Created by alxn1 on 26.11.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <ObjCDebug/MachOSymbol.h>

typedef enum {
    MachOArchTypeX86,
    MachOArchTypeX86_64
} MachOArchType;

@interface MachOSymbolMap : NSObject
{
    @private
        NSMutableDictionary *m_Map;
        NSMutableDictionary *m_AddressMap;
}

+ (MachOSymbolMap*)loadFromFile:(NSString*)path;
+ (MachOSymbolMap*)loadFromFile:(NSString*)path arch:(MachOArchType)arch;

- (MachOSymbol*)findWithName:(NSString*)name;
- (MachOSymbol*)findWithAddress:(uint64_t)address;

- (NSEnumerator*)symbolEnumerator;

@end
