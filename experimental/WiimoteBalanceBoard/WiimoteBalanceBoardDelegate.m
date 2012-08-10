//
//  WiimoteBalanceBoardDelegate.m
//  WiimoteBalanceBoard
//
//  Created by alxn1 on 10.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteBalanceBoardDelegate.h"

NSString *WiimoteBalanceBoardPressChangedNotification   = @"WiimoteBalanceBoardPressChangedNotification";

NSString *WiimoteBalanceBoardTopLeftPressKey            = @"WiimoteBalanceBoardTopLeftPressKey";
NSString *WiimoteBalanceBoardTopRightPressKey           = @"WiimoteBalanceBoardTopRightPressKey";
NSString *WiimoteBalanceBoardBottomLeftPressKey         = @"WiimoteBalanceBoardBottomLeftPressKey";
NSString *WiimoteBalanceBoardBottomRightPressKey        = @"WiimoteBalanceBoardBottomRightPressKey";

@implementation NSObject (WiimoteBalanceBoardDelegate)

- (void)     wiimote:(Wiimote*)wiimote
        balanceBoard:(WiimoteBalanceBoardExtension*)balanceBoard
        topLeftPress:(double)topLeft
       topRightPress:(double)topRight
     bottomLeftPress:(double)bottomLeft
    bottomRightPress:(double)bottomRight
{
}

@end
