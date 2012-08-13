//
//  IceParticlesSystem.h
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "IceParticle.h"

@interface IceParticlesSystem : NSObject
{
    @private
        NSRect               m_ContentRect;
        unsigned long long   m_FramesCounter;
        NSMutableArray      *m_Particles;
        NSArray             *m_Textures;
}

- (id)initWithContentRect:(NSRect)contentRect;

- (void)setContentRect:(NSRect)contentRect;
- (void)nextFrame;
- (void)draw:(float)alpha moutionBlur:(BOOL)moutionBlur;

@end
