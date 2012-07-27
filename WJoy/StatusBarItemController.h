//
//  StatusBarItemController.h
//  WJoy
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusBarItemController : NSObject
{
    @private
        NSMenu          *m_Menu;
        NSStatusItem    *m_Item;
        NSMenuItem      *m_DiscoveryMenuItem;
}

+ (void)start;

@end
