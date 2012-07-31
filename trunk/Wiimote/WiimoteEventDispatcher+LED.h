//
//  WiimoteEventDispatcher+LED.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher.h"

@interface WiimoteEventDispatcher (LED)

- (void)postHighlightedLEDMaskChangedNotification:(NSUInteger)mask;

@end
