//
//  WiimoteExtensionProbeHandler.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Wiimote/WiimoteIOManager.h>

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

+ (void)routineProbe:(WiimoteIOManager*)manager
		  signatures:(NSArray*)signatures
              target:(id)target
              action:(SEL)action;

- (id)initWithIOManager:(WiimoteIOManager*)manager
                 target:(id)target
                 action:(SEL)action;

- (void)probeFinished:(BOOL)result;

@end
