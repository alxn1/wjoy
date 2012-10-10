//
//  WiimoteMotionPlus.h
//  Wiimote
//
//  Created by alxn1 on 13.09.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtension+PlugIn.h"
#import "WiimoteMotionPlusDelegate.h"

@interface WiimoteMotionPlus : WiimoteExtension<WiimoteMotionPlusProtocol>
{
    @private
        WiimoteIOManager		*m_IOManager;
        WiimoteExtension		*m_SubExtension;
		NSUInteger				 m_ReportCounter;
		NSUInteger				 m_ExtensionReportCounter;

		BOOL					 m_IsSubExtensionDisconnected;
        WiimoteMotionPlusReport  m_Report;
}

@end
