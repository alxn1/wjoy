//
//  NotificationWindowView.m
//  UserNotification
//
//  Created by alxn1 on 19.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "NotificationWindowView.h"

#define NotificationWindowViewWidth      300.0f
#define NotificationWindowViewMaxHeight  600.0f

@interface NotificationWindowView (PrivatePart)

- (BOOL)isHowered;
- (void)setHowered:(BOOL)hovered;

- (BOOL)isCloseButtonPressed;
- (void)setCloseButtonPressed:(BOOL)pressed;

- (BOOL)isMouseInside;

- (void)removeTrackingRect;
- (void)updateTrackingRect;

- (NSRect)closeButtonRect:(NSRect)rect;
- (NSRect)iconRect:(NSRect)rect;
- (NSRect)titleRect:(NSRect)rect attributes:(NSDictionary*)attributes;
- (NSSize)maxTextSize:(NSRect)rect titleHeight:(float)titleHeight;
- (NSRect)textRect:(NSRect)rect titleHeight:(float)titleHeight attributes:(NSDictionary*)attributes;

- (void)drawCloseButton:(NSRect)rect;

+ (NSDictionary*)titleTextAttributes;
+ (NSDictionary*)textAttributes;

+ (NSSize)titleSize:(NSString*)title;
+ (NSSize)textSize:(NSString*)text;

+ (NSString*)pathForImage:(NSString*)name;

+ (NSImage*)closeButtonImage;
+ (NSImage*)pressedCloseButtonImage;

@end

@implementation NotificationWindowView

+ (NSRect)bestViewRectForTitle:(NSString*)title text:(NSString*)text
{
    NSRect result       = NSZeroRect;
    NSSize titleSize    = [NotificationWindowView titleSize:title];
    NSSize textSize     = [NotificationWindowView textSize:text];

    result.size.width   = NotificationWindowViewWidth;
    result.size.height  = 10.0f + titleSize.height + 10.0f + textSize.height + 20.0f;

    if(result.size.height > NotificationWindowViewMaxHeight)
        result.size.height = NotificationWindowViewMaxHeight;

    return result;
}

- (id)initWithFrame:(NSRect)rect
{
    self = [super initWithFrame:rect];
    if(self == nil)
        return nil;

    m_IsHowered             = NO;
    m_IsMouseDragged        = NO;
    m_IsCloseButtonDragged  = NO;
    m_IsCloseButtonPressed  = NO;
    m_IsAlreadyClicked      = NO;
    m_TrackingRectTag       = 0;

    [self updateTrackingRect];

    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if(self == nil)
        return nil;

    m_IsHowered             = NO;
    m_IsCloseButtonDragged  = NO;
    m_IsCloseButtonPressed  = NO;
    m_IsAlreadyClicked      = NO;
    m_TrackingRectTag       = 0;

    [self updateTrackingRect];

    return self;
}

- (void)dealloc
{
    [self removeTrackingRect];

    [m_Icon release];
    [m_Title release];
    [m_Text release];
    [super dealloc];
}

- (NSImage*)icon
{
    return [[m_Icon retain] autorelease];
}

- (void)setIcon:(NSImage*)img
{
    if(m_Icon == img)
        return;

    [m_Icon release];
    m_Icon = [img retain];

	[m_Icon setScalesWhenResized:YES];
    [m_Icon setSize:NSMakeSize(32.0f, 32.0f)];
    [self setNeedsDisplay:YES];
}

- (NSString*)title
{
    return [[m_Title retain] autorelease];
}

- (void)setTitle:(NSString*)str
{
    if(m_Title == str)
        return;

    [m_Title release];
    m_Title = [str retain];

    [self setNeedsDisplay:YES];
}

- (NSString*)text
{
    return [[m_Text retain] autorelease];
}

- (void)setText:(NSString*)str
{
    if(m_Text == str)
        return;

    [m_Text release];
    m_Text = [str retain];

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

- (id<NotificationWindowViewDelegate>)delegate
{
    return m_Delegate;
}

- (void)setDelegate:(id<NotificationWindowViewDelegate>)obj
{
    m_Delegate = obj;
}

- (void)viewDidHide
{
    [self removeTrackingRect];
}

- (void)viewDidUnhide
{
    [self updateTrackingRect];
}

- (BOOL)acceptsFirstMouse:(NSEvent*)event
{
    return YES;
}

- (void)mouseDown:(NSEvent*)event
{
    NSPoint mousePosition = [self convertPoint:[event locationInWindow]
                                      fromView:nil];

    if(NSPointInRect(
            mousePosition,
            [self closeButtonRect:[self bounds]]))
    {
        m_IsCloseButtonDragged = YES;
        [self setCloseButtonPressed:YES];
    }

    m_IsMouseDragged = YES;
}

- (void)mouseDragged:(NSEvent*)event
{
    NSPoint mousePosition = [self convertPoint:[event locationInWindow]
                                      fromView:nil];

    [self setHowered:NSPointInRect(mousePosition, [self frame])];

    if(m_IsCloseButtonDragged)
    {
        [self setCloseButtonPressed:
                            NSPointInRect(
                                mousePosition,
                                [self closeButtonRect:[self bounds]])];
    }
}

- (void)mouseUp:(NSEvent*)event
{
    if(!m_IsCloseButtonPressed && [self isHowered])
    {
        if(m_Target != nil && m_Action != nil && !m_IsAlreadyClicked)
        {
            [m_Target performSelector:m_Action withObject:self];
            m_IsAlreadyClicked = YES;
        }
    }

    [self setCloseButtonPressed:NO];
    m_IsCloseButtonDragged = NO;
    m_IsMouseDragged = NO;

    if([self isHowered])
        [[self window] close];
}

- (void)mouseEntered:(NSEvent*)event
{
    if(m_IsMouseDragged)
        return;

    [self setHowered:YES];
}

- (void)mouseExited:(NSEvent*)event
{
    if(m_IsMouseDragged)
        return;

    [self setHowered:NO];
}

+ (NSGradient*)bgGradient
{
    static NSGradient *result = nil;

    if(result == nil)
    {
        result = [[NSGradient alloc] initWithColorsAndLocations:
                                                [NSColor clearColor],                            0.0f,
                                                [NSColor colorWithDeviceWhite:0.0f alpha:0.25f], 0.5f,
                                                [NSColor colorWithDeviceWhite:0.5f alpha:0.35f], 0.9f,
                                                nil];
    }

    return result;
}

- (void)drawRect:(NSRect)rect
{
    rect = [self bounds];

    [NSGraphicsContext saveGraphicsState];
    CGContextSetShouldSmoothFonts([[NSGraphicsContext currentContext] graphicsPort], NO);

    NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:10.0f yRadius:10.0f];
    [[NSColor colorWithDeviceWhite:0.0f alpha:0.7f] setFill];

    [bgPath fill];
    [[NotificationWindowView bgGradient] drawInBezierPath:bgPath angle:90.0f];

    if(m_Icon != nil)
    {
        [m_Icon drawInRect:[self iconRect:rect]
                  fromRect:NSZeroRect
                 operation:NSCompositeSourceOver
                  fraction:1.0f];
    }

    float titleHeight = 0.0f;
    if(m_Title != nil)
    {
        NSDictionary    *attributes = [NotificationWindowView titleTextAttributes];
        NSRect           textRect   = [self titleRect:rect attributes:attributes];

        [m_Title drawWithRect:textRect
                      options:NSStringDrawingDisableScreenFontSubstitution
                   attributes:attributes];

        titleHeight = textRect.size.height;
    }

    if(m_Text != nil)
    {
        NSDictionary *attributes = [NotificationWindowView textAttributes];

        [m_Text drawWithRect:[self textRect:rect titleHeight:titleHeight attributes:attributes]
                     options:NSStringDrawingUsesLineFragmentOrigin |
                                NSStringDrawingDisableScreenFontSubstitution
                attributes:attributes];
    }

    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(rect, 1.0f, 1.0f)
                                                         xRadius:10.0f
                                                         yRadius:10.0f];

    if([self isHowered])
    {
        [[NSColor colorWithDeviceWhite:1.0f alpha:1.0f] setStroke];
        [path setLineWidth:2.0f];
    }
    else
    {
        [[NSColor colorWithDeviceWhite:1.0f alpha:0.45f] setStroke];
        [path setLineWidth:1.5f];
    }
    
    [path stroke];

    if([self isHowered])
        [self drawCloseButton:rect];

    [NSGraphicsContext restoreGraphicsState];
}

@end

@implementation NotificationWindowView (PrivatePart)

- (BOOL)isHowered
{
    return m_IsHowered;
}

- (void)setHowered:(BOOL)hovered
{
    if(m_IsHowered == hovered)
        return;

    m_IsHowered = hovered;
    [self setNeedsDisplay:YES];

    if(hovered)
        [m_Delegate notificationWindowViewMouseEntered:self];
    else
        [m_Delegate notificationWindowViewMouseExited:self];
}

- (BOOL)isCloseButtonPressed
{
    return m_IsCloseButtonPressed;
}

- (void)setCloseButtonPressed:(BOOL)pressed
{
    if(m_IsCloseButtonPressed == pressed)
        return;

    m_IsCloseButtonPressed = pressed;
    [self setNeedsDisplay:YES];
}

- (BOOL)isMouseInside
{
    NSPoint mousePosition = [[self window] mouseLocationOutsideOfEventStream];
    mousePosition         = [self convertPoint:mousePosition
                                      fromView:nil];

    return NSPointInRect(mousePosition, [self bounds]);
}

- (void)removeTrackingRect
{
    if(m_TrackingRectTag != 0)
    {
        [self removeTrackingRect:m_TrackingRectTag];
        m_TrackingRectTag = 0;
    }
}

- (void)updateTrackingRect
{
    [self removeTrackingRect];

    m_TrackingRectTag = [self addTrackingRect:[self bounds]
                                        owner:self
                                     userData:NULL
                                 assumeInside:[self isMouseInside]];
}

- (NSRect)closeButtonRect:(NSRect)rect
{
    NSSize closeButtonSize = [[NotificationWindowView closeButtonImage] size];

    return NSMakeRect(
                rect.origin.x + 3.0f,
                rect.origin.y + rect.size.height - closeButtonSize.height - 5.0f,
                closeButtonSize.width,
                closeButtonSize.height);
}

- (NSRect)iconRect:(NSRect)rect
{
    return NSMakeRect(
                    rect.origin.x + 10.0f,
                    rect.origin.y + rect.size.height - 32.0f - 10.0f,
                    32.0f,
                    32.0f);
}

- (NSRect)titleRect:(NSRect)rect attributes:(NSDictionary*)attributes
{
    NSSize size = [m_Title sizeWithAttributes:attributes];

    if(size.width > (rect.size.width - 10.0f - 32.0f - 10.0f - 20.0f))
        size.width = rect.size.width - 10.0f - 32.0f - 10.0f - 20.0f;

    return NSMakeRect(
                    rect.origin.x + 10.0f + 32.0f + 10.0f,
                    rect.origin.y + rect.size.height - size.height - 10.0f,
                    size.width,
                    size.height);
}

- (NSSize)maxTextSize:(NSRect)rect titleHeight:(float)titleHeight
{
    return NSMakeSize(
                rect.size.width - 10.0f - 32.0f - 10.0f - 20.0f,
                rect.size.height - 10.0f - titleHeight - 10.0f - 10.0f);
}

- (NSRect)textRect:(NSRect)rect titleHeight:(float)titleHeight attributes:(NSDictionary*)attributes
{
    NSRect maxRect = rect;

    maxRect.origin.x += 10.0f + 32.0f + 10.0f;
    maxRect.origin.y += 10.0f;
    maxRect.size      = [self maxTextSize:rect titleHeight:titleHeight];

    NSRect result =
           [m_Text boundingRectWithSize:maxRect.size
                                options:NSStringDrawingUsesLineFragmentOrigin |   
                                            NSStringDrawingDisableScreenFontSubstitution
                             attributes:attributes];

    if(result.size.height > maxRect.size.height)
        result.size.height = maxRect.size.height;

    result.origin.x = maxRect.origin.x;
    result.origin.y = maxRect.origin.y + maxRect.size.height - result.size.height;

    return result;
}

- (void)drawCloseButton:(NSRect)rect
{
    NSImage *image = (m_IsCloseButtonPressed)?
                                ([NotificationWindowView pressedCloseButtonImage]):
                                ([NotificationWindowView closeButtonImage]);

    [image drawInRect:[self closeButtonRect:rect]
             fromRect:NSZeroRect
            operation:NSCompositeSourceOver
             fraction:1.0f];
}

+ (NSDictionary*)titleTextAttributes
{
    NSMutableParagraphStyle *style = [[[NSMutableParagraphStyle alloc] init] autorelease];

    [style setAlignment:NSLeftTextAlignment];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];

    return [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSColor whiteColor],                   NSForegroundColorAttributeName,
                            [NSFont boldSystemFontOfSize:13.0f],    NSFontAttributeName,
                            style,                                  NSParagraphStyleAttributeName,
                            nil];
}

+ (NSDictionary*)textAttributes
{
    NSMutableParagraphStyle *style = [[[NSMutableParagraphStyle alloc] init] autorelease];

    [style setAlignment:NSLeftTextAlignment];
    [style setLineBreakMode:NSLineBreakByWordWrapping];

    return [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSColor whiteColor],                   NSForegroundColorAttributeName,
                            [NSFont menuFontOfSize:12.0f],          NSFontAttributeName,
                            style,                                  NSParagraphStyleAttributeName,
                            nil];
}

+ (NSSize)titleSize:(NSString*)title
{
    NSSize size = [title sizeWithAttributes:[NotificationWindowView titleTextAttributes]];

    if(size.width > (NotificationWindowViewWidth - 10.0f - 32.0f - 10.0f - 20.0f)) {
        size.width = NotificationWindowViewWidth - 10.0f - 32.0f - 10.0f - 20.0f;
    }

    return size;
}

+ (NSSize)textSize:(NSString*)text
{
    NSRect result =
           [text boundingRectWithSize:NSMakeSize(
                                            NotificationWindowViewWidth - 10.0f - 32.0f - 10.0f - 20.0f,
                                            NotificationWindowViewMaxHeight)
                              options:NSStringDrawingUsesLineFragmentOrigin |   
                                            NSStringDrawingDisableScreenFontSubstitution
                           attributes:[NotificationWindowView textAttributes]];

    if(result.size.height > NotificationWindowViewMaxHeight)
        result.size.height = NotificationWindowViewMaxHeight;

    return result.size;
}

+ (NSString*)pathForImage:(NSString*)name
{
    return [[NSBundle bundleForClass:[NotificationWindowView class]]
                                                            pathForResource:name
                                                                     ofType:@"png"];
}

+ (NSImage*)closeButtonImage
{
    static NSImage *result = nil;

    if(result == nil)
    {
        result = [[NSImage alloc] initWithContentsOfFile:
                            [NotificationWindowView pathForImage:@"closebutton"]];
    }

    return result;
}

+ (NSImage*)pressedCloseButtonImage
{
    static NSImage *result = nil;

    if(result == nil)
    {
        result = [[NSImage alloc] initWithContentsOfFile:
                            [NotificationWindowView pathForImage:@"closebutton_pressed"]];
    }

    return result;
}

@end
