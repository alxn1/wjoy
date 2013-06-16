//
//  WiimoteUProController.h
//  Wiimote
//
//  Created by alxn1 on 16.06.13.
//

#import "WiimoteGenericExtension.h"
#import "WiimoteEventDispatcher+UProController.h"

@interface WiimoteUProController : WiimoteGenericExtension<
											WiimoteUProControllerProtocol>
{
	@private
		BOOL		m_ButtonState[WiimoteUProControllerButtonCount];
        NSPoint		m_StickPositions[WiimoteUProControllerStickCount];
}

@end
