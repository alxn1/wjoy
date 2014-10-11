//
//  WiimoteBalanceBoard.h
//  WiimoteBalanceBoard
//
//  Created by alxn1 on 10.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteGenericExtension.h"
#import "WiimoteEventDispatcher+BalanceBoard.h"

@interface WiimoteBalanceBoard : WiimoteGenericExtension<
                                                WiimoteBalanceBoardProtocol>
{
    @private
        BOOL                                m_IsCalibrationDataReaded;

        double                              m_TopLeftPress;
        double                              m_TopRightPress;
        double                              m_BottomLeftPress;
        double                              m_BottomRightPress;

        WiimoteBalanceBoardCalibrationData  m_CalibrationData;
}

@end
