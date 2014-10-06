//
//  VHIDXBox360Controller.h
//  VHID2
//
//  Created by alxn1 on 21.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import <VHID/VHIDGameController.h>

typedef enum VHIDXbox360ButtonType {
    VHIDXbox360ButtonTypeUp             = 0,
    VHIDXbox360ButtonTypeDown           = 1,
    VHIDXbox360ButtonTypeLeft           = 2,
    VHIDXbox360ButtonTypeRight          = 3,
    VHIDXbox360ButtonTypeStart          = 4,
    VHIDXbox360ButtonTypeBack           = 5,
    VHIDXbox360ButtonTypeLeftStick      = 6,
    VHIDXbox360ButtonTypeRightStick     = 7,
    VHIDXbox360ButtonTypeLeftShift      = 8,
    VHIDXbox360ButtonTypeRightShift     = 9,
    VHIDXbox360ButtonTypeLogo           = 10,
    VHIDXbox360ButtonTypeA              = 11,
    VHIDXbox360ButtonTypeB              = 12,
    VHIDXbox360ButtonTypeX              = 13,
    VHIDXbox360ButtonTypeY              = 14
} VHIDXbox360ButtonType;

// VHIDGameControllerAxisZ and VHIDGameControllerAxisRZ axes possibly values: [0.0, 1.0]
// (it's left and right shifts)
@interface VHIDXBox360Controller : VHIDGameController

+ (VHIDXBox360Controller*)XBox360Controller;

@end
