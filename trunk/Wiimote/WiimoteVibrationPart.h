//
//  WiimoteVibrationPart.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePart.h"

@class WiimoteDevice;
@class WiimoteLEDPart;

@interface WiimoteVibrationPart : WiimotePart
{
    @private
        WiimoteDevice	*m_Device;
		WiimoteLEDPart	*m_LEDPart;
}

- (BOOL)isVibrationEnabled;
- (void)setVibrationEnabled:(BOOL)enabled;

- (void)setDevice:(WiimoteDevice*)device LEDPart:(WiimoteLEDPart*)LEDPart;

@end
