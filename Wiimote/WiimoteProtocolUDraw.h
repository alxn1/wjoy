//
//  WiimoteProtocolUDraw.h
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

typedef struct
{
    uint8_t xOffset;
    uint8_t yOffset;
    uint8_t gridIndex;
    uint8_t pressure;
    uint8_t unused;
    uint8_t buttonState;
} WiimoteDeviceUDrawReport;
