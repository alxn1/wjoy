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

        CGFloat     m_GravityX;
        CGFloat     m_GravityY;
        CGFloat     m_GravityZ;

        CGFloat     m_Pitch;
        CGFloat     m_Roll;

        CGFloat     m_GravitySmoothQuant;
        CGFloat     m_AnglesSmoothQuant;

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

- (CGFloat)gravityX;
- (CGFloat)gravityY;
- (CGFloat)gravityZ;

- (CGFloat)pitch;
- (CGFloat)roll;

- (CGFloat)gravitySmoothQuant;
- (void)setGravitySmoothQuant:(CGFloat)quant;

- (CGFloat)anglesSmoothQuant;
- (void)setAnglesSmoothQuant:(CGFloat)quant;

@end
