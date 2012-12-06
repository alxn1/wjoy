//
//  XibObjectProperty.h
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface XibObjectProperty : NSObject
{
    @private
        id  m_Owner;
        SEL m_GetMethod;
        SEL m_SetMethod;
}

+ (BOOL)addTo:(NSMutableArray*)propertyArray
        owner:(id)owner
    getMethod:(SEL)getMethod
    setMethod:(SEL)setMethod;

+ (XibObjectProperty*)propertyWithOwner:(id)owner
                              getMethod:(SEL)getMethod
                              setMethod:(SEL)setMethod;

- (id)initWithOwner:(id)owner
          getMethod:(SEL)getMethod
          setMethod:(SEL)setMethod;

- (NSString*)value;
- (void)setValue:(NSString*)value;

- (id)owner;

@end
