//
//  WiimoteNunchuck.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteGenericExtension.h"
#import "WiimoteEventDispatcher+Nunchuck.h"

@interface WiimoteNunchuck : WiimoteGenericExtension<
                                            WiimoteNunchuckProtocol>
{
    @private
		BOOL								m_IsCalibrationDataReaded;
		BOOL								m_IsAccelerometerEnabled;

        BOOL								m_ButtonState[WiimoteNunchuckButtonCount];

		NSPoint								m_StickPosition;
        WiimoteDeviceStickCalibrationData	m_StickCalibrationData;

        double								m_AccelerometerPitch;
        double								m_AccelerometerRoll;

        uint16_t							m_AccelerometerZeroX;
        uint16_t							m_AccelerometerZeroY;
        uint16_t							m_AccelerometerZeroZ;

        uint16_t							m_Accelerometer1gX;
        uint16_t							m_Accelerometer1gY;
        uint16_t							m_Accelerometer1gZ;
}

@end
