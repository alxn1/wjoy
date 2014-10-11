//
//  WiimoteEventSystem+BalanceBoard.m
//  Wiimote
//
//  Created by Александр Серков on 11.10.14.
//
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
    CGFloat topLeft     = [[[notification userInfo] objectForKey:WiimoteUProControllerStickKey] doubleValue];
    CGFloat topRight    = [[[notification userInfo] objectForKey:WiimoteUProControllerStickKey] doubleValue];
    CGFloat bottomLeft  = [[[notification userInfo] objectForKey:WiimoteUProControllerStickKey] doubleValue];
    CGFloat bottonRight = [[[notification userInfo] objectForKey:WiimoteUProControllerStickKey] doubleValue];

    [self postEventForWiimoteExtension:[notification object] path:@"Press.Top.Left"     value:topLeft];
    [self postEventForWiimoteExtension:[notification object] path:@"Press.Top.Right"    value:topRight];
    [self postEventForWiimoteExtension:[notification object] path:@"Press.Bottom.Left"  value:bottomLeft];
    [self postEventForWiimoteExtension:[notification object] path:@"Press.Bottom.Right" value:bottonRight];
}

@end
