//
//  WiimoteProtocolBalanceBoard.h
//  Wiimote
//
//  Created by alxn1 on 11.10.14.
//
//

#define WiimoteBalanceBoardCalibrationDataAddress 0x04A40024
#define WiimoteBalanceBoardCalibrationDataSize    24

typedef struct
{
    uint16_t topRightPress;
    uint16_t bottomRightPress;
    uint16_t topLeftPress;
    uint16_t bottomLeftPress;
} WiimoteBalanceBoardReport;

typedef struct
{
    WiimoteBalanceBoardReport kg0;
    WiimoteBalanceBoardReport kg17;
    WiimoteBalanceBoardReport kg34;
} WiimoteBalanceBoardCalibrationData;
