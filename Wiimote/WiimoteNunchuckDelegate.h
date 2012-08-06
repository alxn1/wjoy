//
//  WiimoteNunchuckDelegate.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WiimoteNunchuckButtonCount	2
#define WiimoteNunchuckStickCount   1

typedef enum
{
	WiimoteNunchuckButtonTypeC = 0,
	WiimoteNunchuckButtonTypeZ = 1
} WiimoteNunchuckButtonType;

FOUNDATION_EXPORT NSString *WiimoteNunchuckButtonPressedNotification;
FOUNDATION_EXPORT NSString *WiimoteNunchuckButtonReleasedNotification;
FOUNDATION_EXPORT NSString *WiimoteNunchuckStickPositionChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerEnabledStateChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerGravityChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerAnglesChangedNotification;

FOUNDATION_EXPORT NSString *WiimoteNunchuckButtonKey;
FOUNDATION_EXPORT NSString *WiimoteNunchuckStickPositionKey;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerEnabledStateKey;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerGravityX;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerGravityY;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerGravityZ;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerPitch;
FOUNDATION_EXPORT NSString *WiimoteNunchuckAccelerometerRoll;

@class Wiimote;
@class WiimoteExtension;
@class WiimoteAccelerometer;

@protocol WiimoteNunchuckProtocol

- (NSPoint)stickPosition;
- (BOOL)isButtonPressed:(WiimoteNunchuckButtonType)button;

- (WiimoteAccelerometer*)accelerometer;

@end

typedef WiimoteExtension<WiimoteNunchuckProtocol> WiimoteNunchuckExtension;

@interface NSObject (WiimoteNunchuckDelegate)

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button;
- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button;
- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position;
- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerEnabledStateChanged:(BOOL)enabled;
- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerChangedGravityX:(double)x y:(double)y z:(double)z;
- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerChangedPitch:(double)pitch roll:(double)roll;

@end
