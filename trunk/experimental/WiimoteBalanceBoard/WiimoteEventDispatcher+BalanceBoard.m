//
//  WiimoteEventDispatcher+BalanceBoard.m
//  WiimoteBalanceBoard
//
//  Created by alxn1 on 10.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher+BalanceBoard.h"
#import "WiimoteBalanceBoard.h"
#import "WiimoteBalanceBoardDelegate.h"

@implementation WiimoteEventDispatcher (BalanceBoard)

- (void)postBalanceBoard:(WiimoteBalanceBoard*)balanceBoard
            topLeftPress:(double)topLeft
           topRightPress:(double)topRight
         bottomLeftPress:(double)bottomLeft
        bottomRightPress:(double)bottomRight
{
    [[self delegate] wiimote:[self owner]
                balanceBoard:balanceBoard
                topLeftPress:topLeft
               topRightPress:topRight
             bottomLeftPress:bottomLeft
            bottomRightPress:bottomRight];

    if([self isStateNotificationsEnabled])
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithDouble:topLeft], WiimoteBalanceBoardTopLeftPressKey,
                                    [NSNumber numberWithDouble:topLeft], WiimoteBalanceBoardTopLeftPressKey,
                                    [NSNumber numberWithDouble:topLeft], WiimoteBalanceBoardTopLeftPressKey,
                                    [NSNumber numberWithDouble:topLeft], WiimoteBalanceBoardTopLeftPressKey,
                                    nil];

        [self postNotification:WiimoteBalanceBoardPressChangedNotification
                        params:params
                        sender:balanceBoard];
    }
}

@end
