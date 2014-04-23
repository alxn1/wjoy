//
//  OCLog.h
//  OCLog
//
//  Created by alxn1 on 20.02.14.
//  Copyright 2014 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OCLogLevelError     = 0,
    OCLogLevelWarning   = 1,
    OCLogLevelDebug     = 2
} OCLogLevel;

#define OCL_DEBUG(msg)          OCL_MESSAGE(OCLogLevelDebug, @"%@", msg)
#define OCL_WARNING(msg)        OCL_MESSAGE(OCLogLevelWarning, @"%@", msg)
#define OCL_ERROR(msg)          OCL_MESSAGE(OCLogLevelError, @"%@", msg)

#define OCL_DEBUG_F(msg ...)    OCL_MESSAGE(OCLogLevelDebug, msg)
#define OCL_WARNING_F(msg ...)  OCL_MESSAGE(OCLogLevelWarning, msg)
#define OCL_ERROR_F(msg ...)    OCL_MESSAGE(OCLogLevelError, msg)

#define OCL_MESSAGE(lvl, msg ...)                                               \
            do                                                                  \
            {                                                                   \
                if(lvl <= [[OCLog sharedLog] level])                            \
                {                                                               \
                    [[OCLog sharedLog]                                          \
                                    level:lvl                                   \
                               sourceFile:__FILE__                              \
                                     line:__LINE__                              \
                             functionName:__PRETTY_FUNCTION__                   \
                                  message:[NSString stringWithFormat:msg]];     \
                }                                                               \
            }                                                                   \
            while(NO)

@class OCLog;

@protocol OCLogHandler

- (void)  log:(OCLog*)log
        level:(OCLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message;

@end

@interface OCDefaultLogHandler : NSObject< OCLogHandler >

+ (OCDefaultLogHandler*)defaultLogHandler;

@end

@interface OCLog : NSObject< OCLogHandler >
{
    @private
        OCLogLevel                   m_Level;
        NSObject< OCLogHandler >    *m_Handler;
}

+ (NSString*)levelAsString:(OCLogLevel)level;

+ (OCLog*)sharedLog;

- (OCLogLevel)level;
- (void)setLevel:(OCLogLevel)level;

- (NSObject< OCLogHandler >*)handler;
- (void)setHandler:(NSObject< OCLogHandler >*)handler;

- (void)level:(OCLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message;

@end
