//
//  XibObjectInspector.m
//  XibLocalization
//
//  Created by alxn1 on 03.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "XibObjectInspector+PlugIn.h"
#import "XibObjectProperty.h"

@interface XibObjectInspector (PrivatePart)

+ (NSMutableArray*)registredClasses;

- (void)setXibObject:(id)xibObject;

- (BOOL)isCanHandleObject:(id)object partially:(BOOL*)isPartially;

@end

@implementation XibObjectInspector (PrivatePart)

+ (NSMutableArray*)registredClasses
{
    static NSMutableArray *result = nil;

    if(result == nil)
        result = [[NSMutableArray alloc] init];

    return result;
}

- (void)setXibObject:(id)xibObject
{
    m_XibObject = xibObject;
}

- (BOOL)isCanHandleObject:(id)object partially:(BOOL*)isPartially
{
    Class    cls                = [object class];
    NSSet   *handledClassNames  = [self handledXibClassNames];

    while(cls != nil)
    {
        if([handledClassNames containsObject:[cls className]])
        {
            if(isPartially != NULL)
                *isPartially = ([object class] != cls);

            return YES;
        }

        cls = [cls superclass];
    }

    return NO;
}

@end

@implementation XibObjectInspector (PlugIn)

+ (void)registerSubClass:(Class)cls
{
    NSAutoreleasePool   *pool   = [[NSAutoreleasePool alloc] init];
    XibObjectInspector  *object = [[cls alloc] init];

    [[XibObjectInspector registredClasses] addObject:object];
    [object release];
    [pool release];
}

- (id)xibObject
{
    return m_XibObject;
}

- (BOOL)extractProperty:(NSMutableArray*)propertiesArray
              getMethod:(SEL)getMethod
              setMethod:(SEL)setMethod
{
    return [XibObjectProperty addTo:propertiesArray
                              owner:[self xibObject]
                          getMethod:getMethod
                          setMethod:setMethod];
}

- (BOOL)extractChildren:(NSMutableArray*)childrenArray method:(SEL)method
{
    if([[self xibObject] respondsToSelector:method])
    {
        id children = [[self xibObject] performSelector:method];

        if(children != nil)
        {
            if([children isKindOfClass:[NSArray class]])
                [childrenArray addObjectsFromArray:children];
            else
                [childrenArray addObject:children];

            return YES;
        }
    }

    return NO;
}

- (NSSet*)handledXibClassNames
{
    return nil;
}

- (void)extractProperties:(NSMutableArray*)propertiesArray
{
}

- (void)extractChildren:(NSMutableArray*)childrenArray
{
}

@end

@implementation XibObjectInspector

+ (void)extractXibObject:(id)xibObject
              properties:(NSMutableArray*)properties
                children:(NSMutableArray*)children
{
    NSArray             *plugins            = [XibObjectInspector registredClasses];
    NSUInteger           countPlugins       = [plugins count];
    XibObjectInspector  *plugin             = nil;

    BOOL                 isNotHandled       = YES;
    BOOL                 isFullyHandled     = NO;
    BOOL                 isPartiallyHandled = NO;

    for(NSUInteger i = 0; i < countPlugins; i++)
    {
        plugin = [plugins objectAtIndex:i];

        if([plugin isCanHandleObject:xibObject
                           partially:&isPartiallyHandled])
        {
            [plugin setXibObject:xibObject];
            [plugin extractChildren:children];
            [plugin extractProperties:properties];

            if(!isPartiallyHandled)
                isFullyHandled = YES;

            isNotHandled = NO;
        }
    }

#ifdef XIB_LOCALIZATION_DEBUG

    if(!isFullyHandled)
    {
        NSBundle *bundle = [NSBundle bundleForClass:[xibObject class]];

        if(isNotHandled)
        {
            NSLog(
                @"[DEBUG] XibLocalizableObject: non-localized object with class: "
                    @"%@ {%@ (%@)}",
                [xibObject className],
                [[bundle bundlePath] lastPathComponent],
                [bundle bundleIdentifier]);
        }
        else
        {
            NSLog(
                @"[DEBUG] XibLocalizableObject: partially-localized object with class: "
                    @"%@ {%@ (%@)}",
                [xibObject className],
                [[bundle bundlePath] lastPathComponent],
                [bundle bundleIdentifier]);
        }
    }

#endif /* XIB_LOCALIZATION_DEBUG */
}

@end
