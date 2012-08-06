//
//  WiimoteAccelerometer.h
//  Wiimote
//
//  Created by alxn1 on 06.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WiimoteAccelerometer : NSObject
{
    @private
        BOOL        m_IsEnabled;

        double      m_GravityX;
        double      m_GravityY;
        double      m_GravityZ;

        double      m_Pitch;
        double      m_Roll;

        double      m_GravitySmoothQuant;
        double      m_AnglesSmoothQuant;

        uint16_t    m_ZeroX;
        uint16_t    m_ZeroY;
        uint16_t    m_ZeroZ;

        uint16_t    m_1gX;
        uint16_t    m_1gY;
        uint16_t    m_1gZ;

        id          m_Delegate;
}

- (BOOL)isEnabled;
- (void)setEnabled:(BOOL)enabled;

- (double)gravityX;
- (double)gravityY;
- (double)gravityZ;

- (double)pitch;
- (double)roll;

- (double)gravitySmoothQuant;
- (void)setGravitySmoothQuant:(double)quant;

- (double)anglesSmoothQuant;
- (void)setAnglesSmoothQuant:(double)quant;

@end
