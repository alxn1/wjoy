//
//  TestController.h
//  Wiimote
//
//  Created by alxn1 on 09.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <OCLog/OCLog.h>

@interface TestController : NSObject< OCLogHandler >
{
    @private
        IBOutlet NSTextView     *m_Log;
        IBOutlet NSButton       *m_DiscoveryButton;
        IBOutlet NSTextField    *m_ConnectedTextField;
        IBOutlet NSButton       *m_DebugCheckBox;

        NSUInteger               m_ConnectedWiimotes;
        BOOL                     m_IsDiscovering;
}

- (IBAction)toggleUseOneButtonClickConnection:(id)sender;
- (IBAction)toggleDebugOutput:(id)sender;
- (IBAction)discovery:(id)sender;
- (IBAction)clearLog:(id)sender;
- (IBAction)detectMotionPlus:(id)sender;
- (IBAction)toggleVibration:(id)sender;

@end
