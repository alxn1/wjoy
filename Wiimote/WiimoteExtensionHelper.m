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
         subExtension:(WiimoteExtension*)extension
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
    m_SubExtension      = [extension retain];

    m_IsInitialized     = NO;
    m_IsStarted         = NO;
    m_IsCanceled        = NO;

    m_Target            = target;
    m_Action            = action;

    return self;
}

- (void)dealloc
{
    [m_ExtensionClasses release];
    [m_SubExtension release];
    [m_Extension release];
    [super dealloc];
}

- (void)initializeExtensionPort
{
    uint8_t data;

    data = WiimoteDeviceRoutineExtensionInitValue1;
    [m_IOManager writeMemory:WiimoteDeviceRoutineExtensionInitAddress1 data:&data length:sizeof(data)];
	usleep(50000);

    data = WiimoteDeviceRoutineExtensionInitValue2;
    [m_IOManager writeMemory:WiimoteDeviceRoutineExtensionInitAddress2 data:&data length:sizeof(data)];
	usleep(50000);

    m_IsInitialized = YES;
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

    if(!m_IsInitialized &&
       [m_CurrentClass merit] >= WiimoteExtensionMeritClassSystemHigh)
    {
        [self initializeExtensionPort];
    }

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

    [m_Extension calibrate:m_IOManager];
	[self probeFinished:m_Extension];
}

- (WiimoteExtension*)subExtension
{
	return [[m_SubExtension retain] autorelease];
}

- (void)start
{
    if(m_IsStarted)
        return;

    m_IsInitialized = NO;
	[self beginProbe];
    [self probeNextClass];
}

- (void)cancel
{
    m_IsCanceled = YES;
}

@end
