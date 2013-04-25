//
//  NSObject+DMGEULA.m
//  DMGEULA
//
//  Created by alxn1 on 25.04.13.
//  Copyright 2013 alxn1. All rights reserved.
//

#import "NSObject+DMGEULA.h"

@implementation NSObject (DMGEULA)

- (id)asType:(Class)cls
{
    if([self isKindOfClass:cls])
        return self;

    return nil;
}

@end
