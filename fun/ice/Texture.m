//
//  Texture.h
//  ice
//
//  Created by alxn1 on 28.12.11.
//  Copyright 2011 alxn1. All rights reserved.
//

#import "Texture.h"
#import "Math3D.h"

@interface Texture (PrivatePart)

+ (NSRect)flipRectByY:(NSRect)originalRect
            imageSize:(NSSize)imageSize;

+ (BOOL)isNonPowerOfTwoTexturesSupported;
+ (BOOL)isClientStorageTexturesSupported;

+ (unsigned)nearestBiggerPowerOfTwo:(unsigned)n;
+ (NSSize)nearestBiggerPowerOfTwoSize:(NSSize)size;

+ (NSBitmapImageRep*)createBitmapImageRepWithSize:(NSSize)size;
+ (NSBitmapImageRep*)imageRepFromImage:(NSImage*)image withSize:(NSSize)size;

- (void)scaleRectLeft:(float*)left
                  top:(float*)top
                right:(float*)right
               bottom:(float*)bottom
                scale:(float)scale;

- (void)calcucalteQuadVertexes:(Vertex*)vertexes
               destinationRect:(NSRect)rect
                    sourceRect:(NSRect)fromRect
                    flippedByX:(BOOL)flippedByX
                    flippedByY:(BOOL)flippedByY
                     clockwise:(BOOL)clockwise
                         scale:(float)scale
                        rotate:(float)angle;

- (void)renderQuad:(Vertex*)vertexes
         clockwise:(BOOL)clockwise;

- (void)updateFromImage:(NSImage*)img;

@end

@implementation Texture

+(NSRect)flipRectByY:(NSRect)originalRect
           imageSize:(NSSize)imageSize
{
    originalRect.origin.y = imageSize.height -
                                originalRect.origin.y -
                                originalRect.size.height;

    return originalRect;
}

+ (BOOL)isNonPowerOfTwoTexturesSupported
{
    const GLubyte *extensions = glGetString(GL_EXTENSIONS);

    if(extensions == NULL)
        return NO;

    return ([[NSString stringWithUTF8String:(const char*)extensions]
                    rangeOfString:@"GL_ARB_texture_non_power_of_two"].length != 0);
}

+ (BOOL)isClientStorageTexturesSupported
{
    const GLubyte *extensions = glGetString(GL_EXTENSIONS);

    if(extensions == NULL)
        return NO;

    return (([[NSString stringWithUTF8String:(const char*)extensions]
                    rangeOfString:@"GL_APPLE_client_storage"].length != 0) &&
            ([[NSString stringWithUTF8String:(const char*)extensions]
                    rangeOfString:@"GL_APPLE_texture_range"].length != 0));
}

+ (unsigned)nearestBiggerPowerOfTwo:(unsigned)n
{
    n--;

    n |= (n >> 1);
    n |= (n >> 2);
    n |= (n >> 4);
    n |= (n >> 8);
    n |= (n >> 16);

    return (n + 1);
}

+ (NSSize)nearestBiggerPowerOfTwoSize:(NSSize)size
{
    return NSMakeSize(
                [Texture nearestBiggerPowerOfTwo:size.width],
                [Texture nearestBiggerPowerOfTwo:size.height]);
}

+ (NSBitmapImageRep*)createBitmapImageRepWithSize:(NSSize)size
{
    return [[[NSBitmapImageRep alloc]
                    initWithBitmapDataPlanes:nil
                                  pixelsWide:size.width
                                  pixelsHigh:size.height
                               bitsPerSample:8
                             samplesPerPixel:4
                                    hasAlpha:YES
                                    isPlanar:NO
                              colorSpaceName:NSDeviceRGBColorSpace
                                 bytesPerRow:0
                                bitsPerPixel:32] autorelease];
}

static BOOL useMipMaps = NO;

+ (BOOL)useMipMaps
{
    return useMipMaps;
}

+ (void)setUseMipMaps:(BOOL)flag
{
    useMipMaps = flag;
}

+ (NSBitmapImageRep*) imageRepFromImage:(NSImage*)image withSize:(NSSize)size
{
    if(image == nil)
        return nil;

    NSBitmapImageRep    *result     = [Texture createBitmapImageRepWithSize:size];
    NSGraphicsContext   *context    = [NSGraphicsContext graphicsContextWithBitmapImageRep:result];

    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:context];

    [image drawInRect:NSMakeRect(0.0f, 0.0f, size.width, size.height)
             fromRect:NSZeroRect
            operation:NSCompositeSourceOver
             fraction:1.0f];

    [NSGraphicsContext restoreGraphicsState];

    return result;
}

+ (Texture*)textureFromImage:(NSImage*)img
{
    return [[[Texture alloc] initWithImage:img] autorelease];
}

+ (Texture*)textureFromFile:(NSString*)fileName
{
    NSImage *img    = [[NSImage alloc] initWithContentsOfFile:fileName];
    Texture *result = [[[Texture alloc] initWithImage:img] autorelease];

    [img release];
    return result;
}

+ (Texture*)textureNamed:(NSString*)name
{
    return [Texture textureFromImage:[NSImage imageNamed:name]];
}

- (id)init
{
    return [self initWithImage:nil];
}

- (id)initWithImage:(NSImage*)img
{
    self = [super init];
    if(self == nil)
        return nil;

    if(img == nil)
    {
        [self release];
        return nil;
    }

    m_IsNonPowerOfTwoSupported  = [Texture isNonPowerOfTwoTexturesSupported];
    m_IsClientStorageSupported  = [Texture isClientStorageTexturesSupported];

    m_IsFlipped                 = NO;
    m_OriginalSize              = NSZeroSize;
    m_CurrentSize               = NSZeroSize;
    m_MaxTexCoords              = NSZeroSize;

    m_IsLinearFilteringEnabled  = NO;
    m_Bitmap                    = nil;
    m_IsUseMipMaps              = NO;

    m_Context = [[NSOpenGLContext currentContext] retain];

    glGenTextures(1, &m_TexId);
    [self updateFromImage:img];

    return self;
}

- (void)dealloc
{
    [m_Context makeCurrentContext];

    glDeleteTextures(1, &m_TexId);
    [m_Context release];
    [m_Bitmap release];

    [super dealloc];
}

- (void)bind
{
    glBindTexture(GL_TEXTURE_2D, m_TexId);

    if(m_IsLinearFilteringEnabled)
    {
        if(!m_IsUseMipMaps)
        {
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        }
        else
        {
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
        }
    }
    else
    {
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    }
}

- (BOOL)isFlipped
{
    return m_IsFlipped;
}

- (NSSize)originalSize
{
    return m_OriginalSize;
}

- (NSSize)maxTexCoords
{
    return m_MaxTexCoords;
}

- (BOOL)isLinearFilteringEnabled
{
    return m_IsLinearFilteringEnabled;
}

- (void)setLinearFilteringEnabled:(BOOL)enabled
{
    if(m_IsLinearFilteringEnabled == enabled)
        return;

    m_IsLinearFilteringEnabled = enabled;

    GLuint currentTextureId = 0;
    glGetIntegerv(GL_TEXTURE_BINDING_2D, (GLint*)&currentTextureId);

    if(currentTextureId == m_TexId)
        [self bind];
}

- (void)drawInRect:(NSRect)rect
          fromRect:(NSRect)fromRect
        flippedByX:(BOOL)flippedByX
        flippedByY:(BOOL)flippedByY
         clockwise:(BOOL)clockwise
             scale:(float)scale
            rotate:(float)angle
{
    Vertex vertexes[4];

    [self calcucalteQuadVertexes:vertexes
                 destinationRect:rect
                      sourceRect:fromRect
                      flippedByX:flippedByX
                      flippedByY:flippedByY
                       clockwise:clockwise
                           scale:scale
                          rotate:angle];

    [self renderQuad:vertexes
           clockwise:clockwise];
}

- (void)drawInRect:(NSRect)rect
        flippedByX:(BOOL)flippedByX
        flippedByY:(BOOL)flippedByY
         clockwise:(BOOL)clockwise
             scale:(float)scale
            rotate:(float)angle
{
    NSRect fromRect;

    fromRect.origin = NSZeroPoint;
    fromRect.size   = m_OriginalSize;

    [self drawInRect:rect
            fromRect:fromRect
          flippedByX:flippedByX
          flippedByY:flippedByY
           clockwise:clockwise
               scale:scale
              rotate:angle];
}

- (void)drawAtPoint:(NSPoint)point
         flippedByX:(BOOL)flippedByX
         flippedByY:(BOOL)flippedByY
          clockwise:(BOOL)clockwise
              scale:(float)scale
             rotate:(float)angle
{
    NSRect rect;

    rect.origin = point;
    rect.size   = m_OriginalSize;

    [self drawInRect:rect
          flippedByX:flippedByX
          flippedByY:flippedByY
           clockwise:clockwise
               scale:scale
              rotate:angle];
}

- (void)scaleRectLeft:(float*)left
                  top:(float*)top
                right:(float*)right
               bottom:(float*)bottom
                scale:(float)scale
{
    float centerX = (*right + *left) * 0.5f;
    float centerY = (*top + *bottom) * 0.5f;

    *left   = centerX - (centerX    - *left)    * scale;
    *right  = centerX + (*right     - centerX)  * scale;
    *top    = centerY + (*top       - centerY)  * scale;
    *bottom = centerY - (centerY    - *bottom)  * scale;
}

- (void)calcucalteQuadVertexes:(Vertex*)vertexes
               destinationRect:(NSRect)rect
                    sourceRect:(NSRect)fromRect
                    flippedByX:(BOOL)flippedByX
                    flippedByY:(BOOL)flippedByY
                     clockwise:(BOOL)clockwise
                         scale:(float)scale
                        rotate:(float)angle
{
    if(vertexes == NULL)
        return;

    if(m_IsFlipped)
        flippedByY = !flippedByY;

    fromRect = [Texture flipRectByY:fromRect imageSize:m_CurrentSize];

    fromRect.origin.x       /= m_OriginalSize.width;
    fromRect.origin.y       /= m_OriginalSize.height;
    fromRect.size.width     /= m_OriginalSize.width;
    fromRect.size.height    /= m_OriginalSize.height;

    float left      = rect.origin.x;
    float right     = rect.origin.x + rect.size.width;
    float top       = rect.origin.y + rect.size.height;
    float bottom    = rect.origin.y;

    if(scale != 1.0f)
    {
        [self scaleRectLeft:&left
                        top:&top
                      right:&right
                     bottom:&bottom
                      scale:scale];
    }

    float texLeft   = fromRect.origin.x * m_MaxTexCoords.width;
    float texRight  = (fromRect.origin.x + fromRect.size.width) * m_MaxTexCoords.width;
    float texTop    = fromRect.origin.y * m_MaxTexCoords.height;
    float texBottom = (fromRect.origin.y + fromRect.size.height) * m_MaxTexCoords.height;

    if(flippedByX)
    {
        float tmp   = texLeft;
        texLeft     = texRight;
        texRight    = tmp;
    }

    if(flippedByY)
    {
        float tmp   = texBottom;
        texBottom   = texTop;
        texTop      = tmp;
    }

    Vertex result[4] =
    {
        { left,     top,    0.0f, texLeft,  texTop },
        { right,    top,    0.0f, texRight, texTop },
        { right,    bottom, 0.0f, texRight, texBottom },
        { left,     bottom, 0.0f, texLeft,  texBottom }
    };

    for(int i = 0; i < 4; i++)
        vertexes[i] = result[i];

    if(angle != 0.0f)
    {
        float centerX = (right + left) * 0.5f;
        float centerY = (top + bottom) * 0.5f;

        Matrix matrix = TranslateMatrix(-centerX, -centerY, 0.0f);
        matrix = MultMatrixes(RotateZMatrix(angle), matrix);
        matrix = MultMatrixes(TranslateMatrix(centerX, centerY, 0.0f), matrix);
        TransformVertexes(vertexes, 4, matrix);
    }
}

- (void)renderQuad:(Vertex*)vertexes
         clockwise:(BOOL)clockwise
{
    [self bind];

    glBegin(GL_QUADS);

    if(clockwise)
    {
        glNormal3f(0.0f, 0.0f, -1.0f);

        for(int i = 0; i < 4; i++)
        {
            glTexCoord2f(vertexes[ i ].u, vertexes[ i ].v);
            glVertex3f(vertexes[ i ].x, vertexes[ i ].y, vertexes[ i ].z);
        }
    }
    else
    {
        glNormal3f(0.0f, 0.0f, 1.0f);

        for(int i = 3; i >= 0; i--)
        {
            glTexCoord2f(vertexes[ i ].u, vertexes[ i ].v);
            glVertex3f(vertexes[ i ].x, vertexes[ i ].y, vertexes[ i ].z);
        }
    }

    glEnd();
}

- (NSBitmapImageRep*)findBitmap:(NSImage*)img
{
    NSArray     *reps       = [img representations];
    NSUInteger   countReps  = [reps count];

    for(NSUInteger i = 0; i < countReps; i++)
    {
        NSBitmapImageRep *rep = [reps objectAtIndex:i];
        if([rep isKindOfClass:[NSBitmapImageRep class]])
            return rep;
    }

    return nil;
}

- (NSSize)imageSize:(NSImage*)img
{
    NSBitmapImageRep *rep = [self findBitmap:img];

    if(rep == nil)
        return [img size];

    return NSMakeSize([rep pixelsWide], [rep pixelsHigh]);
}

- (void)updateFromImage:(NSImage*)img
{
    if(img == nil || ![img isValid])
        return;

    m_IsFlipped       = [img isFlipped];
    m_OriginalSize    = [self imageSize:img];

    [self bind];

    m_CurrentSize = (m_IsNonPowerOfTwoSupported)?
                            (m_OriginalSize):
                            ([ Texture nearestBiggerPowerOfTwoSize:m_OriginalSize]);

    NSBitmapImageRep *imageRep = [Texture imageRepFromImage:img withSize:m_CurrentSize];

    if(m_IsClientStorageSupported && ![Texture useMipMaps])
    {
        [m_Bitmap release];
        m_Bitmap = [imageRep retain];

        glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, GL_TRUE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_SHARED_APPLE);
    }

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);

    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glPixelStorei(GL_UNPACK_ROW_LENGTH, [imageRep bytesPerRow] / 4);


    if(![Texture useMipMaps])
    {
        glTexImage2D(
                GL_TEXTURE_2D,
                0,
                GL_RGBA,
                m_CurrentSize.width,
                m_CurrentSize.height,
                0,
                GL_RGBA,
                GL_UNSIGNED_INT_8_8_8_8_REV,
                [imageRep bitmapData]);
    }
    else
    {
        m_IsUseMipMaps = YES;

        gluBuild2DMipmaps(
                GL_TEXTURE_2D,
                GL_RGBA,
                m_CurrentSize.width,
                m_CurrentSize.height,
                GL_RGBA,
                GL_UNSIGNED_INT_8_8_8_8_REV,
                [imageRep bitmapData]);
    }

    m_MaxTexCoords.width  = m_OriginalSize.width / m_CurrentSize.width;
    m_MaxTexCoords.height = m_OriginalSize.height / m_CurrentSize.height;
}

@end
