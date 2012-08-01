//
//  WiimoteUnknownExtension.m
//  Wiimote
//
//  Created by alxn1 on 01.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteUnknownExtension.h"
#import "WiimoteExtension+PlugIn.h"

@implementation WiimoteUnknownExtension

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteUnknownExtension class]];
}

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action
{
    [WiimoteExtension probeFinished:YES target:target action:action];
}

@end
