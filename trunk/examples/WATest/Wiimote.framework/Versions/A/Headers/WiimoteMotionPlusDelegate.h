//
//  WiimoteMotionPlusDelegate.h
//  Wiimote
//
//  Created by alxn1 on 13.09.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *WiimoteMotionPlusSubExtensionConnectedNotification;
FOUNDATION_EXPORT NSString *WiimoteMotionPlusSubExtensionDisconnectedNotification;
FOUNDATION_EXPORT NSString *WiimoteMotionPlusReportNotification;

FOUNDATION_EXPORT NSString *WiimoteMotionPlusSubExtensionKey;
FOUNDATION_EXPORT NSString *WiimoteMotionPlusReportKey;

typedef struct {
	uint16_t                    speed;
	BOOL                        isSlowMode;
} WiimoteMotionPlusAngleSpeed;

typedef struct {
	WiimoteMotionPlusAngleSpeed yaw;
	WiimoteMotionPlusAngleSpeed roll;
	WiimoteMotionPlusAngleSpeed pitch;
} WiimoteMotionPlusReport;

@class Wiimote;
@class WiimoteExtension;

@protocol WiimoteMotionPlusProtocol

- (const WiimoteMotionPlusReport*)lastReport;

- (WiimoteExtension*)subExtension;
- (void)disconnectSubExtension;
- (void)deactivate;

@end

typedef WiimoteExtension<WiimoteMotionPlusProtocol> WiimoteMotionPlusExtension;

@interface NSObject (WiimoteMotionPlusDelegate)

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
	  subExtensionConnected:(WiimoteExtension*)extension;

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
   subExtensionDisconnected:(WiimoteExtension*)extension;

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
					 report:(const WiimoteMotionPlusReport*)report;

@end
