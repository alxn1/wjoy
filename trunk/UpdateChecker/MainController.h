//
//  MainController.h
//  Updater
//
//  Created by alxn1 on 17.10.12.
//  Copyright 2012 Dr. Web. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainController : NSObject
{
    @private
        IBOutlet NSTextView *m_Log;
        IBOutlet NSButton   *m_StartButton;
}

- (IBAction)start:(id)sender;

@end
