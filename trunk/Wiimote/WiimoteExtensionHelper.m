//
//  WiimoteExtensionHelper.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtensionHelper.h"

@implementation WiimoteExtensionHelper

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithWiimote:(Wiimote*)wiimote
      eventDispatcher:(WiimoteEventDispatcher*)dispatcher
            ioManager:(WiimoteIOManager*)ioManager
     extensionClasses:(NSArray*)extensionClasses
               target:(id)target
               action:(SEL)action
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Wiimote           = wiimote;
    m_EventDispatcher   = dispatcher;
    m_IOManager         = ioManager;
    m_ExtensionClasses  = [extensionClasses mutableCopy];
    m_CurrentClass      = nil;
    m_Extension         = nil;

    m_IsStarted         = NO;
    m_IsCanceled        = NO;

    m_Target            = target;
    m_Action            = action;

    return self;
}

- (void)dealloc
{
    [m_ExtensionClasses release];
    [m_Extension release];
    [super dealloc];
}

- (void)beginProbe
{
    [self retain];
}

- (void)endProbe
{
    [self autorelease];
}

- (void)probeFinished:(WiimoteExtension*)extension
{
    if(m_Target != nil && m_Action != nil)
        [m_Target performSelector:m_Action withObject:extension afterDelay:0.0];

    [self endProbe];
}

- (void)probeNextClass
{
    if(m_IsCanceled)
    {
        [self endProbe];
        return;
    }

    if([m_ExtensionClasses count] == 0)
    {
        [self probeFinished:nil];
        return;
    }

    m_CurrentClass = [m_ExtensionClasses objectAtIndex:0];
    [m_ExtensionClasses removeObjectAtIndex:0];

    [m_CurrentClass probe:m_IOManager
                   target:self
                   action:@selector(currentClassProbeFinished:)];
}

- (void)currentClassProbeFinished:(NSNumber*)result
{
    if(m_IsCanceled)
    {
        [self endProbe];
        return;
    }

    if(![result boolValue])
    {
        [self probeNextClass];
        return;
    }

    m_Extension = [[m_CurrentClass alloc] initWithOwner:m_Wiimote
                                        eventDispatcher:m_EventDispatcher];

    if(m_Extension == nil)
    {
        [self probeNextClass];
        return;
    }

    [m_Extension initialize:m_IOManager
                     target:self
                     action:@selector(extensionInitialized:)];
}

- (void)extensionInitialized:(NSNumber*)result
{
    if(m_IsCanceled)
    {
        [self endProbe];
        return;
    }

    if(![result boolValue])
    {
        [m_Extension release];
        m_Extension = nil;

        [self probeNextClass];
    }

    [self probeFinished:m_Extension];
}

- (void)start
{
    if(m_IsStarted)
        return;

    [self probeNextClass];
}

- (void)cancel
{
    m_IsCanceled = YES;
}

@end
