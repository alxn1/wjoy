//
//  WiimoteExtensionProbeHandler.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteIOManager.h"

@interface WiimoteExtensionProbeHandler : NSObject
{
    @private
        id       m_Target;
        SEL      m_Action;
}

+ (void)routineProbe:(WiimoteIOManager*)manager
           signature:(NSData*)signature
              target:(id)target
              action:(SEL)action;

- (id)initWithIOManager:(WiimoteIOManager*)manager
                 target:(id)target
                 action:(SEL)action;

- (void)probeFinished:(BOOL)result;

@end

/*

This utility needed only for probe: method, if you write you own implementation.
You can subclass this utility class, store on it target and action for probe: method,
do some work asynchronously (or not), and on probe finished, you need to call
- (void)probeFinished:(BOOL)result; method with probe result. Set result to YES,
if you plugin can handle currently connected extension, and NO, if can't.
Probe finished call probeFinished on WiimoteExtension class.

+ (void)routineProbe:... implement standart probe algorithm.

*/
