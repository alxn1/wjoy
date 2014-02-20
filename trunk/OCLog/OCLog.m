//
//  OCLog.m
//  OCLog
//
//  Created by alxn1 on 20.02.14.
//  Copyright 2014 alxn1. All rights reserved.
//

#import "OCLog.h"

@implementation OCDefaultLogHandler

+ (OCDefaultLogHandler*)defaultLogHandler
{
    static OCDefaultLogHandler *result = nil;

    if(result == nil)
        result = [[OCDefaultLogHandler alloc] init];

    return result;
}

- (void)  log:(OCLog*)log
        level:(OCLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message
{
    NSLog(@"%@: %s (%llu) [%s]: %@",
        [OCLog levelAsString:level], sourceFile, (unsigned long long)line, functionName, message);
}

@end

@implementation OCLog

+ (NSString*)levelAsString:(OCLogLevel)level
{
    NSString *result = @"UNKNOWN";

    switch(level)
    {
        case OCLogLevelError:
            result = @"ERROR";
            break;

        case OCLogLevelWarning:
            result = @"WARNING";
            break;

        case OCLogLevelDebug:
            result = @"DEBUG";
            break;
    }

    return result;
}

+ (OCLog*)sharedLog
{
    static OCLog *result = nil;

    if(result == nil)
        result = [[OCLog alloc] init];

    return result;
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Handler   = [[OCDefaultLogHandler defaultLogHandler] retain];
    m_Level     = OCLogLevelError;

    return self;
}

- (void)dealloc
{
    [m_Handler release];
    [super dealloc];
}

- (OCLogLevel)level
{
    return m_Level;
}

- (void)setLevel:(OCLogLevel)level
{
    m_Level = level;
}

- (NSObject< OCLogHandler >*)handler
{
    return [[m_Handler retain] autorelease];
}

- (void)setHandler:(NSObject< OCLogHandler >*)handler
{
    [m_Handler autorelease];
    m_Handler = [handler retain];
}

- (void)level:(OCLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message
{
    [m_Handler log:self
             level:level
        sourceFile:sourceFile
              line:line
      functionName:functionName
           message:message];
}

- (void)  log:(OCLog*)log
        level:(OCLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message
{
    [m_Handler log:self
             level:level
        sourceFile:sourceFile
              line:line
      functionName:functionName
           message:message];
}

@end
