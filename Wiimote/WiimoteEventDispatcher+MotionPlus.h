//
//  WiimoteEventDispatcher+MotionPlus.h
//  Wiimote
//
//  Created by alxn1 on 29.09.12.
//
//

#import "WiimoteEventDispatcher.h"
#import "WiimoteMotionPlusDelegate.h"

@interface WiimoteEventDispatcher (MotionPlus)

- (void)postMotionPlus:(WiimoteMotionPlusExtension*)motionPlus
	extensionConnected:(WiimoteExtension*)extension;

- (void)postMotionPlus:(WiimoteMotionPlusExtension*)motionPlus
 extensionDisconnected:(WiimoteExtension*)extension;

- (void)postMotionPlus:(WiimoteMotionPlusExtension*)motionPlus
				report:(const WiimoteMotionPlusReport*)report;

@end
