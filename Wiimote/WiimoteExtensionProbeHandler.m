//
//  WiimoteExtensionProbeHandler.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtensionProbeHandler.h"
#import "WiimoteExtension+PlugIn.h"

@interface WiimoteExtensionRoutineProbeHandler : WiimoteExtensionProbeHandler
{
    @private
        NSData *m_Signature;
}

- (id)initWithIOManager:(WiimoteIOManager*)manager
              signature:(NSData*)signature
                 target:(id)target
                 action:(SEL)action;

- (void)ioManagerDataReaded:(NSData*)data;

@end

@implementation WiimoteExtensionRoutineProbeHandler

- (id)initWithIOManager:(WiimoteIOManager*)manager
              signature:(NSData*)signature
                 target:(id)target
                 action:(SEL)action
{
    self = [super initWithIOManager:manager target:target action:action];
    if(self == nil)
        return nil;

    m_Signature = [signature retain];

    if(m_Signature          == nil ||
      [m_Signature length]  == 0)
    {
        [self probeFinished:NO];
        [self release];
        return nil;
    }

    if(![manager readMemory:NSMakeRange(WiimoteDeviceRoutineProbeAddress, [m_Signature length])
                     target:self
                     action:@selector(ioManagerDataReaded:)])
    {
        [self probeFinished:NO];
        [self release];
        return nil;
    } 

    return self;
}

- (void)dealloc
{
    [m_Signature release];
    [super dealloc];
}

- (void)ioManagerDataReaded:(NSData*)data
{
    if(data == nil)
    {
        [self release];
        return;
    }

    if([data length] < [m_Signature length])
    {
        [self probeFinished:NO];
        [self release];
        return;
    }

    BOOL isOk = (memcmp([data bytes], [m_Signature bytes], [m_Signature length]) == 0);

    [self probeFinished:isOk];
    [self release];
}

@end

@implementation WiimoteExtensionProbeHandler

+ (void)routineProbe:(WiimoteIOManager*)manager
           signature:(NSData*)signature
              target:(id)target
              action:(SEL)action
{
	[[WiimoteExtensionRoutineProbeHandler alloc]
										initWithIOManager:manager
												signature:signature
												   target:target
												   action:action];
}

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithIOManager:(WiimoteIOManager*)manager
                 target:(id)target
                 action:(SEL)action
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Target = target;
    m_Action = action;

    return self;
}

- (void)probeFinished:(BOOL)result
{
    [WiimoteExtension probeFinished:result target:m_Target action:m_Action];
}

@end
