//
//  WiimoteIRPart.h
//  Wiimote
//
//  Created by alxn1 on 07.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePart.h"

@class WiimoteIRPoint;

@interface WiimoteIRPart : WiimotePart
{
    @private
        BOOL         m_IsEnabled;
        BOOL         m_IsHardwareEnabled;
        NSInteger    m_IRReportMode;
        NSInteger    m_ReportType;
        NSInteger    m_ReportCounter;

        NSArray     *m_Points;
}

- (BOOL)isEnabled;
- (void)setEnabled:(BOOL)enabled;

- (WiimoteIRPoint*)point:(NSUInteger)index;

@end
