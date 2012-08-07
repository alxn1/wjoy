//
//  WiimoteIRPoint+Private.h
//  Wiimote
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteIRPoint.h"

@interface WiimoteIRPoint (Private)

+ (WiimoteIRPoint*)pointWithOwner:(Wiimote*)owner index:(NSUInteger)index;

- (id)initWithOwner:(Wiimote*)owner index:(NSUInteger)index;

- (void)setPosition:(NSPoint)position;
- (void)setOutOfView:(BOOL)outOfView;

@end
