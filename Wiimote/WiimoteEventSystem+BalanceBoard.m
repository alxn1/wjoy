//
//  WiimoteEventSystem+BalanceBoard.m
//  Wiimote
//
//  Created by Alxn1 on 11.10.14.
//

#import "WiimoteEventSystem+BalanceBoard.h"

@implementation WiimoteEventSystem (BalanceBoard)

+ (void)load
{
    [WiimoteEventSystem
            registerNotification:WiimoteBalanceBoardPressChangedNotification
                        selector:@selector(wiimoteBalanceBoardPressChangedNotification:)];
}

- (void)wiimoteBalanceBoardPressChangedNotification:(NSNotification*)notification
{
    CGFloat topLeft     = [[[notification userInfo] objectForKey:WiimoteBalanceBoardTopLeftPressKey]     doubleValue];
    CGFloat topRight    = [[[notification userInfo] objectForKey:WiimoteBalanceBoardTopRightPressKey]    doubleValue];
    CGFloat bottomLeft  = [[[notification userInfo] objectForKey:WiimoteBalanceBoardBottomLeftPressKey]  doubleValue];
    CGFloat bottonRight = [[[notification userInfo] objectForKey:WiimoteBalanceBoardBottomRightPressKey] doubleValue];

    [self postEventForWiimoteExtension:[notification object] path:@"Press.Top.Left"     value:topLeft];
    [self postEventForWiimoteExtension:[notification object] path:@"Press.Top.Right"    value:topRight];
    [self postEventForWiimoteExtension:[notification object] path:@"Press.Bottom.Left"  value:bottomLeft];
    [self postEventForWiimoteExtension:[notification object] path:@"Press.Bottom.Right" value:bottonRight];
}

@end
