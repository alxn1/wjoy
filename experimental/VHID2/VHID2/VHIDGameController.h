//
//  VHIDGameController.h
//  VHID2
//
//  Created by alxn1 on 21.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDDevice.h"

typedef NSUInteger VHIDGameControllerAxisSet;
typedef enum VHIDGameControllerAxis {
    VHIDGameControllerAxisX     = (1 << 0),
    VHIDGameControllerAxisY     = (1 << 1),
    VHIDGameControllerAxisZ     = (1 << 2),
    VHIDGameControllerAxisRX    = (1 << 3),
    VHIDGameControllerAxisRY    = (1 << 4),
    VHIDGameControllerAxisRZ    = (1 << 5)
} VHIDGameControllerAxis;

@interface VHIDGameController : VHIDDevice
{
    @private
        VHIDGameControllerAxisSet   m_Axes;
        NSUInteger                  m_ButtonCount;
}

+ (VHIDGameController*)gameControllerWithAxes:(VHIDGameControllerAxisSet)axes
                                  buttonCount:(NSUInteger)buttonCount;

- (id)initWithAxes:(VHIDGameControllerAxisSet)axes
       buttonCount:(NSUInteger)buttonCount;

- (VHIDGameControllerAxisSet)axes;
- (NSUInteger)buttonCount;

// [-1.0, 1.0]
- (CGFloat)axisValue:(VHIDGameControllerAxis)axis;
- (void)setAxis:(VHIDGameControllerAxis)axis value:(CGFloat)value;

- (BOOL)isButtonPressed:(NSUInteger)button;
- (void)setButton:(NSUInteger)button pressed:(BOOL)pressed;

@end
