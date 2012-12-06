//
//  NSComboBox+Items.h
//  XibLocalization
//
//  Created by alxn1 on 05.12.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSComboBoxItem : NSObject
{
    @private
        NSComboBox  *m_Owner;
        NSUInteger   m_Index;
}

- (NSString*)title;
- (void)setTitle:(NSString*)title;

@end

@interface NSComboBox (Items)

- (NSArray*)items;

@end
