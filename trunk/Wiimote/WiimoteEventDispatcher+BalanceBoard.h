//
//  WiimoteEventDispatcher+BalanceBoard.h
//  WiimoteBalanceBoard
//
//  Created by alxn1 on 10.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher.h"
#import "WiimoteBalanceBoardDelegate.h"

@class WiimoteBalanceBoard;

@interface WiimoteEventDispatcher (BalanceBoard)

- (void)postBalanceBoard:(WiimoteBalanceBoard*)balanceBoard
            topLeftPress:(double)topLeft
           topRightPress:(double)topRight
         bottomLeftPress:(double)bottomLeft
        bottomRightPress:(double)bottomRight;

@end
