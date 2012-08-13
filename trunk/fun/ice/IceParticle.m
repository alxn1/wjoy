//
//  IceParticle.m
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "IceParticle.h"

@implementation IceParticle

- (id)init
{
    [[super init] release];
    return nil;
}

- (id)initWithTexture:(Texture*)texture
          contentRect:(NSRect)contentRect
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Texture       = [texture retain];
    m_ContentRect   = contentRect;

    m_Position      = NSMakePoint(
                        contentRect.origin.x + (rand() % ((int) contentRect.size.width)),
                        contentRect.origin.y + contentRect.size.height);

    m_Size          = NSMakeSize(
                        contentRect.size.width / 50.0f,
                        contentRect.size.width / 50.0f);

    m_Size.width   += m_Size.width * (0.5f + ((float)(rand() % 100)) / 100.0f);
    m_Size.height   = m_Size.width * 1.2f;

    m_Scale         = 0.5f + ((float)(rand() % 100)) / 200.0f;
    m_Speed         = (contentRect.size.height / (10.0f * 60.0f)) *
                            (0.5f + ((float)(rand() % 100)) / 100.0f);

    m_FrameIndex    = 0;
    m_TimeOffset    = rand() % 10000;
    m_Angle         = 360.0f * ((float)(rand() % 1000)) / 1000.0f;
    m_RotateSpeed   = 2.0f * (((float)(rand() % 100)) / 100.0f);

    int r = rand() % 1000;

    if(r < 250)
        m_RotateSpeed = -m_RotateSpeed;
    else if(r > 750)
        m_RotateSpeed = m_RotateSpeed;
    else
        m_RotateSpeed = 0.0f;

    return self;
}

- (void)dealloc
{
    [m_Texture release];
    [super dealloc];
}

- (Texture*)texture
{
    return [[m_Texture retain] autorelease];
}

- (void)nextFrame:(unsigned long long)frameIndex
{
    float tSin = sinf(((float)(frameIndex + m_TimeOffset)) / 30.0f * M_PI * 0.5f);

    m_Position.x += m_Size.height * tSin / 60.0f;
    m_Position.y -= m_Speed;
    m_Scale      += tSin / 750.0f;
    m_Angle      += m_RotateSpeed;

    m_FrameIndex  = frameIndex;
}

- (void)drawMoutionBlur:(float)alpha
{
    NSPoint position    = m_Position;
    float   scale       = m_Scale;
    float   angle       = m_Angle;

    for(int i = 0; i < 30; i += 2)
    {
        for(int j = 0; j < 2; j++)
        {
            float tSin = sinf((( float)(m_TimeOffset + m_FrameIndex - i - j)) / 30.0f * M_PI * 0.5f);

            position.x  -= m_Size.height * tSin / 60.0f;
            position.y  += m_Speed;
            scale       -= tSin / 750.0f;
            angle       -= m_RotateSpeed;
        }

        float a = alpha * 0.05f * (30.0f - ( float)i) / 30.0f;
        glColor4f(a, a, a, a);

        [m_Texture drawInRect:NSMakeRect(position.x, position.y, m_Size.width, m_Size.height)
                   flippedByX:NO
                   flippedByY:NO
                    clockwise:NO
                        scale:scale
                       rotate:angle];
    }
}

- (void)draw:(float)alpha moutionBlur:(BOOL)moutionBlur
{
    if(moutionBlur)
        [self drawMoutionBlur:alpha];

    glColor4f(alpha, alpha, alpha, alpha);

    [m_Texture drawInRect: NSMakeRect(m_Position.x, m_Position.y, m_Size.width, m_Size.height)
               flippedByX:NO
               flippedByY:NO
                clockwise:NO
                    scale:m_Scale
                   rotate:m_Angle];
}

- (BOOL)isDied
{
    return ((m_Position.y + m_Size.height) < m_ContentRect.origin.y);
}

@end
