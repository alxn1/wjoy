//
//  WiimoteNunchuck.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteGenericExtension.h"
#import "WiimoteEventDispatcher+Nunchuck.h"

@class WiimoteAccelerometer;

@interface WiimoteNunchuck : WiimoteGenericExtension<
                                            WiimoteNunchuckProtocol>
{
    @private
		BOOL								 m_IsCalibrationDataReaded;

        BOOL								 m_ButtonState[WiimoteNunchuckButtonCount];

		NSPoint								 m_StickPosition;
        WiimoteDeviceStickCalibrationData	 m_StickCalibrationData;

        WiimoteAccelerometer                *m_Accelerometer;
}

@end
