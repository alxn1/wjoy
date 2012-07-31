//
//  WiimoteDeviceEventHandler.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceReport.h"

@interface WiimoteDeviceEventHandler : NSObject
{
	@private
		id      m_Target;
		SEL     m_Action;
}

+ (WiimoteDeviceEventHandler*)newHandlerWithTarget:(id)target action:(SEL)action;

- (id)target;
- (SEL)action;

- (void)perform:(id)param;

@end
