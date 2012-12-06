//
//  NSComboBox+Items.m
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NSComboBox+Items.h"

@implementation NSComboBoxItem

- (id)initWithIndex:(NSUInteger)index owner:(NSComboBox*)owner
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Owner = owner;
    m_Index = index;

    return self;
}

- (NSString*)title
{
    return [m_Owner itemObjectValueAtIndex:m_Index];
}

- (void)setTitle:(NSString*)title
{
    [m_Owner removeItemAtIndex:m_Index];
    [m_Owner insertItemWithObjectValue:title atIndex:m_Index];
}

@end

@implementation NSComboBox (Items)

- (NSArray*)items
{
    NSUInteger      countItems  = [self numberOfItems];
    NSMutableArray *result      = [NSMutableArray arrayWithCapacity:countItems];
    NSComboBoxItem *item        = nil;

    for(NSUInteger i = 0; i < countItems; i++)
    {
        item = [[NSComboBoxItem alloc] initWithIndex:i owner:self];
        [result addObject:item];
        [item release];
    }

    return result;
}

@end
