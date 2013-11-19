/*
 *  D2D.c
 *  Dock2D
 *
 *  Created by alxn1 on 31.10.13.
 *  Copyright 2013 alxn1. All rights reserved.
 *
 */

#import "NSObject+ObjCRuntime.h"

@interface _DOCKGlassFloorLayer : NSObject

@end

@implementation _DOCKGlassFloorLayer

+ (void)refreshDock
{
    NSString *script    = [[NSBundle bundleForClass:[self class]] pathForResource:@"refreshDock" ofType:@"scpt"];
    NSTask   *task      = [[NSTask alloc] init];

    [task setLaunchPath:@"/usr/bin/osascript"];
    [task setArguments:[NSArray arrayWithObject:script]];
    [task launch];

    [task setTerminationHandler:^(NSTask *task)
    {
        [task autorelease];
    }];
}

+ (void)load
{
    NSAutoreleasePool *pool             = [[NSAutoreleasePool alloc] init];
    Class              dockGlassClass   = NSClassFromString(@"DOCKGlassFloorLayer");

    [dockGlassClass
            addMethod:[self getMethod:@selector(updateFrame: iconOffset:)]
                 name:@selector(interceptedUpdateFrame: iconOffset:)];

    [dockGlassClass
        swizzleMethod:@selector(updateFrame: iconOffset:)
           withMethod:@selector(interceptedUpdateFrame: iconOffset:)];

    [self refreshDock];
    [pool release];
}

+ (CALayer*)add2DBackgroundLayer:(CALayer*)parent
{
    CALayer   *result   = [CALayer layer];
    CGColorRef black    = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 0.65f);
    CGColorRef white    = CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 0.75f);

    [result setBorderWidth:1.5f];
    [result setCornerRadius:5.0f];
    [result setBackgroundColor:black];
    [result setBorderColor:white];

    CGColorRelease(black);
    CGColorRelease(white);

    [parent addSublayer:result];

    return result;
}

+ (void)fix2DSeparatorLayerImage:(CALayer*)separatorLayer
{
    if(![[[separatorLayer contents] className] isEqualToString:@"NSImage"])
    {
        NSImage *content = [[NSBundle bundleForClass:[self class]] imageForResource:@"separator"];

        [separatorLayer setContents:content];
    }
}

+ (void)fix2DIndicatorLayer:(CALayer*)layer
{
    if(![[[layer contents] className] isEqualToString:@"NSImage"])
    {
        NSImage *content = [[NSBundle bundleForClass:[self class]] imageForResource:@"indicator"];

        [layer setContents:content];
    }
}

+ (void)fix2DReflectionLayer:(CALayer*)layer
{
    CGRect reflectionsFrame = [layer frame];

    if(reflectionsFrame.origin.y > 0.0f)
    {
        reflectionsFrame.origin.y = 0.0f;

        [layer setFrame:reflectionsFrame];
    }
}

+ (void)fix2DIndicatorAndReflectionLayers:(NSArray*)layers
{
    for(CALayer *layer in layers)
    {
        if([[layer className] isEqualToString:@"DOCKIndicatorLayer"])
            [self fix2DIndicatorLayer:layer];

        if([[layer className] isEqualToString:@"CALayer"])
            [self fix2DReflectionLayer:layer];
    }
}

- (void)updateFrame:(CGRect)frame iconOffset:(unsigned int)offset
{
    CALayer *layer          = (CALayer*)self;
    NSArray *sublayers      = [layer sublayers];
    CALayer *separatorLayer = [self valueForKey:@"_separatorLayer"];
    CALayer *frameLayer     = ([sublayers count] < 2)?
                                    ([_DOCKGlassFloorLayer add2DBackgroundLayer:layer]):
                                    ([sublayers objectAtIndex:1]);

    frame.size.height = ((int)frame.size.height * 1.65f);

    [layer setFrame:frame];
    [separatorLayer setFrame:frame];
    [frameLayer setFrame:CGRectMake(0.0, -5.0f, frame.size.width, frame.size.height + 5.0f)];

    [_DOCKGlassFloorLayer fix2DSeparatorLayerImage:separatorLayer];
    [_DOCKGlassFloorLayer fix2DIndicatorAndReflectionLayers:[[layer superlayer] sublayers]];
}

@end
