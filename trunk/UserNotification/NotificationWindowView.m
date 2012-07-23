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

    isHowered               = NO;
    isCloseButtonDragged    = NO;
    isCloseButtonPressed    = NO;
    trackingRectTag         = 0;

    [self updateTrackingRect];

    return self;
}

- (id)initWithCoder:(NSCoder*)decoder
{
    self = [super initWithCoder:decoder];
    if(self == nil)
        return nil;

    isHowered               = NO;
    isCloseButtonDragged    = NO;
    isCloseButtonPressed    = NO;
    isAlreadyClicked        = NO;
    trackingRectTag         = 0;

    [self updateTrackingRect];

    return self;
}

- (void)dealloc
{
    [self removeTrackingRect];

    [icon release];
    [title release];
    [text release];
    [super dealloc];
}

- (NSImage*)icon
{
    return [[icon retain] autorelease];
}

- (void)setIcon:(NSImage*)img
{
    if(icon == img)
        return;

    [icon release];
    icon = [img retain];

    [icon setSize:NSMakeSize(32.0f, 32.0f)];
    [self setNeedsDisplay:YES];
}

- (NSString*)title
{
    return [[title retain] autorelease];
}

- (void)setTitle:(NSString*)str
{
    if(title == str)
        return;

    [title release];
    title = [str retain];

    [self setNeedsDisplay:YES];
}

- (NSString*)text
{
    return [[text retain] autorelease];
}

- (void)setText:(NSString*)str
{
    if(text == str)
        return;

    [text release];
    text = [str retain];

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

- (id<NotificationWindowViewDelegate>)delegate
{
    return delegate;
}

- (void)setDelegate:(id<NotificationWindowViewDelegate>)obj
{
    delegate = obj;
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
        isCloseButtonDragged = YES;
        [self setCloseButtonPressed:YES];
    }
}

- (void)mouseDragged:(NSEvent*)event
{
    if(!isCloseButtonDragged)
        return;

    NSPoint mousePosition = [self convertPoint:[event locationInWindow]
                                      fromView:nil];

    [self setCloseButtonPressed:
                        NSPointInRect(
                            mousePosition,
                            [self closeButtonRect:[self bounds]])];
}

- (void)mouseUp:(NSEvent*)event
{
    if(!isCloseButtonPressed)
    {
        if(target != nil && action != nil && !isAlreadyClicked)
        {
            [target performSelector:action withObject:self];
            isAlreadyClicked = YES;
        }
    }

    [self setCloseButtonPressed:NO];
    isCloseButtonDragged = NO;

    [[self window] close];
}

- (void)mouseEntered:(NSEvent*)event
{
    [self setHowered:YES];
    [delegate notificationWindowViewMouseEntered:self];
}

- (void)mouseExited:(NSEvent*)event
{
    [self setHowered:NO];
    [delegate notificationWindowViewMouseExited:self];
}

- (void)drawRect:(NSRect)rect
{
    rect = [self bounds];

    [NSGraphicsContext saveGraphicsState];
    CGContextSetShouldSmoothFonts([[NSGraphicsContext currentContext] graphicsPort], NO);

    [[NSColor colorWithDeviceWhite:0.0f alpha:0.6f] setFill];
    [[NSBezierPath bezierPathWithRoundedRect:rect xRadius:10.0f yRadius:10.0f] fill];

    if(icon != nil)
    {
        [icon drawInRect:[self iconRect:rect]
                fromRect:NSZeroRect
               operation:NSCompositeSourceOver
                fraction:1.0f];
    }

    float titleHeight = 0.0f;
    if(title != nil)
    {
        NSDictionary    *attributes = [NotificationWindowView titleTextAttributes];
        NSRect           textRect   = [self titleRect:rect attributes:attributes];

        [title drawWithRect:textRect
                    options:NSStringDrawingDisableScreenFontSubstitution
                 attributes:attributes];

        titleHeight = textRect.size.height;
    }

    if(text != nil)
    {
        NSDictionary *attributes = [NotificationWindowView textAttributes];

        [text drawWithRect:[self textRect:rect titleHeight:titleHeight attributes:attributes]
                   options:NSStringDrawingUsesLineFragmentOrigin |
                                NSStringDrawingDisableScreenFontSubstitution
                attributes:attributes];
    }

    if(isHowered)
    {
        NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(rect, 1.0f, 1.0f)
                                                             xRadius:10.0f
                                                             yRadius:10.0f];

        [[NSColor colorWithDeviceWhite:1.0f alpha:1.0f] setStroke];
        [path setLineWidth:2.0f];
        [path stroke];

        [self drawCloseButton:rect];
    }

    [NSGraphicsContext restoreGraphicsState];
}

@end

@implementation NotificationWindowView (PrivatePart)

- (BOOL)isHowered
{
    return isHowered;
}

- (void)setHowered:(BOOL)hovered
{
    if(isHowered == hovered)
        return;

    isHowered = hovered;
    [self setNeedsDisplay:YES];
}

- (BOOL)isCloseButtonPressed
{
    return isCloseButtonPressed;
}

- (void)setCloseButtonPressed:(BOOL)pressed
{
    if(isCloseButtonPressed == pressed)
        return;

    isCloseButtonPressed = pressed;
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
    if(trackingRectTag != 0)
    {
        [self removeTrackingRect:trackingRectTag];
        trackingRectTag = 0;
    }
}

- (void)updateTrackingRect
{
    [self removeTrackingRect];

    trackingRectTag = [self addTrackingRect:[self bounds]
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
    NSSize size = [title sizeWithAttributes:attributes];

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
           [text boundingRectWithSize:maxRect.size
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
    NSImage *image = (isCloseButtonPressed)?
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
                            [NSFont systemFontOfSize:12.0f],        NSFontAttributeName,
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
