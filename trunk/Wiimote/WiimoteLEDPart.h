//
//  WiimoteLEDPart.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePart.h"

@interface WiimoteLEDPart : WiimotePart
{
    @private
        NSUInteger m_Mask;
}

- (NSUInteger)highlightedLEDMask;
- (void)setHighlightedLEDMask:(NSUInteger)mask;

@end
