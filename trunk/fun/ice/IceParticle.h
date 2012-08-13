//
//  IceParticle.h
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "Texture.h"

@interface IceParticle : NSObject
{
    @private
        NSRect               m_ContentRect;
        NSPoint              m_Position;
        NSSize               m_Size;
        float                m_Scale;
        float                m_Angle;
        float                m_Speed;
        float                m_RotateSpeed;
        Texture             *m_Texture;
        unsigned long long   m_TimeOffset;
        unsigned long long   m_FrameIndex;
}

- (id)initWithTexture:(Texture*)texture
          contentRect:(NSRect)contentRect;

- (Texture*)texture;

- (void)nextFrame:(unsigned long long)frameIndex;
- (void)draw:(float)alpha moutionBlur:(BOOL)moutionBlur;

- (BOOL)isDied;

@end
