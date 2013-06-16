//
//  WiimoteEventDispatcher+UProController.h
//  Wiimote
//
//  Created by alxn1 on 16.06.13.
//

#import "WiimoteEventDispatcher.h"
#import "WiimoteUProControllerDelegate.h"

@interface WiimoteEventDispatcher (UProController)

- (void)postUProController:(WiimoteUProControllerExtension*)uPro
			 buttonPressed:(WiimoteUProControllerButtonType)button;

- (void)postUProController:(WiimoteUProControllerExtension*)uPro
			buttonReleased:(WiimoteUProControllerButtonType)button;

- (void)postUProController:(WiimoteUProControllerExtension*)uPro
					 stick:(WiimoteUProControllerStickType)stick
		   positionChanged:(NSPoint)position;

@end
