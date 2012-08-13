//
//  IceParticlesSystem.m
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "IceParticlesSystem.h"

@interface IceParticlesSystem (PrivatePart)

- (void)removeDiedParticles;
- (void)generateNextParticles;

@end

@implementation IceParticlesSystem

- (id)initWithContentRect:(NSRect)contentRect
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Particles = [[NSMutableArray alloc] init];
    [self setContentRect: contentRect];

    return self;
}

- (void)dealloc
{
    [m_Textures release];
    [m_Particles release];
    [super dealloc];
}

- (void)setContentRect:(NSRect)contentRect
{
    m_FramesCounter = 0;
    m_ContentRect   = contentRect;
    [m_Particles removeAllObjects];

    [Texture setUseMipMaps:YES];

    [m_Textures release];
    m_Textures      = [[NSArray arrayWithObjects:
                        [Texture textureNamed:@"ice1"],
                        [Texture textureNamed:@"ice2"],
                        [Texture textureNamed:@"ice3"],
                        [Texture textureNamed:@"ice4"],
                        [Texture textureNamed:@"ice5"],
                        [Texture textureNamed:@"ice6"],
                        nil] retain];

    NSUInteger countTextures = [m_Textures count];
    for(NSUInteger i = 0; i < countTextures; i++)
        [[m_Textures objectAtIndex:i] setLinearFilteringEnabled:YES];
}

- (void)nextFrame
{
    NSUInteger countParticles = [m_Particles count];
    for(NSUInteger i = 0; i < countParticles; i++)
        [[m_Particles objectAtIndex:i] nextFrame:m_FramesCounter];

    [self removeDiedParticles];
    m_FramesCounter++;
}

- (void)draw:(float)alpha moutionBlur:(BOOL)moutionBlur
{
    NSUInteger countParticles = [m_Particles count];
    for(NSUInteger i = 0; i < countParticles; i++)
        [(IceParticle*)[m_Particles objectAtIndex:i] draw:alpha moutionBlur:moutionBlur];
}

- (void)removeDiedParticles
{
    NSMutableArray *diedParticles   = [NSMutableArray array];
    NSUInteger      countParticles  = [m_Particles count];

    for(NSUInteger i = 0; i < countParticles; i++)
    {
        IceParticle *p = [m_Particles objectAtIndex: i];
        if([p isDied])
            [diedParticles addObject:p];
    }

    if([diedParticles count] > 0)
        [m_Particles removeObjectsInArray:diedParticles];

    [self generateNextParticles];
}

- (void)generateNextParticles
{
    if(m_FramesCounter % 90 != 0)
        return;

    NSUInteger countToGenerate = 100 - [m_Particles count];
    if(countToGenerate == 0)
        return;

    if(countToGenerate > 10)
        countToGenerate = 10;

    for(NSUInteger i = 0; i < 10; i++)
    {
        NSUInteger   texture    = rand() % [m_Textures count];
        IceParticle *p          = [[IceParticle alloc]
                                        initWithTexture:[m_Textures objectAtIndex:texture]
                                            contentRect:m_ContentRect];

        [m_Particles addObject: p];
        [p release];
    }
}

@end
