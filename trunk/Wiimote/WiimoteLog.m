//
//  WiimoteLog.m
//  Wiimote
//
//  Created by alxn1 on 25.03.14.
//
//

#import "WiimoteLog.h"

#ifndef WIIMOTE_USE_STDOUT_LOG
    #import <OCLog/OCLog.h>
#endif

@implementation WiimoteLog

+ (NSString*)levelAsString:(WiimoteLogLevel)level
{
    NSString *result = @"UNKNOWN";

    switch(level)
    {
        case WiimoteLogLevelError:
            result = @"ERROR";
            break;

        case WiimoteLogLevelWarning:
            result = @"WARNING";
            break;

        case WiimoteLogLevelDebug:
            result = @"DEBUG";
            break;
    }

    return result;
}

+ (WiimoteLog*)sharedLog
{
    static WiimoteLog *result = nil;

    if(result == nil)
        result = [[WiimoteLog alloc] init];

    return result;
}

- (id)init
{
    self = [super init];

    if(self == nil)
        return nil;

    m_Level = WiimoteLogLevelError;

    return self;
}

#ifndef WIIMOTE_USE_STDOUT_LOG

- (OCLogLevel)ocLogLevel:(WiimoteLogLevel)level
{
    OCLogLevel result = OCLogLevelDebug;

    switch(level) {
        case WiimoteLogLevelWarning:
            result = OCLogLevelWarning;
            break;

        case WiimoteLogLevelError:
            result = OCLogLevelError;
            break;

        default:
            break;
    }

    return result;
}

- (WiimoteLogLevel)wiimoteLogLevel:(OCLogLevel)level
{
    WiimoteLogLevel result = WiimoteLogLevelDebug;

    switch(level) {
        case OCLogLevelWarning:
            result = WiimoteLogLevelWarning;
            break;

        case OCLogLevelError:
            result = WiimoteLogLevelError;
            break;

        default:
            break;
    }

    return result;
}

#endif /* WIIMOTE_USE_STDOUT_LOG */

- (WiimoteLogLevel)level
{
#ifndef WIIMOTE_USE_STDOUT_LOG
    return [self wiimoteLogLevel:[[OCLog sharedLog] level]];
#else
    return m_Level;
#endif
}

- (void)setLevel:(WiimoteLogLevel)level
{
#ifndef WIIMOTE_USE_STDOUT_LOG
    [[OCLog sharedLog] setLevel:[self ocLogLevel:level]];
#else
    m_Level = level;
#endif
}

- (void)level:(WiimoteLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message
{
#ifndef WIIMOTE_USE_STDOUT_LOG

    [[OCLog sharedLog]
                    level:[self ocLogLevel:level]
               sourceFile:sourceFile
                     line:line
             functionName:functionName
                  message:message];

#else /* WIIMOTE_USE_STDOUT_LOG */

    NSLog(@"%@: %s (%llu) [%s]: %@",
        [WiimoteLog levelAsString:level], sourceFile, (unsigned long long)line, functionName, message);

#endif /* WIIMOTE_USE_STDOUT_LOG */
}

@end

