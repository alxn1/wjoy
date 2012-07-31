//
//  WiimoteExtensionPart.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimotePart.h"

@class WiimoteExtension;
@class WiimoteExtensionHelper;

@interface WiimoteExtensionPart : WiimotePart
{
    @private
        BOOL                     m_IsExtensionConnected;
        WiimoteExtensionHelper  *m_ProbeHelper;
        WiimoteExtension        *m_Extension;
}

+ (void)registerExtensionClass:(Class)cls;

- (WiimoteExtension*)connectedExtension;

@end
