//
//  WiimoteEventSystem+PlugIn.m
//  Wiimote
//
//  Created by alxn1 on 18.01.14.
//

#import "WiimoteEventSystem+PlugIn.h"

@implementation WiimoteEventSystem (PlugIn)

+ (NSMutableDictionary*)mutableNotificationDictionary
{
    static NSMutableDictionary *result = nil;

    if(result == nil)
        result = [[NSMutableDictionary alloc] init];

    return result;
}

+ (NSDictionary*)notificationDictionary
{
    return [WiimoteEventSystem mutableNotificationDictionary];
}

+ (void)registerNotification:(NSString*)name selector:(SEL)selector
{
    [[WiimoteEventSystem mutableNotificationDictionary]
                                    setObject:[NSValue valueWithPointer:selector]
                                       forKey:name];
}

- (void)postEventForWiimoteExtension:(WiimoteExtension*)extension path:(NSString*)path value:(CGFloat)value
{
    path = [NSString stringWithFormat:@"%@.%@", [extension name], path];

    [self postEvent:[WiimoteEvent eventWithWiimote:[extension owner] path:path value:value]];
}

- (void)postEventForWiimote:(Wiimote*)wiimote path:(NSString*)path value:(CGFloat)value
{
    [self postEvent:[WiimoteEvent eventWithWiimote:wiimote path:path value:value]];
}

- (void)postEvent:(WiimoteEvent*)event
{
    NSEnumerator *en        = [m_Observers objectEnumerator];
    id            object    = [en nextObject];

    while(object != nil)
    {
        [object wiimoteEvent:event];

        object = [en nextObject];
    }

    [[NSNotificationCenter defaultCenter]
                            postNotificationName:WiimoteEventSystemNotification
                                          object:self
                                        userInfo:[NSDictionary
                                                        dictionaryWithObject:event
                                                                      forKey:WiimoteEventKey]];
}

@end
