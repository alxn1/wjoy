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
        NSArray *m_Signatures;
}

- (id)initWithIOManager:(WiimoteIOManager*)manager
             signatures:(NSArray*)signatures
                 target:(id)target
                 action:(SEL)action;

- (void)ioManagerDataReaded:(NSData*)data;

@end

@implementation WiimoteExtensionRoutineProbeHandler

- (id)initWithIOManager:(WiimoteIOManager*)manager
             signatures:(NSArray*)signatures
                 target:(id)target
                 action:(SEL)action
{
    self = [super initWithIOManager:manager target:target action:action];
    if(self == nil)
        return nil;

    m_Signatures = [signatures retain];

    if(m_Signatures			== nil ||
      [m_Signatures count]  == 0)
    {
        [self probeFinished:NO];
        [self release];
        return nil;
    }

    if(![manager readMemory:NSMakeRange(
								WiimoteDeviceRoutineExtensionProbeAddress,
								[[m_Signatures objectAtIndex:0] length])
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
    [m_Signatures release];
    [super dealloc];
}

- (void)ioManagerDataReaded:(NSData*)data
{
    if(data == nil)
    {
        [self release];
        return;
    }

    if([data length] < [[m_Signatures objectAtIndex:0] length])
    {
        [self probeFinished:NO];
        [self release];
        return;
    }

    BOOL		isOk			= NO;
	NSUInteger	countSignatures = [m_Signatures count];

	for(NSUInteger i = 0; i < countSignatures; i++)
	{
		if([[m_Signatures objectAtIndex:i] isEqualToData:data])
		{
			isOk = YES;
			break;
		}
	}

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
                                               signatures:[NSArray arrayWithObject:signature]
												   target:target
												   action:action];
}

+ (void)routineProbe:(WiimoteIOManager*)manager
		  signatures:(NSArray*)signatures
              target:(id)target
              action:(SEL)action
{
	[[WiimoteExtensionRoutineProbeHandler alloc]
										initWithIOManager:manager
                                               signatures:signatures
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
