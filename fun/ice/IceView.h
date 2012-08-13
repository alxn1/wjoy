//
//  IceView.h
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "IceParticlesSystem.h"

#import "ThreadTimer.h"

@interface IceView : NSOpenGLView
{
    @private
        IBOutlet NSMenuItem *m_MoutionBlurMenu;

        IceParticlesSystem  *m_Particles;
        ThreadTimer         *m_Timer;

        BOOL                 m_IsBeginQuit;
        int                  m_QuitValue;
}

- (void)beginQuit;

@end
