//
//  WiimoteDeviceNunchuck.h
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceExtension.h"

#define WiimoteNunchuckButtonCount	2
#define WiimoteNunchuckStickCount	1

typedef enum
{
	WiimoteNunchuckButtonTypeC,
	WiimoteNunchuckButtonTypeZ
} WiimoteNunchuckButtonType;

FOUNDATION_EXPORT NSString *WiimoteNunchuckButtonPressedNotification;
FOUNDATION_EXPORT NSString *WiimoteNunchuckButtonReleasedNotification;
FOUNDATION_EXPORT NSString *WiimoteNunchuckStickPositionChangedNotification;

FOUNDATION_EXPORT NSString *WiimoteNunchuckButtonKey;
FOUNDATION_EXPORT NSString *WiimoteNunchuckStickPositionKey;

@class WiimoteDeviceNunchuck;

@protocol WiimoteDeviceNunchuckDelegate

- (void)wiimoteNunchuck:(WiimoteDeviceNunchuck*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button;
- (void)wiimoteNunchuck:(WiimoteDeviceNunchuck*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button;
- (void)wiimoteNunchuck:(WiimoteDeviceNunchuck*)nunchuck stickPositionChanged:(NSPoint)position;

@end

@interface WiimoteDeviceNunchuck : WiimoteDeviceExtension
{
	@private
		BOOL								m_ButtonState[WiimoteNunchuckButtonCount];

		unsigned char						m_StickMinX;
		unsigned char						m_StickCenterX;
		unsigned char						m_StickMaxX;

		unsigned char						m_StickMinY;
		unsigned char						m_StickCenterY;
		unsigned char						m_StickMaxY;

		NSPoint								m_StickPosition;

		BOOL								m_IsStateChangeNotificationsEnabled;

		id<WiimoteDeviceNunchuckDelegate>	m_Delegate;
}

- (NSPoint)stickPosition;
- (BOOL)isButtonPressed:(WiimoteNunchuckButtonType)button;

- (BOOL)isStateChangeNotificationsEnabled;
- (void)setStateChangeNotificationsEnabled:(BOOL)enabled;

- (id<WiimoteDeviceNunchuckDelegate>)delegate;
- (void)setDelegate:(id<WiimoteDeviceNunchuckDelegate>)delegate;

@end
