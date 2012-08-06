//
//  WiimotePart.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReport.h"
#import "WiimoteEventDispatcher.h"
#import "WiimoteIOManager.h"

@interface WiimotePart : NSObject
{
    @private
        Wiimote                 *m_Owner;
        WiimoteEventDispatcher  *m_EventDispatcher;
        WiimoteIOManager        *m_IOManager;
}

+ (void)registerPartClass:(Class)cls;

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager;

- (Wiimote*)owner;
- (WiimoteIOManager*)ioManager;
- (WiimoteEventDispatcher*)eventDispatcher;

- (NSSet*)allowedReportTypeSet;

- (void)connected;
- (void)handleReport:(WiimoteDeviceReport*)report;
- (void)disconnected;

@end

/*
    WiimotePart - it's base class for all Wiimote internal parts.
    You can create subclass of WiimotePart, register it with

    + (void)registerPartClass:(Class)cls;

    and this new subclass after what will be created for all newly
    connected wiimotes :)

    Subclass allow you to handle all report from device, post notifications,
    and call wiimote object delegate methods.

    You can add WiimoteEventDispatcher cathegory for sending new event types,
    and add cathegory to WiimoteDelegate (and call this methods from WiimoteEventDispatcher
    cathegory methods). It's simplify code, i think.


    Small example:

    #import "Wiimote+PlugIn.h"

    @interface NSObject (WiimoteDelegate+MyPartEvents)

    - (void)wiimote:(Wiimote*)wiimote newEvent:(BOOL)param;

    @end

    @implementation NSObject (WiimoteDelegate+MyPartEvents)

    - (void)wiimote:(Wiimote*)wiimote newEvent:(BOOL)param
    {
    }

    @end

    @interface WiimoteEventDispatcher (MyPartEvents)

    - (void)postNewEvent:(BOOL)param;

    @end

    @implementation WiimoteEventDispatcher (MyPartEvents)

    - (void)postNewEvent:(BOOL)param
    {
        [[self delegate] wiimote:[self owner] newEvent:param];
    }

    @end

    @interface MyPart : WiimotePart
    {
        @private
            BOOL enabled;
    }

    - (BOOL)enabled;
    - (void)setEnabled:(BOOL)flag;
    
    @end

    @implementation MyPart

    + (void)load
    {
        [WiimotePart registerPartClass:[MyPart class]];
    }

    - (id)initWithOwner:(Wiimote*)owner
        eventDispatcher:(WiimoteEventDispatcher*)dispatcher
              ioManager:(WiimoteIOManager*)ioManager
    {
        self = [super initWithOwner:owner evenDispatcher:dispatcher ioManager:ioManager];
        if(self == nil)
            return nil;

        enabled = YES;
        return self;
    }

    - (BOOL)enabled
    {
        return enabled;
    }

    - (void)setEnabled:(BOOL)flag
    {
        enabled = flag;
    }

    - (void)handleReport:(WiimoteDeviceReport*)report
    {
        if(enabled)
            [[self eventManager] postNewEvent:([report length] > 5)];
    }

    @end

    @interface Wiimote (MyPart)

    - (BOOL)isMyPartEnabled;
    - (void)setMyPartEnabled:(BOOL)flag;
    
    @end

    @implementation Wiimote (MyPart)

    - (BOOL)isMyPartEnabled
    {
        return [(MyPart*)[self partWithClass:[MyPart class]] isEnabled];
    }

    - (void)setMyPartEnabled:(BOOL)flag
    {
        [(MyPart*)[self partWithClass:[MyPart class]] setEnabled:flag];
    }

    @end

    It's simple WiimotePart, what can send events, handle device reports,
    and add some methods (- (BOOL)isMyPartEnabled; - (void)setMyPartEnabled:(BOOL)flag;)
    to Wiimote class.

    I think, it's simple, and useful (if needed). :)

    Methods:

    // init method, owweride it in subclasses, if needed.
    // But not use here ioManager - device already disconnected, and ioManager
    // will fail.
    - (id)initWithOwner:(Wiimote*)owner
        eventDispatcher:(WiimoteEventDispatcher*)dispatcher
              ioManager:(WiimoteIOManager*)ioManager;

    // owner of part, can be accessed all time.
    - (Wiimote*)owner;

    // ioManager, can be accessed all time.
    - (WiimoteIOManager*)ioManager;

    // event dispatcher. Can be accessed all time. Subclass can be generate notifications or events.
    - (WiimoteEventDispatcher*)eventDispatcher;

    // nil, if you can handle all report types, or NSSet of NSNumbers with allowed report types (WiimoteDeviceReportType).
    // It's only hint, Wiimote can set other report types for reporting from hardware, you need to
    // handle this situation.
    - (NSSet*)allowedReportTypeSet;

    // called after connecting to new wiimote. You can initialize here additional parts
    // (may be read some data from Wiimote, or write. From here you can use ioManager).
    - (void)connected;

    // report data from device. You can handle it, or simply ignore.
    - (void)handleReport:(WiimoteDeviceReport*)report;

    // called on disconnecting from device. ioManager not work here,
    // and you can only reset state of object to disconnected.
    - (void)disconnected;
*/
