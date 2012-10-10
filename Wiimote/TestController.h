//
//  TestController.h
//  Wiimote
//
//  Created by alxn1 on 09.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WiimoteWrapper.h"

@interface TestController : NSObject
{
    @private
        IBOutlet NSTextView     *m_Log;
        IBOutlet NSButton       *m_DiscoveryButton;
        IBOutlet NSTextField    *m_ConnectedTextField;

        NSUInteger               m_ConnectedWiimotes;
        BOOL                     m_IsDiscovering;
}

- (IBAction)discovery:(id)sender;
- (IBAction)clearLog:(id)sender;

@end
