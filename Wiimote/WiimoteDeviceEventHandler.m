//
//  WiimoteDeviceEventHandler.m
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceEventHandler.h"

@interface WiimoteDeviceEventHandler (PrivatePart)

- (id)initWithTarget:(id)target action:(SEL)action;

@end

@implementation WiimoteDeviceEventHandler

+ (WiimoteDeviceEventHandler*)newHandlerWithTarget:(id)target
                                            action:(SEL)action
{
	return [[[WiimoteDeviceEventHandler alloc]
									initWithTarget:target
                                            action:action] autorelease];
}

- (id)init
{
	[[super init] release];
	return nil;
}

- (id)target
{
	return m_Target;
}

- (SEL)action
{
	return m_Action;
}

- (void)perform:(id)param
{
	if(m_Target != nil &&
	   m_Action	!= nil)
	{
		[m_Target performSelector:m_Action withObject:param];
	}
}

@end

@implementation WiimoteDeviceEventHandler (PrivatePart)

- (id)initWithTarget:(id)target action:(SEL)action
{
	self = [super init];
	if(self == nil)
		return nil;

	m_Target	 = target;
	m_Action	 = action;

	return self;
}

@end
