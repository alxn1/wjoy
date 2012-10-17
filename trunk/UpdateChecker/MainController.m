//
//  MainController.m
//  Updater
//
//  Created by alxn1 on 17.10.12.
//  Copyright 2012 Dr. Web. All rights reserved.
//

#import "MainController.h"

#import <UpdateChecker/UAppUpdateChecker.h>

@implementation MainController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(willStartNotification:)
                                           name:UAppUpdateCheckerWillStartNotification
                                         object:nil];

    [[NSNotificationCenter defaultCenter]
                                    addObserver:self
                                       selector:@selector(didFinishNotification:)
                                           name:UAppUpdateCheckerDidFinishNotification
                                         object:nil];
}

- (IBAction)start:(id)sender
{
    if(![[UAppUpdateChecker sharedInstance] run])
    {
        [[m_Log textStorage] appendAttributedString:
            [[[NSAttributedString alloc] initWithString:@"can't start checking :(\n"] autorelease]];
    }
}

- (void)willStartNotification:(NSNotification*)notification
{
    [m_StartButton setEnabled:NO];
    [[m_Log textStorage] appendAttributedString:
        [[[NSAttributedString alloc] initWithString:@"start check for new version...\n"] autorelease]];
}

- (void)didFinishNotification:(NSNotification*)notification
{
    [m_StartButton setEnabled:YES];
    [[m_Log textStorage] appendAttributedString:
        [[[NSAttributedString alloc] initWithString:@"finished.\n"] autorelease]];

    [[m_Log textStorage] appendAttributedString:
        [[[NSAttributedString alloc] initWithString:[[notification userInfo] description]] autorelease]];

    [[m_Log textStorage] appendAttributedString:
        [[[NSAttributedString alloc] initWithString:@"\n"] autorelease]];
}

@end
