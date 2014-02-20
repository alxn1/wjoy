//
//  MainController.m
//  OCLog
//
//  Created by alxn1 on 20.02.14.
//  Copyright 2014 Dr. Web. All rights reserved.
//

#import "MainController.h"

@implementation MainController

- (void)awakeFromNib
{
    [[OCLog sharedLog] setLevel:OCLogLevelDebug];
    [[OCLog sharedLog] setHandler:self];
}

- (IBAction)clearLog:(id)sender
{
    [m_Log setString:@""];
}

- (IBAction)log:(id)sender
{
    OCL_MESSAGE([m_UserLogLevel selectedTag], @"%@", [m_UserInput stringValue]);
}

- (void)  log:(OCLog*)log
        level:(OCLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message
{
    NSString *msg = [NSString stringWithFormat:
                                        @"%@: %s (%llu), %s: %@\n",
                                        [OCLog levelAsString:level],
                                        sourceFile,
                                        (unsigned long long)line,
                                        functionName,
                                        message];

    [[m_Log textStorage] appendAttributedString:
        [[[NSAttributedString alloc] initWithString:msg] autorelease]];
}

@end
