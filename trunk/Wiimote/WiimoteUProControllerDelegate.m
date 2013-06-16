//
//  WiimoteUProControllerDelegate.m
//  Wiimote
//
//  Created by alxn1 on 16.06.13.
//
//

#import "WiimoteUProControllerDelegate.h"

NSString *WiimoteUProControllerButtonPressedNotification		= @"WiimoteUProControllerButtonPressedNotification";
NSString *WiimoteUProControllerButtonReleasedNotification		= @"WiimoteUProControllerButtonReleasedNotification";
NSString *WiimoteUProControllerStickPositionChangedNotification	= @"WiimoteUProControllerStickPositionChangedNotification";

NSString *WiimoteUProControllerStickKey							= @"WiimoteUProControllerStickKey";
NSString *WiimoteUProControllerButtonKey						= @"WiimoteUProControllerButtonKey";
NSString *WiimoteUProControllerStickPositionKey					= @"WiimoteUProControllerStickPositionKey";

@implementation NSObject (WiimoteUProControllerDelegate)

- (void)      wiimote:(Wiimote*)wiimote
	   uProController:(WiimoteUProControllerExtension*)uPro
        buttonPressed:(WiimoteUProControllerButtonType)button
{
}

- (void)      wiimote:(Wiimote*)wiimote
	   uProController:(WiimoteUProControllerExtension*)uPro
       buttonReleased:(WiimoteUProControllerButtonType)button
{
}

- (void)      wiimote:(Wiimote*)wiimote
	   uProController:(WiimoteUProControllerExtension*)uPro
                stick:(WiimoteUProControllerStickType)stick
      positionChanged:(NSPoint)position
{
}

@end
