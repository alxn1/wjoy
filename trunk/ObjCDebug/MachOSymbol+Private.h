//
//  MachOSymbol+Private.h
//  ObjCDebug
//
//  Created by alxn1 on 26.11.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "MachOSymbol.h"

@interface MachOSymbol (Private)

+ (MachOSymbol*)symbolWithName:(NSString*)name info32:(const struct nlist*)info;
+ (MachOSymbol*)symbolWithName:(NSString*)name info:(const struct nlist_64*)info;

- (id)initWithName:(NSString*)name info:(const struct nlist_64*)info;

@end
