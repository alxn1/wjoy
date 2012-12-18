//
//  WiimoteMotionPlusDelegate.m
//  Wiimote
//
//  Created by alxn1 on 13.09.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteMotionPlusDelegate.h"

NSString *WiimoteMotionPlusSubExtensionConnectedNotification	= @"WiimoteMotionPlusSubExtensionConnectedNotification";
NSString *WiimoteMotionPlusSubExtensionDisconnectedNotification = @"WiimoteMotionPlusSubExtensionDisconnectedNotification";
NSString *WiimoteMotionPlusReportNotification					= @"WiimoteMotionPlusReportNotification";

NSString *WiimoteMotionPlusSubExtensionKey						= @"WiimoteMotionPlusSubExtensionKey";
NSString *WiimoteMotionPlusReportKey							= @"WiimoteMotionPlusReportKey";

@implementation NSObject (WiimoteMotionPlusDelegate)

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
	  subExtensionConnected:(WiimoteExtension*)extension
{
}

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
   subExtensionDisconnected:(WiimoteExtension*)extension
{
}

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
					 report:(const WiimoteMotionPlusReport*)report
{
}

@end
