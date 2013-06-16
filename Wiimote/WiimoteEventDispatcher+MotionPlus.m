//
//  WiimoteEventDispatcher+MotionPlus.m
//  Wiimote
//
//  Created by alxn1 on 29.09.12.
//
//

#import "WiimoteEventDispatcher+MotionPlus.h"

@implementation WiimoteEventDispatcher (MotionPlus)

- (void)postMotionPlus:(WiimoteMotionPlusExtension*)motionPlus
	extensionConnected:(WiimoteExtension*)extension
{
	[[self delegate] wiimote:[self owner]
				  motionPlus:motionPlus
	   subExtensionConnected:extension];

	[self postNotification:WiimoteMotionPlusSubExtensionConnectedNotification
					 param:extension
					   key:WiimoteMotionPlusSubExtensionKey
					sender:motionPlus];
}

- (void)postMotionPlus:(WiimoteMotionPlusExtension*)motionPlus
 extensionDisconnected:(WiimoteExtension*)extension
{
	[[self delegate] wiimote:[self owner]
				  motionPlus:motionPlus
	subExtensionDisconnected:extension];

	[self postNotification:WiimoteMotionPlusSubExtensionDisconnectedNotification
					 param:extension
					   key:WiimoteMotionPlusSubExtensionKey
					sender:motionPlus];
}

- (void)postMotionPlus:(WiimoteMotionPlusExtension*)motionPlus
				report:(const WiimoteMotionPlusReport*)report
{
	[[self delegate] wiimote:[self owner]
				  motionPlus:motionPlus
					  report:report];

	if([self isStateNotificationsEnabled])
	{
		[self postNotification:WiimoteMotionPlusReportNotification
						 param:[NSData dataWithBytes:report length:sizeof(WiimoteMotionPlusReport)]
						   key:WiimoteMotionPlusReportKey
						sender:motionPlus];
	}
}

@end
