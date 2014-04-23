//
//  WiimoteProtocolMotionPlus.h
//  Wiimote
//
//  Created by alxn1 on 12.09.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#define WiimoteDeviceMotionPlusExtensionProbeAddress          0x04A600FA

#define WiimoteDeviceMotionPlusExtensionInitAddress           0x04A600F0
#define WiimoteDeviceMotionPlusExtensionResetAddress          0x04A400F0
#define WiimoteDeviceMotionPlusExtensionInitOrResetValue      0x55

#define WiimoteDeviceMotionPlusExtensionSetModeAddress        0x04A600FE

typedef enum {
    WiimoteDeviceMotionPlusModeNormal                       = 0x04,
    WiimoteDeviceMotionPlusModeNunchuck                     = 0x05,
    WiimoteDeviceMotionPlusModeOther                        = 0x07
} WiimoteDeviceMotionPlusMode;
