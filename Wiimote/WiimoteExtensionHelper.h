//
//  WiimoteExtensionHelper.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtension+PlugIn.h"

@interface WiimoteExtensionHelper : NSObject
{
    @private
        Wiimote                 *m_Wiimote;
        WiimoteEventDispatcher  *m_EventDispatcher;
        WiimoteIOManager        *m_IOManager;

        NSMutableArray          *m_ExtensionClasses;
        Class                    m_CurrentClass;
        WiimoteExtension        *m_Extension;
        WiimoteExtension        *m_SubExtension;

        BOOL                     m_IsInitialized;
        BOOL                     m_IsStarted;
        BOOL                     m_IsCanceled;

        id                       m_Target;
        SEL                      m_Action;
}

- (id)initWithWiimote:(Wiimote*)wiimote
      eventDispatcher:(WiimoteEventDispatcher*)dispatcher
            ioManager:(WiimoteIOManager*)ioManager
     extensionClasses:(NSArray*)extensionClasses
         subExtension:(WiimoteExtension*)extension
               target:(id)target
               action:(SEL)action;

- (WiimoteExtension*)subExtension;

- (void)start;
- (void)cancel;

@end
