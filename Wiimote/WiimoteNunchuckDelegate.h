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

FOUNDATION_EXPORT NSString *WiimoteNunchuckButtonKey;
FOUNDATION_EXPORT NSString *WiimoteNunchuckStickPositionKey;

@class Wiimote;
@class WiimoteExtension;

@protocol WiimoteNunchuckProtocol

- (NSPoint)stickPosition;
- (BOOL)isButtonPressed:(WiimoteNunchuckButtonType)button;

@end

typedef WiimoteExtension<WiimoteNunchuckProtocol> WiimoteNunchuckExtension;

@interface NSObject (WiimoteNunchuckDelegate)

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button;
- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button;
- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position;

@end
