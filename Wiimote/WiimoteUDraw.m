//
//  WiimoteUDraw.m
//  Wiimote
//
//  Created by Michael Kessler on 10/4/14.
//

#import "WiimoteUDraw.h"

@implementation WiimoteUDraw

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[WiimoteUDraw class]];
}

+ (NSData*)extensionSignature
{
	static const uint8_t  signature[]	= { 0xff, 0x00, 0xA4, 0x20, 0x01, 0x12 };

	static NSData *result = nil;

	if(result == nil)
	{
        result = [[NSData alloc]
                        initWithBytes:signature
                               length:sizeof(signature)];
	}

	return result;
}

+ (WiimoteExtensionMeritClass)meritClass
{
    return WiimoteExtensionMeritClassSystem;
}

+ (NSUInteger)minReportDataSize
{
    return sizeof(WiimoteDeviceUDrawReport);
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
{
    self = [super initWithOwner:owner
                eventDispatcher:dispatcher];

    if(self == nil)
        return nil;

    m_IsPenPressed       = NO;
    m_PenPosition        = NSZeroPoint;
    m_PenPressure        = 0.0;
    m_IsPenButtonPressed = NO;

    return self;
}

- (NSString*)name
{
    return @"uDraw";
}

- (BOOL)isPenPressed
{
    return m_IsPenPressed;
}

- (void)setPenPressed:(BOOL)pressed
{
    if(m_IsPenPressed != pressed)
    {
        m_IsPenPressed = pressed;

        if(m_IsPenPressed)
            [[self eventDispatcher] postUDrawPenPressed:self];
        else
            [[self eventDispatcher] postUDrawPenReleased:self];
    }
}

- (NSPoint)penPosition
{
    return m_PenPosition;
}

- (CGFloat)penPressure
{
    return m_PenPressure;
}

- (void)setPenPosition:(NSPoint)position pressure:(CGFloat)pressure
{
    if(!WiimoteDeviceIsPointEqual(m_PenPosition, position) ||
       !WiimoteDeviceIsFloatEqual(m_PenPressure, pressure))
    {
        m_PenPosition = position;
        m_PenPressure = pressure;

        [[self eventDispatcher]
                            postUDraw:self
                   penPositionChanged:m_PenPosition
                             pressure:m_PenPressure];
    }
}

- (BOOL)isPenButtonPressed
{
    return m_IsPenButtonPressed;
}

- (void)setPenButtonPressed:(BOOL)pressed
{
    if(m_IsPenButtonPressed != pressed)
    {
        m_IsPenButtonPressed = pressed;
        if(m_IsPenButtonPressed)
            [[self eventDispatcher] postUDrawPenButtonPressed:self];
        else
            [[self eventDispatcher] postUDrawPenButtonReleased:self];
    }
}

- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length
{
    if(length < sizeof(WiimoteDeviceUDrawReport))
        return;

/*
    0x00	Y offset from top-left corner of current grid of press point, or 0xFF if not pressed.
    0x01	X offset from top-left corner of current grid of press point, or 0xFF if not pressed.
    0x02	Upper nibble is minimum X grid that something is being pressed in (0-5), starting at lower left corner,
                    or 0x0F if not pressed. Lower nibble is minimum Y grid (0-7).
    0x03	Pen pressure, goes from ~0x08 (not pressed at all) to ~0xF4 (pressed hard).
    0x04	Unknown, always 0xFF.
    0x05	Bit 1 is reset when the pen button is being held down.
*/

    const WiimoteDeviceUDrawReport *report =
        (const WiimoteDeviceUDrawReport*)extensionData;

    BOOL isPenPressed       = ((report->gridIndex   & 0x0F) != 0x0F);
    BOOL isPenButtonPressed = ((report->buttonState & 0x02) == 0);

    [self setPenPressed:isPenPressed];

    if(isPenPressed)
    {
        CGFloat penPressure = (((CGFloat)report->pressure) - 8.0) / 236.0; // 0xF4 - 0x08 = 236 in dec
        NSPoint penPosition = NSMakePoint(
                                    ((report->gridIndex >> 0) & 0x0F) * 256 + report->xOffset,
                                    ((report->gridIndex >> 4) & 0x0F) * 256 + report->yOffset);

        if(penPressure < 0.0) penPressure = 0.0;
        if(penPressure > 1.0) penPressure = 1.0;

        [self setPenPosition:penPosition pressure:penPressure];
    }
    else
        [self setPenPosition:m_PenPosition pressure:0.0];

    [self setPenButtonPressed:isPenButtonPressed];
}

@end
