//
//  WiimoteMotionPlus.h
//  Wiimote
//
//  Created by alxn1 on 13.09.12.
//  Copyright 2012 Dr. Web. All rights reserved.
//

#import "WiimoteExtension+PlugIn.h"
#import "WiimoteMotionPlusDelegate.h"

@interface WiimoteMotionPlus : WiimoteExtension<WiimoteMotionPlusProtocol>
{
    @private
        WiimoteIOManager *m_IOManager;
        WiimoteExtension *m_SubExtension;
}

@end
