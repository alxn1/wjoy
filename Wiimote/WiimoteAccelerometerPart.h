//
//  WiimoteAccelerometerPart.h
//  Wiimote
//
//  Created by alxn1 on 03.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePart.h"

@class WiimoteAccelerometer;

@interface WiimoteAccelerometerPart : WiimotePart
{
    @private
        BOOL                     m_IsCalibrationDataReaded;
        WiimoteAccelerometer    *m_Accelerometer;
}

- (WiimoteAccelerometer*)accelerometer;

@end
