//
//  UserNotificationCenterScreenCornerView.m
//  UserNotification
//
//  Created by alxn1 on 20.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "UserNotificationCenterScreenCornerView.h"

@interface UserNotificationCenterScreenCornerView (PrivatePart)

- (NSBezierPath*)pathForCornerPoint;
- (NSBezierPath*)pathForTriangle:(UserNotificationCenterScreenCorner)corner;

- (void)drawScreenCorner:(UserNotificationCenterScreenCorner)corner;

- (void)updateTrackingRects;
- (void)removeTrackingRects;

- (int)screenCornerFromEvent:(NSEvent*)event;

@end

@implementation UserNotificationCenterScreenCornerView

+ (NSSize)bestSize
{
    return NSMakeSize(150.0f, 96.0f);
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if(self == nil)
        return nil;

    screenCorner                = UserNotificationCenterScreenCornerRightTop;
    isEnabled                   = YES;
    underMouseScreenCorner      = -1;
    draggedMouseScreenCorner    = -1;
    clickedMouseScreenCorner    = -1;

    [self updateTrackingRects];

    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if(self == nil)
        return nil;

    screenCorner                = UserNotificationCenterScreenCornerRightTop;
    isEnabled                   = YES;
    underMouseScreenCorner      = -1;
    draggedMouseScreenCorner    = -1;
    clickedMouseScreenCorner    = -1;

    [self updateTrackingRects];

    return self;
}

- (void)dealloc
{
    [self removeTrackingRects];
    [bgImage release];
    [super dealloc];
}

- (void)drawRect:(NSRect)rect
{
    rect = [self bounds];

    if(bgImage == nil) {
        NSString *path = [[NSBundle bundleForClass:[UserNotificationCenterScreenCornerView class]]
                                                                                        pathForResource:@"screen"
                                                                                                 ofType:@"jpg"];

        bgImage = [[NSImage alloc] initWithContentsOfFile:path];
    }

    [bgImage
        drawInRect:rect
          fromRect:NSZeroRect
         operation:NSCompositeSourceOver
          fraction:1.0f];

    [[NSColor blackColor] setStroke];
    [[NSBezierPath bezierPathWithRect:rect] stroke];

    [self drawScreenCorner:UserNotificationCenterScreenCornerLeftTop];
    [self drawScreenCorner:UserNotificationCenterScreenCornerRightTop];
    [self drawScreenCorner:UserNotificationCenterScreenCornerRightBottom];
    [self drawScreenCorner:UserNotificationCenterScreenCornerLeftBottom];

    [[NSColor colorWithDeviceWhite:0.0f alpha:0.75f] setFill];
    [[self pathForCornerPoint] fill];

    if(![self isEnabled])
    {
        [[NSColor colorWithDeviceWhite:1.0f alpha:0.35f] setFill];
        [[NSBezierPath bezierPathWithRect:rect] fill];
    }
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self updateTrackingRects];
}

- (void)viewDidEndLiveResize
{
    [super viewDidEndLiveResize];
    [self updateTrackingRects];
}

- (void)mouseDown:(NSEvent*)event
{
    if(![self isEnabled])
        return;

    draggedMouseScreenCorner = [self screenCornerFromEvent:event];
    clickedMouseScreenCorner = draggedMouseScreenCorner;

    if(draggedMouseScreenCorner >= 0)
        [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent*)event
{
    if(draggedMouseScreenCorner == -1)
        return;

    int corner = [self screenCornerFromEvent:event];
    if(corner != draggedMouseScreenCorner)
        corner = -1;

    if(clickedMouseScreenCorner != corner)
    {
        clickedMouseScreenCorner = corner;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseUp:(NSEvent*)event
{
    if(draggedMouseScreenCorner == -1)
        return;

    [self mouseDragged:event];
    draggedMouseScreenCorner = -1;

    if(clickedMouseScreenCorner >= 0)
    {
        [self setScreenCorner:(UserNotificationCenterScreenCorner)clickedMouseScreenCorner];
        if(target != nil && action != nil)
            [target performSelector:action withObject:self];

        clickedMouseScreenCorner = -1;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseEntered:(NSEvent*)event
{
    if(![self isEnabled])
        return;

    int corner = [self screenCornerFromEvent:event];
    if(underMouseScreenCorner != corner)
    {
        underMouseScreenCorner = corner;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseExited:(NSEvent*)event
{
    if(underMouseScreenCorner < 0)
        return;

    underMouseScreenCorner = -1;
    [self setNeedsDisplay:YES];

}

- (BOOL)isEnabled
{
    return isEnabled;
}

- (void)setEnabled:(BOOL)enabled
{
    if(isEnabled == enabled)
        return;

    isEnabled                   = enabled;
    underMouseScreenCorner      = -1;
    draggedMouseScreenCorner    = -1;
    clickedMouseScreenCorner    = -1;

    [self setNeedsDisplay:YES];
}

- (UserNotificationCenterScreenCorner)screenCorner
{
    return screenCorner;
}

- (void)setScreenCorner:(UserNotificationCenterScreenCorner)corner
{
    if(screenCorner == corner)
        return;

    screenCorner = corner;
    [self setNeedsDisplay:YES];
}

- (id)target
{
    return target;
}

- (void)setTarget:(id)obj
{
    target = obj;
}

- (SEL)action
{
    return action;
}

- (void)setAction:(SEL)sel
{
    action = sel;
}

@end

@implementation UserNotificationCenterScreenCornerView (PrivatePart)

- (NSBezierPath*)pathForCornerPoint
{
    NSPoint point = NSZeroPoint;
    NSRect  rect  = [self bounds];

    switch(screenCorner)
    {
        case UserNotificationCenterScreenCornerRightTop:
            point = NSMakePoint(rect.origin.x + rect.size.width - 8.0f, rect.origin.y + rect.size.height - 8.0f);
            break;

        case UserNotificationCenterScreenCornerRightBottom:
            point = NSMakePoint(rect.origin.x + rect.size.width - 8.0f, rect.origin.y + 8.0f);
            break;

        case UserNotificationCenterScreenCornerLeftBottom:
            point = NSMakePoint(rect.origin.x + 8.0f, rect.origin.y + 8.0f);
            break;

        case UserNotificationCenterScreenCornerLeftTop:
            point = NSMakePoint(rect.origin.x + 8.0f, rect.origin.y + rect.size.height - 8.0f);
            break;
    }

    return [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(point.x - 2.0f, point.y - 2.0f, 4.0f, 4.0f)];
}

- (NSBezierPath*)pathForTriangle:(UserNotificationCenterScreenCorner)corner
{
    NSBezierPath    *path = [NSBezierPath bezierPath];
    NSRect           rect = [self bounds];

    switch(corner)
    {
        case UserNotificationCenterScreenCornerRightTop:
            [path moveToPoint:NSMakePoint(rect.origin.x + rect.size.width - 3.0f, rect.origin.y + rect.size.height - 3.0f)];
            [path lineToPoint:NSMakePoint(rect.origin.x + rect.size.width - 18.0f, rect.origin.y + rect.size.height - 3.0f)];
            [path lineToPoint:NSMakePoint(rect.origin.x + rect.size.width - 3.0f, rect.origin.y + rect.size.height - 18.0f)];
            break;

        case UserNotificationCenterScreenCornerRightBottom:
            [path moveToPoint:NSMakePoint(rect.origin.x + rect.size.width - 3.0f, rect.origin.y + 3.0f)];
            [path lineToPoint:NSMakePoint(rect.origin.x + rect.size.width - 18.0f, rect.origin.y + 3.0f)];
            [path lineToPoint:NSMakePoint(rect.origin.x + rect.size.width - 3.0f, rect.origin.y + 18.0f)];
            break;

        case UserNotificationCenterScreenCornerLeftBottom:
            [path moveToPoint:NSMakePoint(rect.origin.x + 3.0f, rect.origin.y + 3.0f)];
            [path lineToPoint:NSMakePoint(rect.origin.x + 18.0f, rect.origin.y + 3.0f)];
            [path lineToPoint:NSMakePoint(rect.origin.x + 3.0f, rect.origin.y + 18.0f)];
            break;

        case UserNotificationCenterScreenCornerLeftTop:
            [path moveToPoint:NSMakePoint(rect.origin.x + 3.0f, rect.origin.y + rect.size.height - 3.0f)];
            [path lineToPoint:NSMakePoint(rect.origin.x + 18.0f, rect.origin.y + rect.size.height - 3.0f)];
            [path lineToPoint:NSMakePoint(rect.origin.x + 3.0f, rect.origin.y + rect.size.height - 18.0f)];
            break;
    }

    [path closePath];
    return path;
}

- (void)drawScreenCorner:(UserNotificationCenterScreenCorner)corner
{
    float alphaValue = 0.5f;

    if(underMouseScreenCorner == corner)
        alphaValue = 0.75f;

    if(clickedMouseScreenCorner == corner)
        alphaValue = 0.6f;

    [[NSColor colorWithDeviceWhite:1.0f alpha:alphaValue] setFill];
    [[self pathForTriangle:corner] fill];
}

- (void)updateTrackingRects
{
    [self removeTrackingRects];

    NSPoint mousePosition = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream]
                                      fromView:nil];

    NSBezierPath *path = [self pathForTriangle:UserNotificationCenterScreenCornerLeftTop];
    trackingRectTags[0] = [self addTrackingRect:[path bounds]
                                          owner:self
                                       userData:nil
                                   assumeInside:[path containsPoint:mousePosition]];

    path = [self pathForTriangle:UserNotificationCenterScreenCornerRightTop];
    trackingRectTags[1] = [self addTrackingRect:[path bounds]
                                          owner:self
                                       userData:nil
                                   assumeInside:[path containsPoint:mousePosition]];

    path = [self pathForTriangle:UserNotificationCenterScreenCornerRightBottom];
    trackingRectTags[2] = [self addTrackingRect:[path bounds]
                                          owner:self
                                       userData:nil
                                   assumeInside:[path containsPoint:mousePosition]];

    path = [self pathForTriangle:UserNotificationCenterScreenCornerLeftBottom];
    trackingRectTags[3] = [self addTrackingRect:[path bounds]
                                          owner:self
                                       userData:nil
                                   assumeInside:[path containsPoint:mousePosition]];
}

- (void)removeTrackingRects
{
    for(int i = 0; i < 4; i++)
    {
        if(trackingRectTags[i] != 0)
        {
            [self removeTrackingRect:trackingRectTags[i]];
            trackingRectTags[i] = 0;
        }
    }
}

- (int)screenCornerFromEvent:(NSEvent*)event
{
    NSPoint mousePosition = [self convertPoint:[event locationInWindow]
                                      fromView:nil];

    NSRect rect = [[self pathForTriangle:UserNotificationCenterScreenCornerLeftTop] bounds];
    if(NSPointInRect(mousePosition, NSInsetRect(rect, -2.0f, -2.0f)))
        return UserNotificationCenterScreenCornerLeftTop;

    rect = [[self pathForTriangle:UserNotificationCenterScreenCornerRightTop] bounds];
    if(NSPointInRect(mousePosition, NSInsetRect(rect, -2.0f, -2.0f)))
        return UserNotificationCenterScreenCornerRightTop;

    rect = [[self pathForTriangle:UserNotificationCenterScreenCornerRightBottom] bounds];
    if(NSPointInRect(mousePosition, NSInsetRect(rect, -2.0f, -2.0f)))
        return UserNotificationCenterScreenCornerRightBottom;

    rect = [[self pathForTriangle:UserNotificationCenterScreenCornerLeftBottom] bounds];
    if(NSPointInRect(mousePosition, NSInsetRect(rect, -2.0f, -2.0f)))
        return UserNotificationCenterScreenCornerLeftBottom;

    return -1;
}

@end
