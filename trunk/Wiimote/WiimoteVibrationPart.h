//
//  WiimoteVibrationPart.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePart.h"

@interface WiimoteVibrationPart : WiimotePart
{
    @private
        BOOL m_IsVibrationEnabled;
}

- (BOOL)isVibrationEnabled;
- (void)setVibrationEnabled:(BOOL)enabled;

@end
