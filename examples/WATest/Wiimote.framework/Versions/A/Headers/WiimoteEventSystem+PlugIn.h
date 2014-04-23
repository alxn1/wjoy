//
//  WiimoteEventSystem+PlugIn.h
//  Wiimote
//
//  Created by alxn1 on 18.01.14.
//

#import <Wiimote/WiimoteEventSystem.h>

@interface WiimoteEventSystem (PlugIn)

+ (NSDictionary*)notificationDictionary;

+ (void)registerNotification:(NSString*)name selector:(SEL)selector;

- (void)postEventForWiimoteExceptions:(WiimoteExtension*)extension path:(NSString*)path value:(CGFloat)value;
- (void)postEventForWiimote:(Wiimote*)wiimote path:(NSString*)path value:(CGFloat)value;
- (void)postEvent:(WiimoteEvent*)event;

@end
