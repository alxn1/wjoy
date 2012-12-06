//
//  NSMatrix+ToolTipItem.m
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NSMatrix+ToolTipItem.h"

@implementation NSMatrixToolTipItem

- (id)initWithCell:(NSCell*)cell owner:(NSMatrix*)owner
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Cell  = cell;
    m_Owner = owner;

    return self;
}

- (NSString*)toolTip
{
    return [m_Owner toolTipForCell:m_Cell];
}

- (void)setToolTip:(NSString*)toolTip
{
    [m_Owner setToolTip:toolTip forCell:m_Cell];
}

@end

@implementation NSMatrix (ToolTipItem)

- (NSArray*)toolTipItems
{
    NSArray             *cells       = [self cells];
    NSUInteger           countCells  = [cells count];
    NSMutableArray      *result      = [NSMutableArray arrayWithCapacity:countCells];
    NSMatrixToolTipItem *item        = nil;

    for(NSUInteger i = 0; i < countCells; i++)
    {
        item = [[NSMatrixToolTipItem alloc] initWithCell:[cells objectAtIndex:i] owner:self];
        [result addObject:item];
        [item release];
    }

    return result;
}

@end
