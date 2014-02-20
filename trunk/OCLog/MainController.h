//
//  MainController.h
//  OCLog
//
//  Created by alxn1 on 20.02.14.
//  Copyright 2014 Dr. Web. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <OCLog/OCLog.h>

@interface MainController : NSObject< OCLogHandler >
{
    @private
        IBOutlet NSTextView     *m_Log;
        IBOutlet NSPopUpButton  *m_UserLogLevel;
        IBOutlet NSTextField    *m_UserInput;
}

- (IBAction)clearLog:(id)sender;
- (IBAction)log:(id)sender;

@end
