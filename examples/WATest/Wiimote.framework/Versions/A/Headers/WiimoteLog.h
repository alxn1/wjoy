//
//  WiimoteLog.h
//  Wiimote
//
//  Created by alxn1 on 25.03.14.
//
//

#import <Foundation/Foundation.h>

// if WIIMOTE_USE_STDOUT_LOG not defined, WiimoteLog is a simple wrapper for OCLog framework,
// if WIIMOTE_USE_STDOUT_LOG defined - WiimoteLog write all information to stdout.

typedef enum WiimoteLogLevel {
    WiimoteLogLevelError    = 0,
    WiimoteLogLevelWarning  = 1,
    WiimoteLogLevelDebug    = 2
} WiimoteLogLevel;

#define W_DEBUG(msg)            W_MESSAGE(WiimoteLogLevelDebug, @"%@", msg)
#define W_WARNING(msg)          W_MESSAGE(WiimoteLogLevelWarning, @"%@", msg)
#define W_ERROR(msg)            W_MESSAGE(WiimoteLogLevelError, @"%@", msg)

#define W_DEBUG_F(msg ...)      W_MESSAGE(WiimoteLogLevelDebug, msg)
#define W_WARNING_F(msg ...)    W_MESSAGE(WiimoteLogLevelWarning, msg)
#define W_ERROR_F(msg ...)      W_MESSAGE(WiimoteLogLevelError, msg)

#define W_MESSAGE(lvl, msg ...)                                                 \
            do                                                                  \
            {                                                                   \
                if(lvl <= [[WiimoteLog sharedLog] level])                       \
                {                                                               \
                    [[WiimoteLog sharedLog]                                     \
                                        level:lvl                               \
                                   sourceFile:__FILE__                          \
                                         line:__LINE__                          \
                                 functionName:__PRETTY_FUNCTION__               \
                                      message:[NSString stringWithFormat:msg]]; \
                }                                                               \
            }                                                                   \
            while(NO)

@interface WiimoteLog : NSObject
{
    @private
        WiimoteLogLevel m_Level;
}

+ (NSString*)levelAsString:(WiimoteLogLevel)level;

+ (WiimoteLog*)sharedLog;

- (WiimoteLogLevel)level;
- (void)setLevel:(WiimoteLogLevel)level;

- (void)level:(WiimoteLogLevel)level
   sourceFile:(const char*)sourceFile
         line:(NSUInteger)line
 functionName:(const char*)functionName
      message:(NSString*)message;

@end
