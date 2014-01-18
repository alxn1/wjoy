//
//  WiimoteEventSystem.m
//  Wiimote
//
//  Created by Alxn1 on 18.01.14.
//

#import "WiimoteEventSystem+PlugIn.h"

@implementation NSObject (WiimoteEventSystemObserver)

- (void)wiimoteEvent:(WiimoteEvent*)event
{
}

@end

@implementation WiimoteEventSystem

+ (void)load
{
    [WiimoteEventSystem
            registerNotification:WiimoteConnectedNotification
                        selector:@selector(wiimoteConnectedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteExtensionConnectedNotification
                        selector:@selector(wiimoteExtensionConnectedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteExtensionDisconnectedNotification
                        selector:@selector(wiimoteExtensionDisconnectedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteDisconnectedNotification
                        selector:@selector(wiimoteDisconnectedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteButtonPresedNotification
                        selector:@selector(wiimoteButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteButtonReleasedNotification
                        selector:@selector(wiimoteButtonReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteNunchuckButtonPressedNotification
                        selector:@selector(wiimoteNunchuckButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteNunchuckButtonReleasedNotification
                        selector:@selector(wiimoteNunchuckButtonReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteNunchuckStickPositionChangedNotification
                        selector:@selector(wiimoteNunchuckStickPositionChangedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteClassicControllerButtonPressedNotification
                        selector:@selector(wiimoteClassicControllerButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteClassicControllerButtonReleasedNotification
                        selector:@selector(wiimoteClassicControllerButtonReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteClassicControllerStickPositionChangedNotification
                        selector:@selector(wiimoteClassicControllerStickPositionChangedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteClassicControllerAnalogShiftPositionChangedNotification
                        selector:@selector(wiimoteClassicControllerAnalogShiftPositionChangedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUProControllerButtonPressedNotification
                        selector:@selector(wiimoteUProControllerButtonPressedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUProControllerButtonReleasedNotification
                        selector:@selector(wiimoteUProControllerButtonReleasedNotification:)];

    [WiimoteEventSystem
            registerNotification:WiimoteUProControllerStickPositionChangedNotification
                        selector:@selector(wiimoteUProControllerStickPositionChangedNotification:)];
}

+ (void)subscribeToNotifications:(WiimoteEventSystem*)system
{
    NSNotificationCenter    *center = [NSNotificationCenter defaultCenter];
    NSDictionary            *map    = [WiimoteEventSystem notificationDictionary];
    NSEnumerator            *en     = [map keyEnumerator];
    NSString                *name   = [en nextObject];

    while(name != nil)
    {
        SEL selector = [[map objectForKey:name] pointerValue];

        [center addObserver:system
                   selector:selector
                       name:name
                     object:nil];

        name = [en nextObject];
    }
}

+ (WiimoteEventSystem*)defaultEventSystem
{
    static WiimoteEventSystem *result = nil;

    if(result == nil)
        result = [[WiimoteEventSystem alloc] init];

    return result;
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Observers = [[NSMutableSet alloc] init];

    [WiimoteEventSystem subscribeToNotifications:self];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [m_Observers release];
    [super dealloc];
}

- (void)addObserver:(id)observer
{
    [m_Observers addObject:observer];
}

- (void)removeObserver:(id)observer
{
    [m_Observers removeObject:observer];
}

- (NSString*)pathForWiimoteButton:(NSDictionary*)userInfo
{
    static NSString *result[] =
    {
        @"Button.Left",
        @"Button.Right",
        @"Button.Up",
        @"Button.Down",
        @"Button.A",
        @"Button.B",
        @"Button.Plus",
        @"Button.Minus",
        @"Button.Home",
        @"Button.One",
        @"Button.Two"
    };

    WiimoteButtonType type = [[userInfo objectForKey:WiimoteButtonKey] integerValue];

    return result[type];
}

- (NSString*)pathForNunchuckButton:(NSDictionary*)userInfo
{
    static NSString *result[] =
    {
        @"Button.C",
        @"Button.Z"
    };

    WiimoteNunchuckButtonType type = [[userInfo objectForKey:WiimoteNunchuckButtonKey] integerValue];

    return result[type];
}

- (NSString*)pathForClassicControllerButton:(NSDictionary*)userInfo
{
    static NSString *result[] =
    {
        @"Button.A",
        @"Button.B",
        @"Button.Minus",
        @"Button.Home",
        @"Button.Plus",
        @"Button.X",
        @"Button.Y",
        @"Button.Up",
        @"Button.Down",
        @"Button.Left",
        @"Button.Right",
        @"Button.L",
        @"Button.R",
        @"Button.ZL",
        @"Button.ZR"
    };

    WiimoteClassicControllerButtonType type = [[userInfo objectForKey:WiimoteClassicControllerButtonKey] integerValue];

    return result[type];
}

- (NSString*)pathForWiiUProControllerButton:(NSDictionary*)userInfo
{
    static NSString *result[] =
    {
        @"Button.Up",
        @"Button.Down",
        @"Button.Left",
        @"Button.Right",
        @"Button.A",
        @"Button.B",
        @"Button.X",
        @"Button.Y",
        @"Button.L",
        @"Button.R",
        @"Button.ZL",
        @"Button.ZR",
        @"Button.Left.Stick",
        @"Button.Right.Stick"
    };

    WiimoteUProControllerButtonType type = [[userInfo objectForKey:WiimoteUProControllerButtonKey] integerValue];

    return result[type];
}

- (void)wiimoteConnectedNotification:(NSNotification*)notification
{
    [self postEventForWiimote:[notification object]
                         path:@"Connect"
                        value:WIIMOTE_EVENT_VALUE_CONNECT];
}

- (void)wiimoteExtensionConnectedNotification:(NSNotification*)notification
{
    WiimoteExtension *extension = [[notification userInfo] objectForKey:WiimoteExtensionKey];

    [self postEventForWiimoteExceptions:extension
                                   path:@"Connect"
                                  value:WIIMOTE_EVENT_VALUE_CONNECT];
}

- (void)wiimoteExtensionDisconnectedNotification:(NSNotification*)notification
{
    WiimoteExtension *extension = [[notification userInfo] objectForKey:WiimoteExtensionKey];

    [self postEventForWiimoteExceptions:extension
                                   path:@"Disconnect"
                                  value:WIIMOTE_EVENT_VALUE_DISCONNECT];
}

- (void)wiimoteDisconnectedNotification:(NSNotification*)notification
{
    [self postEventForWiimote:[notification object]
                         path:@"Disconnect"
                        value:WIIMOTE_EVENT_VALUE_DISCONNECT];
}

- (void)wiimoteButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimote:[notification object]
                         path:[self pathForWiimoteButton:[notification userInfo]]
                        value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimote:[notification object]
                         path:[self pathForWiimoteButton:[notification userInfo]]
                        value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)wiimoteNunchuckButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExceptions:[notification object]
                                   path:[self pathForNunchuckButton:[notification userInfo]]
                                  value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteNunchuckButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExceptions:[notification object]
                                   path:[self pathForNunchuckButton:[notification userInfo]]
                                  value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)wiimoteNunchuckStickPositionChangedNotification:(NSNotification*)notification
{
    NSPoint position = [[[notification userInfo] objectForKey:WiimoteNunchuckStickPositionKey] pointValue];

    [self postEventForWiimoteExceptions:[notification object]
                                   path:@"Stick.X"
                                  value:position.x];

    [self postEventForWiimoteExceptions:[notification object]
                                   path:@"Stick.Y"
                                  value:position.y];
}

- (void)wiimoteClassicControllerButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExceptions:[notification object]
                                   path:[self pathForClassicControllerButton:[notification userInfo]]
                                  value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteClassicControllerButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExceptions:[notification object]
                                   path:[self pathForClassicControllerButton:[notification userInfo]]
                                  value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)wiimoteClassicControllerStickPositionChangedNotification:(NSNotification*)notification
{
    WiimoteClassicControllerStickType type      = [[[notification userInfo] objectForKey:WiimoteClassicControllerStickKey] integerValue];
    NSPoint                           position  = [[[notification userInfo] objectForKey:WiimoteClassicControllerStickPositionKey] pointValue];

    switch(type) {
        case WiimoteClassicControllerStickTypeLeft: {
            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Left.Stick.X"
                                          value:position.x];

            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Left.Stick.Y"
                                          value:position.y];
            break;
        }

        case WiimoteClassicControllerStickTypeRight: {
            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Right.Stick.X"
                                          value:position.x];

            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Right.Stick.Y"
                                          value:position.y];
            break;
        }
    }
}

- (void)wiimoteClassicControllerAnalogShiftPositionChangedNotification:(NSNotification*)notification
{
    WiimoteClassicControllerAnalogShiftType type        = [[[notification userInfo] objectForKey:WiimoteClassicControllerAnalogShiftKey] integerValue];
    CGFloat                                 position    = [[[notification userInfo] objectForKey:WiimoteClassicControllerAnalogShiftPositionKey] doubleValue];

    switch(type) {
        case WiimoteClassicControllerStickTypeLeft: {
            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Left.Shift"
                                          value:position];
            break;
        }

        case WiimoteClassicControllerStickTypeRight: {
            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Right.Shift"
                                          value:position];
            break;
        }
    }
}

- (void)wiimoteUProControllerButtonPressedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExceptions:[notification object]
                                   path:[self pathForWiiUProControllerButton:[notification userInfo]]
                                  value:WIIMOTE_EVENT_VALUE_PRESS];
}

- (void)wiimoteUProControllerButtonReleasedNotification:(NSNotification*)notification
{
    [self postEventForWiimoteExceptions:[notification object]
                                   path:[self pathForWiiUProControllerButton:[notification userInfo]]
                                  value:WIIMOTE_EVENT_VALUE_RELEASE];
}

- (void)wiimoteUProControllerStickPositionChangedNotification:(NSNotification*)notification
{
    WiimoteUProControllerStickType  type      = [[[notification userInfo] objectForKey:WiimoteUProControllerStickKey] integerValue];
    NSPoint                         position  = [[[notification userInfo] objectForKey:WiimoteUProControllerStickPositionKey] pointValue];

    switch(type) {
        case WiimoteUProControllerStickTypeLeft: {
            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Left.Stick.X"
                                          value:position.x];

            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Left.Stick.Y"
                                          value:position.y];
            break;
        }

        case WiimoteUProControllerStickTypeRight: {
            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Right.Stick.X"
                                          value:position.x];

            [self postEventForWiimoteExceptions:[notification object]
                                           path:@"Right.Stick.Y"
                                          value:position.y];
            break;
        }
    }
}

@end
