//
//  Texture.h
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

@interface Texture : NSObject
{
    @private
        GLuint               m_TexId;

        BOOL                 m_IsNonPowerOfTwoSupported;
        BOOL                 m_IsClientStorageSupported;

        BOOL                 m_IsFlipped;
        NSSize               m_OriginalSize;
        NSSize               m_CurrentSize;
        NSSize               m_MaxTexCoords;

        BOOL                 m_IsLinearFilteringEnabled;

        NSBitmapImageRep    *m_Bitmap;
        NSOpenGLContext     *m_Context;
    
        BOOL                 m_IsUseMipMaps;
}

+ (BOOL)useMipMaps;
+ (void)setUseMipMaps:(BOOL)flag;

+ (Texture*)textureFromImage:(NSImage*) img;
+ (Texture*)textureFromFile:(NSString*) fileName;
+ (Texture*)textureNamed:(NSString*) name;

- (id)initWithImage:(NSImage*)img;

- (void)bind;

- (BOOL)isFlipped;
- (NSSize)originalSize;
- (NSSize)maxTexCoords;

- (BOOL)isLinearFilteringEnabled;
- (void)setLinearFilteringEnabled:(BOOL)enabled;

- (void)drawInRect:(NSRect)rect
          fromRect:(NSRect)fromRect
        flippedByX:(BOOL)flippedByX
        flippedByY:(BOOL)flippedByY
         clockwise:(BOOL)clockwise
             scale:(float)scale
            rotate:(float)angle;

- (void)drawInRect:(NSRect)rect
        flippedByX:(BOOL)flippedByX
        flippedByY:(BOOL)flippedByY
         clockwise:(BOOL)clockwise
             scale:(float)scale
            rotate:(float)angle;

- (void)drawAtPoint:(NSPoint)point
         flippedByX:(BOOL)flippedByX
         flippedByY:(BOOL)flippedByY
          clockwise:(BOOL)clockwise
              scale:(float)scale
             rotate:(float)angle;

@end
