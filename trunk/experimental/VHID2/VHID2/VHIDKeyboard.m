//
//  VHIDKeyboard.m
//  VHID
//
//  Created by alxn1 on 17.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDKeyboard.h"

#import "VHIDDevice+Private.h"

#define VHID_KB_STATE_SIZE          8
#define VHID_KB_MODIFIER_BYTE       0
#define VHID_KB_FIRST_BUTTON_BYTE   2
#define VHID_KB_LAST_BUTTON_BYTE    7

typedef enum {
    VHIDKeyboardModifierTypeNone        = 0,

    VHIDKeyboardModifierTypeLeftCTRL    = (1 << 0),
    VHIDKeyboardModifierTypeLeftSHIFT   = (1 << 1),
    VHIDKeyboardModifierTypeLeftALT     = (1 << 2),
    VHIDKeyboardModifierTypeLeftCMD     = (1 << 3),
    VHIDKeyboardModifierTypeRightCTRL   = (1 << 4),
    VHIDKeyboardModifierTypeRightSHIFT  = (1 << 5),
    VHIDKeyboardModifierTypeRightALT    = (1 << 6),
    VHIDKeyboardModifierTypeRightCMD    = (1 << 7)
} VHIDKeyboardModifierType;

@implementation VHIDKeyboard

+ (NSData*)descriptor
{
    static const unsigned char descriptor[] =
    {
        0x05, 0x01, // USAGE_PAGE (Generic Desktop)
        0x09, 0x06, // USAGE (Keyboard)
        0xa1, 0x01, // COLLECTION (Application)

        // modifiers byte
        0x05, 0x07, // USAGE_PAGE (Keyboard)
        0x19, 0xe0, // USAGE_MINIMUM (Keyboard LeftControl)
        0x29, 0xe7, // USAGE_MAXIMUM (Keyboard Right GUI)
        0x15, 0x00, // LOGICAL_MINIMUM (0)
        0x25, 0x01, // LOGICAL_MAXIMUM (1)
        0x75, 0x01, // REPORT_SIZE (1)
        0x95, 0x08, // REPORT_COUNT (8)
        0x81, 0x02, // INPUT (Data,Var,Abs)

        // unused byte (alignment)
        0x95, 0x01, // REPORT_COUNT (1)
        0x75, 0x08, // REPORT_SIZE (8)
        0x81, 0x03, // INPUT (Cnst,Var,Abs)

        // scancode buffer
        0x95, 0x06, // REPORT_COUNT (6)
        0x75, 0x08, // REPORT_SIZE (8)
        0x15, 0x00, // LOGICAL_MINIMUM (0)
        0x25, 0xA4, // LOGICAL_MAXIMUM (0xA4)
        0x05, 0x07, // USAGE_PAGE (Keyboard)
        0x19, 0x00, // USAGE_MINIMUM (Reserved (no event indicated))
        0x29, 0xA4, // USAGE_MAXIMUM (Keyboard Application)
        0x81, 0x00, // INPUT (Data,Ary,Abs)

        0xc0        // END_COLLECTION
    };

    static NSData *result = nil;

    if(result == nil)
        result = [[NSData alloc] initWithBytes:descriptor length:sizeof(descriptor)];

    return result;
}

+ (VHIDKeyboard*)keyboard
{
    return [[[VHIDKeyboard alloc] init] autorelease];
}

- (id)init
{
    return [super initWithDescriptor:[VHIDKeyboard descriptor]
                           stateSize:VHID_KB_STATE_SIZE];
}

- (VHIDKeyboardModifierType)modifierType:(VHIDKeyboardButtonType)button
{
    static const VHIDKeyboardModifierType masks[] =
    {
        VHIDKeyboardModifierTypeLeftCTRL,
        VHIDKeyboardModifierTypeLeftSHIFT,
        VHIDKeyboardModifierTypeLeftALT,
        VHIDKeyboardModifierTypeLeftCMD,
        VHIDKeyboardModifierTypeRightCTRL,
        VHIDKeyboardModifierTypeRightSHIFT,
        VHIDKeyboardModifierTypeRightALT,
        VHIDKeyboardModifierTypeRightCMD
    };

    VHIDKeyboardModifierType result = VHIDKeyboardModifierTypeNone;

    if(button >= VHIDKeyboardButtonTypeLeftCTRL && button <= VHIDKeyboardButtonTypeRightCMD)
        result = masks[button - VHIDKeyboardButtonTypeLeftCTRL];

    return result;
}

- (BOOL)isButtonPressed:(VHIDKeyboardButtonType)button
{
    VHIDKeyboardModifierType    modifierType   = [self modifierType:button];
    unsigned char              *state          = [self mutableStateBytes];

    if(modifierType != VHIDKeyboardModifierTypeNone)
        return ((state[0] & modifierType) != 0);

    for(int i = VHID_KB_FIRST_BUTTON_BYTE; i <= VHID_KB_LAST_BUTTON_BYTE; i++)
    {
        if(state[i] == button)
            return YES;
    }

    return NO;
}

- (void)setModifier:(VHIDKeyboardModifierType)modifier pressed:(BOOL)pressed
{
    unsigned char *state = [self mutableStateBytes];

    if(pressed)
        state[VHID_KB_MODIFIER_BYTE] |=  modifier;
    else
        state[VHID_KB_MODIFIER_BYTE] &= ~modifier;
}

- (void)setButtonPressed:(VHIDKeyboardButtonType)button
{
    unsigned char *state = [self mutableStateBytes];

    for(int i = VHID_KB_FIRST_BUTTON_BYTE; i <= VHID_KB_LAST_BUTTON_BYTE; i++)
    {
        if(state[i] == 0)
        {
            state[i] = button;
            break;
        }
    }
}

- (void)setButtonReleased:(VHIDKeyboardButtonType)button
{
    unsigned char *state = [self mutableStateBytes];

    for(int i = VHID_KB_FIRST_BUTTON_BYTE; i <= VHID_KB_LAST_BUTTON_BYTE; i++)
    {
        if(state[i] == button)
        {
            for(int j = i; j < VHID_KB_LAST_BUTTON_BYTE; j++)
                state[j] = state[j + 1];

            state[VHID_KB_LAST_BUTTON_BYTE] = 0;
            break;
        }
    }
}

- (void)setButton:(VHIDKeyboardButtonType)button pressed:(BOOL)pressed
{
    if([self isButtonPressed:button] == pressed)
        return;

    VHIDKeyboardModifierType modifierType = [self modifierType:button];

    if(modifierType == VHIDKeyboardModifierTypeNone)
    {
        if(pressed)
            [self setButtonPressed:button];
        else
            [self setButtonReleased:button];
    }
    else
        [self setModifier:modifierType pressed:pressed];

    [self notifyAboutStateChanged];
}

@end
