//
//  WiimoteEventDispatcher+IR.h
//  Wiimote
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher.h"

@class WiimoteIRPoint;

@interface WiimoteEventDispatcher (IR)

- (void)postIREnabledStateChangedNotification:(BOOL)enabled;
- (void)postIRPointPositionChangedNotification:(WiimoteIRPoint*)point;

@end
