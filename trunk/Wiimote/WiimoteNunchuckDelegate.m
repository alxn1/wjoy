//
//  WiimoteNunchuckDelegate.m
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteNunchuckDelegate.h"

NSString *WiimoteNunchuckButtonPressedNotification          = @"WiimoteNunchuckButtonPressedNotification";
NSString *WiimoteNunchuckButtonReleasedNotification         = @"WiimoteNunchuckButtonReleasedNotification";
NSString *WiimoteNunchuckStickPositionChangedNotification   = @"WiimoteNunchuckStickPositionChangedNotification";

NSString *WiimoteNunchuckButtonKey                          = @"WiimoteNunchuckButtonKey";
NSString *WiimoteNunchuckStickPositionKey                   = @"WiimoteNunchuckStickPositionKey";

@implementation NSObject (WiimoteNunchuckDelegate)

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button
{
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button
{
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position
{
}

@end
