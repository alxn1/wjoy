//
//  NSSegmentedControl+Items.m
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NSSegmentedControl+Items.h"

@implementation NSSegmentedControlItem : NSObject
{
    @private
        NSSegmentedControl  *m_Owner;
        NSUInteger           m_Index;
}

- (id)initWithIndex:(NSUInteger)index owner:(NSSegmentedControl*)owner
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Index = index;
    m_Owner = owner;

    return self;
}

- (NSString*)title
{
    return [m_Owner labelForSegment:m_Index];
}

- (void)setTitle:(NSString*)title
{
    [m_Owner setLabel:title forSegment:m_Index];
}

- (NSMenu*)menu
{
    return [m_Owner menuForSegment:m_Index];
}

@end

@implementation NSSegmentedControl (Items)

- (NSArray*)items
{
    NSUInteger               countItems  = [self segmentCount];
    NSMutableArray          *result      = [NSMutableArray arrayWithCapacity:countItems];
    NSSegmentedControlItem  *item        = nil;

    for(NSUInteger i = 0; i < countItems; i++)
    {
        item = [[NSSegmentedControlItem alloc] initWithIndex:i owner:self];
        [result addObject:item];
        [item release];
    }

    return result;
}

@end
