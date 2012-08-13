//
//  MainController.h
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IceView;

@interface MainController : NSObject
{
    @private
        IBOutlet NSWindow   *m_Window;
        IBOutlet IceView    *m_IceView;
        IBOutlet NSMenu     *m_StatusBarMenu;
        IBOutlet NSMenuItem *m_MoutionBlurMenuItem;

        NSStatusItem        *m_StatusBarItem;
}

- (IBAction)toggleMoutionBlur:(id)sender;
- (IBAction)exit:(id)sender;

@end
