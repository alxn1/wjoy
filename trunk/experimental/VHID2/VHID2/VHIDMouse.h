//
//  VHIDMouse.h
//  VHID
//
//  Created by alxn1 on 17.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDDevice.h"

typedef enum
{
    VHIDMouseButtonTypeLeft     = (1 << 0),
    VHIDMouseButtonTypeRight    = (1 << 1),
    VHIDMouseButtonTypeMiddle   = (1 << 2)
} VHIDMouseButtonType;

@interface VHIDMouse : VHIDDevice

+ (VHIDMouse*)mouse;

- (BOOL)isButtonPressed:(VHIDMouseButtonType)button;
- (void)setButton:(VHIDMouseButtonType)button pressed:(BOOL)pressed;

- (void)updateRelativePosition:(NSPoint)positionDelta; // NSPoint([-127, 127], [-127, 127])

@end
