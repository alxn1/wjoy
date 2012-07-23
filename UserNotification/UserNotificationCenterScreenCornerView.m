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

    m_ScreenCorner              = UserNotificationCenterScreenCornerRightTop;
    m_IsEnabled                 = YES;
    m_UnderMouseScreenCorner    = -1;
    m_DraggedMouseScreenCorner  = -1;
    m_ClickedMouseScreenCorner  = -1;

    [self updateTrackingRects];

    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if(self == nil)
        return nil;

    m_ScreenCorner              = UserNotificationCenterScreenCornerRightTop;
    m_IsEnabled                 = YES;
    m_UnderMouseScreenCorner    = -1;
    m_DraggedMouseScreenCorner  = -1;
    m_ClickedMouseScreenCorner  = -1;

    [self updateTrackingRects];

    return self;
}

- (void)dealloc
{
    [self removeTrackingRects];
    [m_BGImage release];
    [super dealloc];
}

- (void)drawRect:(NSRect)rect
{
    rect = [self bounds];

    if(m_BGImage == nil) {
        NSString *path = [[NSBundle bundleForClass:[UserNotificationCenterScreenCornerView class]]
                                                                                        pathForResource:@"screen"
                                                                                                 ofType:@"jpg"];

        m_BGImage      = [[NSImage alloc] initWithContentsOfFile:path];
    }

    [m_BGImage
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

    m_DraggedMouseScreenCorner = [self screenCornerFromEvent:event];
    m_ClickedMouseScreenCorner = m_DraggedMouseScreenCorner;

    if(m_DraggedMouseScreenCorner >= 0)
        [self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent*)event
{
    if(m_DraggedMouseScreenCorner == -1)
        return;

    int corner = [self screenCornerFromEvent:event];
    if(corner != m_DraggedMouseScreenCorner)
        corner = -1;

    if(m_ClickedMouseScreenCorner != corner)
    {
        m_ClickedMouseScreenCorner = corner;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseUp:(NSEvent*)event
{
    if(m_DraggedMouseScreenCorner == -1)
        return;

    [self mouseDragged:event];
    m_DraggedMouseScreenCorner = -1;

    if(m_ClickedMouseScreenCorner >= 0)
    {
        [self setScreenCorner:(UserNotificationCenterScreenCorner)m_ClickedMouseScreenCorner];
        if(m_Target != nil && m_Action != nil)
            [m_Target performSelector:m_Action withObject:self];

        m_ClickedMouseScreenCorner = -1;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseEntered:(NSEvent*)event
{
    if(![self isEnabled])
        return;

    int corner = [self screenCornerFromEvent:event];
    if(m_UnderMouseScreenCorner != corner)
    {
        m_UnderMouseScreenCorner = corner;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseExited:(NSEvent*)event
{
    if(m_UnderMouseScreenCorner < 0)
        return;

    m_UnderMouseScreenCorner = -1;
    [self setNeedsDisplay:YES];

}

- (BOOL)isEnabled
{
    return m_IsEnabled;
}

- (void)setEnabled:(BOOL)enabled
{
    if(m_IsEnabled == enabled)
        return;

    m_IsEnabled                 = enabled;
    m_UnderMouseScreenCorner    = -1;
    m_DraggedMouseScreenCorner  = -1;
    m_ClickedMouseScreenCorner  = -1;

    [self setNeedsDisplay:YES];
}

- (UserNotificationCenterScreenCorner)screenCorner
{
    return m_ScreenCorner;
}

- (void)setScreenCorner:(UserNotificationCenterScreenCorner)corner
{
    if(m_ScreenCorner == corner)
        return;

    m_ScreenCorner = corner;
    [self setNeedsDisplay:YES];
}

- (id)target
{
    return m_Target;
}

- (void)setTarget:(id)obj
{
    m_Target = obj;
}

- (SEL)action
{
    return m_Action;
}

- (void)setAction:(SEL)sel
{
    m_Action = sel;
}

@end

@implementation UserNotificationCenterScreenCornerView (PrivatePart)

- (NSBezierPath*)pathForCornerPoint
{
    NSPoint point = NSZeroPoint;
    NSRect  rect  = [self bounds];

    switch(m_ScreenCorner)
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

    if(m_UnderMouseScreenCorner == corner)
        alphaValue = 0.75f;

    if(m_ClickedMouseScreenCorner == corner)
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
    m_TrackingRectTags[0] = [self addTrackingRect:[path bounds]
                                            owner:self
                                         userData:nil
                                     assumeInside:[path containsPoint:mousePosition]];

    path = [self pathForTriangle:UserNotificationCenterScreenCornerRightTop];
    m_TrackingRectTags[1] = [self addTrackingRect:[path bounds]
                                            owner:self
                                         userData:nil
                                     assumeInside:[path containsPoint:mousePosition]];

    path = [self pathForTriangle:UserNotificationCenterScreenCornerRightBottom];
    m_TrackingRectTags[2] = [self addTrackingRect:[path bounds]
                                            owner:self
                                         userData:nil
                                     assumeInside:[path containsPoint:mousePosition]];

    path = [self pathForTriangle:UserNotificationCenterScreenCornerLeftBottom];
    m_TrackingRectTags[3] = [self addTrackingRect:[path bounds]
                                            owner:self
                                         userData:nil
                                     assumeInside:[path containsPoint:mousePosition]];
}

- (void)removeTrackingRects
{
    for(int i = 0; i < 4; i++)
    {
        if(m_TrackingRectTags[i] != 0)
        {
            [self removeTrackingRect:m_TrackingRectTags[i]];
            m_TrackingRectTags[i] = 0;
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
