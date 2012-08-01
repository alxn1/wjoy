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
}

@end
