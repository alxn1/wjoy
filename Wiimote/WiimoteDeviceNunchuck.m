//
//  WiimoteDeviceNunchuck.m
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDeviceExtension+PlugIn.h"
#import "WiimoteDeviceNunchuck.h"

NSString *WiimoteNunchuckButtonPressedNotification			= @"WiimoteNunchuckButtonPressedNotification";
NSString *WiimoteNunchuckButtonReleasedNotification			= @"WiimoteNunchuckButtonReleasedNotification";
NSString *WiimoteNunchuckStickPositionChangedNotification	= @"WiimoteNunchuckStickPositionChangedNotification";

NSString *WiimoteNunchuckButtonKey							= @"WiimoteNunchuckButtonKey";
NSString *WiimoteNunchuckStickPositionKey					= @"WiimoteNunchuckStickPositionKey";

#define WiimoteNunchuckProbeDataSize		2
#define WiimoteNunchuckStateDataSize		6

typedef enum
{
	WiimoteNunchuckButtonMaskC	= 2,
	WiimoteNunchuckButtonMaskZ	= 1
} WiimoteNunchuckButtonMask;

@implementation WiimoteDeviceNunchuck

+ (NSRange)probeAddressSpace
{
	return NSMakeRange(0x04A400FE, WiimoteNunchuckProbeDataSize);
}

+ (BOOL)probe:(const unsigned char*)data length:(NSUInteger)length
{
	if(length < [WiimoteDeviceNunchuck probeAddressSpace].length)
		return NO;

	return (data[0] == 0 && data[1] == 0);
}

- (id)initWithDevice:(WiimoteDevice *)device
{
	self = [super initWithDevice:device];
	if(self == nil)
		return nil;

	m_IsStateChangeNotificationsEnabled = YES;
	m_Delegate							= nil;

	[self reset];

	return self;
}

- (NSUInteger)type
{
	return WiimoteExtensionTypeNunchuck;
}

- (NSPoint)stickPosition
{
	return m_StickPosition;
}

- (BOOL)isButtonPressed:(WiimoteNunchuckButtonType)button
{
	return m_ButtonState[button];
}

- (BOOL)isStateChangeNotificationsEnabled
{
	return m_IsStateChangeNotificationsEnabled;
}

- (void)setStateChangeNotificationsEnabled:(BOOL)enabled
{
	m_IsStateChangeNotificationsEnabled = enabled;
}

- (id<WiimoteDeviceNunchuckDelegate>)delegate
{
	return m_Delegate;
}

- (void)setDelegate:(id<WiimoteDeviceNunchuckDelegate>)delegate
{
	m_Delegate = delegate;
}

- (void)setStickPosition:(NSPoint)newPosition
{
	if(fabs(m_StickPosition.x - newPosition.x) < 0.01 &&
	   fabs(m_StickPosition.y - newPosition.y) < 0.01)
	{
		return;
	}

	m_StickPosition = newPosition;

	[m_Delegate wiimoteNunchuck:self stickPositionChanged:newPosition];

	NSLog(@"%f %f", newPosition.x, newPosition.y);
	if(m_IsStateChangeNotificationsEnabled)
	{
		NSDictionary *userInfo = [NSDictionary
										dictionaryWithObject:[NSValue valueWithPoint:newPosition]
													  forKey:WiimoteNunchuckStickPositionKey];

		[[NSNotificationCenter defaultCenter]
							postNotificationName:WiimoteNunchuckStickPositionChangedNotification
										  object:self
										userInfo:userInfo];
	}
}

- (void)setButton:(WiimoteNunchuckButtonType)button pressed:(BOOL)pressed
{
	if(m_ButtonState[button] == pressed)
		return;

	m_ButtonState[button] = pressed;

	if(pressed)
		[m_Delegate wiimoteNunchuck:self buttonPressed:button];
	else
		[m_Delegate wiimoteNunchuck:self buttonReleased:button];

	if(m_IsStateChangeNotificationsEnabled)
	{
		NSDictionary *userInfo = [NSDictionary
										dictionaryWithObject:[NSNumber numberWithInteger:button]
													  forKey:WiimoteNunchuckButtonKey];

		[[NSNotificationCenter defaultCenter]
							postNotificationName:((pressed)?
													(WiimoteNunchuckButtonPressedNotification):
													(WiimoteNunchuckButtonReleasedNotification))
										  object:self
										userInfo:userInfo];
	}
}

- (NSRange)calibrationAddressSpace
{
	return NSMakeRange(0x04A40020, WiimoteDeviceExtensionCalibrationDataSize);
}

- (BOOL)setCalibrationData:(const unsigned char*)data length:(NSUInteger)length
{
	if(length < WiimoteDeviceExtensionCalibrationDataSize)
		return NO;

	m_StickMaxX		= data[15];
	m_StickMinX		= data[16];
	m_StickCenterX	= data[17];

	m_StickMinY		= data[18];
	m_StickMaxY		= data[19];
	m_StickCenterY	= data[20];

	if(m_StickCenterX == 0)
		m_StickCenterX = 0x7F;
	if(m_StickMaxX == 0)
		m_StickMaxX = 0xFF;

	if(m_StickCenterY == 0)
		m_StickCenterY = 0x7F;

	if(m_StickMaxY == 0)
		m_StickMaxY = 0xFF;

	return YES;
}

- (float)calcStickPosition:(unsigned char)value
					   min:(unsigned char)min
					   max:(unsigned char)max
					center:(unsigned char)center
{
	float result = 0.0f;

	if(value <= center)
	{
		result = ((((float)value) - ((float)min)) /
				    (((float)center) - ((float)min))) - 1.0f;
	}
	else
	{
		result = ((((float)value) - ((float)center)) /
				   (((float)max) - ((float)center)));
	}

	if(result < -1.0f)
		result = 1.0f;

	if(result > 1.0f)
		result = 1.0f;

	return result;
}

- (BOOL)updateStateFromData:(const unsigned char*)data length:(NSUInteger)length
{
	if(length < WiimoteNunchuckStateDataSize)
		return NO;

	NSPoint stickPosition;

	stickPosition.x =  [self calcStickPosition:data[0]
										   min:m_StickMinX
										   max:m_StickMaxX
									    center:m_StickCenterX];

	stickPosition.y	= -[self calcStickPosition:data[1]
										   min:m_StickMinY
										   max:m_StickMaxY
									    center:m_StickCenterY];

	[self setStickPosition:stickPosition];
	[self setButton:WiimoteNunchuckButtonTypeC
			pressed:((data[5] & WiimoteNunchuckButtonMaskC) == 0)];

	[self setButton:WiimoteNunchuckButtonTypeZ
			pressed:((data[5] & WiimoteNunchuckButtonMaskZ) == 0)];

	return YES;
}

- (void)reset
{
	m_ButtonState[WiimoteNunchuckButtonTypeC]	= NO;
	m_ButtonState[WiimoteNunchuckButtonTypeZ]	= NO;

	m_StickMinX									= 0;
	m_StickCenterX								= 0x7F;
	m_StickMaxX									= 0xFF;

	m_StickMinY									= 0;
	m_StickCenterY								= 0x7F;
	m_StickMaxY									= 0xFF;

	m_StickPosition								= NSZeroPoint;
}

@end
