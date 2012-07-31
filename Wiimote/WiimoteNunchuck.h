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
        BOOL    m_ButtonState[WiimoteNunchuckButtonCount];
		NSPoint m_StickPosition;

        uint8_t m_StickMinX;
		uint8_t m_StickCenterX;
		uint8_t m_StickMaxX;

		uint8_t m_StickMinY;
		uint8_t m_StickCenterY;
		uint8_t m_StickMaxY;
}

@end
