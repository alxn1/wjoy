//
//  VHIDMouse.m
//  VHID
//
//  Created by alxn1 on 17.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDMouse.h"

#import "VHIDDevice+Private.h"

#define VHID_MS_STATE_SIZE  3
#define VHID_MS_BUTTON_BYTE 0
#define VHID_MS_DX_BYTE     1
#define VHID_MS_DY_BYTE     2

@implementation VHIDMouse

+ (NSData*)descriptor
{
    static const unsigned char descriptor[] =
    {
        0x05, 0x01, // USAGE_PAGE (Generic Desktop)
        0x09, 0x02, // USAGE (Mouse)
        0xA1, 0x01, // COLLECTION (Application)
        0x09, 0x01, // USAGE (Pointer)
        0xA1, 0x00, // COLLECTION (Physical)

        // 3 buttons
        0x05, 0x09, // USAGE_PAGE (Button)
        0x19, 0x01, // USAGE_MINIMUM (Button 1)
        0x29, 0x03, // USAGE_MAXIMUM (Button 3)
        0x15, 0x00, // LOGICAL_MINIMUM (0)
        0x25, 0x01, // LOGICAL_MAXIMUM (1)
        0x95, 0x03, // REPORT_COUNT (3)
        0x75, 0x01, // REPORT_SIZE (1)
        0x81, 0x02, // INPUT (Data, Var, Abs)

        // 5 bits padding
        0x95, 0x01, // REPORT_COUNT (1)
        0x75, 0x05, // REPORT_SIZE (5)
        0x81, 0x03, // INPUT (Cnst, Var, Abs)

        // x an y relative coordinates
        0x05, 0x01, // USAGE_PAGE (Generic Desktop)
        0x09, 0x30, // USAGE (x)
        0x09, 0x31, // USAGE (y)
        0x15, 0x81, // LOGICAL_MINIMUM (-127)
        0x25, 0x7F, // LOGICAL_MAXIMUM (127)
        0x75, 0x08, // REPORT_SIZE (8)
        0x95, 0x02, // REPORT_COUNT (2)
        0x81, 0x06, // INPUT (Data, Var, Rel)

        0xC0,       // END_COLLECTION
        0xC0        // END_COLLECTION
    };

    static NSData *result = nil;

    if(result == nil)
        result = [[NSData alloc] initWithBytes:descriptor length:sizeof(descriptor)];

    return result;
}

+ (VHIDMouse*)mouse
{
    return [[[VHIDMouse alloc] init] autorelease];
}

- (id)init
{
    return [super initWithDescriptor:[VHIDMouse descriptor]
                           stateSize:VHID_MS_STATE_SIZE];
}

- (BOOL)isButtonPressed:(VHIDMouseButtonType)button
{
    unsigned char *state = [self mutableStateBytes];

    return ((state[VHID_MS_BUTTON_BYTE] & button) != 0);
}

- (void)setButton:(VHIDMouseButtonType)button pressed:(BOOL)pressed
{
    if([self isButtonPressed:button] == pressed)
        return;

    unsigned char *state = [self mutableStateBytes];

    if(pressed)
        state[VHID_MS_BUTTON_BYTE] |=  button;
    else
        state[VHID_MS_BUTTON_BYTE] &= ~button;

    [self notifyAboutStateChanged];
}

- (void)updateRelativePosition:(NSPoint)positionDelta
{
    if(positionDelta.x < -127.0) positionDelta.x = -127.0;
    if(positionDelta.x >  127.0) positionDelta.x =  127.0;
    if(positionDelta.y < -127.0) positionDelta.y = -127.0;
    if(positionDelta.y >  127.0) positionDelta.y =  127.0;

    char *state = (char*)[self mutableStateBytes];

    state[VHID_MS_DX_BYTE] = (char)(positionDelta.x);
    state[VHID_MS_DY_BYTE] = (char)(positionDelta.y);

    [self notifyAboutStateChanged];
}

@end
