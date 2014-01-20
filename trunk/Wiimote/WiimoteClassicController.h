//
//  WiimoteClassicController.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteGenericExtension.h"
#import "WiimoteEventDispatcher+ClassicController.h"

@interface WiimoteClassicController : WiimoteGenericExtension<
                                                WiimoteClassicControllerProtocol>
{
    @private
        BOOL                                            m_ButtonState[WiimoteClassicControllerButtonCount];
        NSPoint                                         m_StickPositions[WiimoteClassicControllerStickCount];
        CGFloat                                         m_AnalogShiftPositions[WiimoteClassicControllerAnalogShiftCount];
        BOOL                                            m_IsCalibrationDataReaded;
        WiimoteDeviceClassicControllerCalibrationData   m_CalibrationData;
}

@end
