//
//  IceView.m
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "IceView.h"

@interface NSOpenGLView (RetinaSupport)

- (void)setWantsBestResolutionOpenGLSurface:(BOOL)flag;

- (NSRect)convertRectToBacking:(NSRect)rect;

@end

@interface IceView (PrivatePart)

- (void)startTimer;
- (void)beginRender;
- (void)endRender;

@end

@implementation IceView

- (id)initWithFrame: (NSRect)frameRect
{
    NSOpenGLPixelFormatAttribute attributes[] =
    {
        NSOpenGLPFAAccelerated,
        NSOpenGLPFAWindow,
        NSOpenGLPFAColorSize, 32,
        NSOpenGLPFAAlphaSize, 8,
		NSOpenGLPFADoubleBuffer,
        0
    };

    NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
    if(pixelFormat == nil)
    {
        [self release];
        return nil;
    }

    self = [super initWithFrame:frameRect pixelFormat:pixelFormat];
    [pixelFormat release];

    if(self == nil)
        return nil;

	[[self openGLContext] makeCurrentContext];

    m_IsBeginQuit   = NO;
    m_Particles     = [[IceParticlesSystem alloc] initWithContentRect:[self bounds]];
    m_Timer         = [[ThreadTimer alloc] initWithTarget:self action:@selector(update) interval:1.0 / 30.0];

    [m_Timer start];

    return self;
}

- (id)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat*)format
{
    return [self initWithFrame:frameRect];
}

- (void)dealloc
{
    [m_Timer stop];
    [m_Timer release];
    [m_Particles release];
    [super dealloc];
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)draw
{
    [self beginRender];

    float d = 0.0f;

    if(m_IsBeginQuit)
        d = (75.0 - ((float)m_QuitValue)) / 100.0;

    [m_Particles draw:0.75f - d moutionBlur:[m_MoutionBlurMenu state] == NSOnState];
    [self endRender];
}

- (void)setFrameSize:(NSSize)newSize
{
    [super setFrameSize:newSize];
    [self clearGLContext];
    [self openGLContext];
    [m_Particles setContentRect:[self bounds]];
    [self draw];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self clearGLContext];
    [self openGLContext];
    [m_Particles setContentRect:[self bounds]];
    [self draw];
}

- (void)beginRender
{
    [[self openGLContext] makeCurrentContext];

    if([self respondsToSelector:@selector(setWantsBestResolutionOpenGLSurface:)])
        [self setWantsBestResolutionOpenGLSurface:YES];

	GLint value = 0;
    [[self openGLContext] setValues:&value forParameter:NSOpenGLCPSwapInterval];

	value = 0;
    [[self openGLContext] setValues:&value forParameter:NSOpenGLCPSurfaceOpacity];

	value = 1;
    [[self openGLContext ] setValues:&value forParameter:NSOpenGLCPSurfaceOrder];

    NSRect visibleRect      = [self visibleRect];
    NSRect bounds           = [self bounds];
    NSRect originalBounds   = bounds;

    if([self respondsToSelector:@selector(convertRectToBacking:)])
        bounds = [self convertRectToBacking:bounds];

    glViewport(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    float zFar = (bounds.size.height > bounds.size.width) ? (bounds.size.height):(bounds.size.width);
    if(zFar < 500.0f)
        zFar = 500.0f;

    gluPerspective(1.0f, 1.0f, 1.0f, zFar);

    // 114.65 и 0.075 получено эмпирическим путем - лень высчитывать все это правильно.
    glTranslatef(-1.0f, -1.0f, -114.6f);
    glScalef(2.0f / originalBounds.size.width, 2.0f / originalBounds.size.height, 0.075f);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    // Маленький хак, решающий проблемму с неправильным вычислением viewport-а
    // в Mac OS X.
    if(visibleRect.origin.y > bounds.origin.y)
        glTranslatef(0.0f, bounds.origin.y - visibleRect.origin.y, 0.0f);

    if(visibleRect.origin.x > bounds.origin.x)
        glTranslatef(bounds.origin.x - visibleRect.origin.x, 0.0f, 0.0f);

    glEnable(GL_BLEND);
    glEnable(GL_TEXTURE_2D);

    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)endRender
{
    glDisable(GL_TEXTURE_2D);
    glDisable(GL_BLEND);
    glFinish();
	[[self openGLContext] flushBuffer];
}

- (void)update
{
    if(m_IsBeginQuit)
    {
        m_QuitValue -= 2;
        if(m_QuitValue == 0)
            [[NSApplication sharedApplication] terminate:nil];
    }

    [m_Particles nextFrame];
    [self draw];
}

- (void)beginQuit
{
    m_IsBeginQuit   = YES;
    m_QuitValue     = 74;
}

@end
