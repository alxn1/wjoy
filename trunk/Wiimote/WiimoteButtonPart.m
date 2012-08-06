//
//  WiimoteButtonPart.m
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteProtocol.h"
#import "WiimoteButtonPart.h"
#import "WiimoteEventDispatcher+Button.h"

@interface WiimoteButtonPart (PrivatePart)

- (void)setButton:(WiimoteButtonType)button pressed:(BOOL)pressed;

- (void)reset;

@end

@implementation WiimoteButtonPart

+ (void)load
{
    [WiimotePart registerPartClass:[WiimoteButtonPart class]];
}

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher
          ioManager:(WiimoteIOManager*)ioManager;
{
    self = [super initWithOwner:owner eventDispatcher:dispatcher ioManager:ioManager];
    if(self == nil)
        return nil;

    [self reset];
    return self;
}

- (BOOL)isButtonPressed:(WiimoteButtonType)button
{
    return m_ButtonState[button];
}

- (void)handleReport:(WiimoteDeviceReport*)report
{
    if([report length] < sizeof(WiimoteDeviceButtonState))
        return;

    const WiimoteDeviceButtonState *buttonReport =
            (const WiimoteDeviceButtonState*)[report data];

    WiimoteDeviceButtonState state = OSSwapBigToHostConstInt16(*buttonReport);

    [self setButton:WiimoteButtonTypeLeft   pressed:((state & WiimoteDeviceButtonStateFlagLeft)   != 0)];
    [self setButton:WiimoteButtonTypeRight  pressed:((state & WiimoteDeviceButtonStateFlagRight)  != 0)];
    [self setButton:WiimoteButtonTypeDown   pressed:((state & WiimoteDeviceButtonStateFlagDown)   != 0)];
    [self setButton:WiimoteButtonTypeUp     pressed:((state & WiimoteDeviceButtonStateFlagUp)     != 0)];
    [self setButton:WiimoteButtonTypePlus   pressed:((state & WiimoteDeviceButtonStateFlagPlus)   != 0)];
    [self setButton:WiimoteButtonTypeTwo    pressed:((state & WiimoteDeviceButtonStateFlagTwo)    != 0)];
    [self setButton:WiimoteButtonTypeOne    pressed:((state & WiimoteDeviceButtonStateFlagOne)    != 0)];
    [self setButton:WiimoteButtonTypeB      pressed:((state & WiimoteDeviceButtonStateFlagB)      != 0)];
    [self setButton:WiimoteButtonTypeA      pressed:((state & WiimoteDeviceButtonStateFlagA)      != 0)];
    [self setButton:WiimoteButtonTypeMinus  pressed:((state & WiimoteDeviceButtonStateFlagMinus)  != 0)];
    [self setButton:WiimoteButtonTypeHome   pressed:((state & WiimoteDeviceButtonStateFlagHome)   != 0)];
}

- (void)disconnected
{
    [self reset];
}

@end

@implementation WiimoteButtonPart (PrivatePart)

- (void)setButton:(WiimoteButtonType)button pressed:(BOOL)pressed
{
    if(m_ButtonState[button] == pressed)
        return;

    m_ButtonState[button] = pressed;

    if(pressed)
        [[self eventDispatcher] postButtonPressedNotification:button];
    else
        [[self eventDispatcher] postButtonReleasedNotification:button];
}

- (void)reset
{
    for(NSUInteger i = 0; i < WiimoteButtonCount; i++)
        m_ButtonState[i] = NO;
}

@end
