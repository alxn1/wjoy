//
//  VHIDXBox360Controller.m
//  VHID2
//
//  Created by alxn1 on 21.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import <VHID/VHIDXBox360Controller.h>

#import "VHIDGameController+Private.h"

#define VHID_XBOX360_BTN_COUNT          15
#define VHID_XBOX360_STATE_SIZE         20
#define VHID_XBOX360_BTN_STATE_OFFSET   2
#define VHID_XBOX360_SHIFT_STATE_OFFSET 4
#define VHID_XBOX360_AXIS_STATE_OFFSET  6
#define VHID_XBOX360_AXIS_VALUE_EPSILON 0.01

static const unsigned char buttonMasks[] =
{
    1, 2, 4, 8, 16, 32, 64, 128
};

@implementation VHIDXBox360Controller

+ (CGFloat)xbox360_UInt8ToFloat:(uint8_t)value
{
    return ((CGFloat)value / (CGFloat)UINT8_MAX);
}

+ (uint8_t)xbox360_FloatToUInt8:(CGFloat)value
{
    if(value < 0.0f) value = 0.0f;
    if(value > 1.0f) value = 1.0f;

    value *= (CGFloat)UINT8_MAX;

    if(value < 0)           value = 0;
    if(value > UINT8_MAX)   value = UINT8_MAX;

    return (uint8_t)value;
}

+ (VHIDXBox360Controller*)XBox360Controller
{
    return [[[VHIDXBox360Controller alloc] init] autorelease];
}

+ (NSData*)descriptor
{
    static const unsigned char descriptor[] =
    {
        0x05, 0x01,                    // USAGE_PAGE (Generic Desktop)
        0x09, 0x05,                    // USAGE (Game Pad)
        0xa1, 0x01,                    // COLLECTION (Application)
        0x05, 0x01,                    //   USAGE_PAGE (Generic Desktop)
        0x09, 0x3a,                    //   USAGE (Counted Buffer)
        0xa1, 0x02,                    //   COLLECTION (Logical)
        0x75, 0x08,                    //     REPORT_SIZE (8)
        0x95, 0x02,                    //     REPORT_COUNT (2)
        0x05, 0x01,                    //     USAGE_PAGE (Generic Desktop)
        0x09, 0x3f,                    //     USAGE (Reserved)
        0x09, 0x3b,                    //     USAGE (Byte Count)
        0x81, 0x01,                    //     INPUT (Cnst,Ary,Abs)
        0x75, 0x01,                    //     REPORT_SIZE (1)
        0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
        0x25, 0x01,                    //     LOGICAL_MAXIMUM (1)
        0x35, 0x00,                    //     PHYSICAL_MINIMUM (0)
        0x45, 0x01,                    //     PHYSICAL_MAXIMUM (1)
        0x95, 0x04,                    //     REPORT_COUNT (4)
        0x05, 0x09,                    //     USAGE_PAGE (Button)
        0x19, 0x0c,                    //     USAGE_MINIMUM (Button 12)
        0x29, 0x0f,                    //     USAGE_MAXIMUM (Button 15)
        0x81, 0x02,                    //     INPUT (Data,Var,Abs)
        0x75, 0x01,                    //     REPORT_SIZE (1)
        0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
        0x25, 0x01,                    //     LOGICAL_MAXIMUM (1)
        0x35, 0x00,                    //     PHYSICAL_MINIMUM (0)
        0x45, 0x01,                    //     PHYSICAL_MAXIMUM (1)
        0x95, 0x04,                    //     REPORT_COUNT (4)
        0x05, 0x09,                    //     USAGE_PAGE (Button)
        0x09, 0x09,                    //     USAGE (Button 9)
        0x09, 0x0a,                    //     USAGE (Button 10)
        0x09, 0x07,                    //     USAGE (Button 7)
        0x09, 0x08,                    //     USAGE (Button 8)
        0x81, 0x02,                    //     INPUT (Data,Var,Abs)
        0x75, 0x01,                    //     REPORT_SIZE (1)
        0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
        0x25, 0x01,                    //     LOGICAL_MAXIMUM (1)
        0x35, 0x00,                    //     PHYSICAL_MINIMUM (0)
        0x45, 0x01,                    //     PHYSICAL_MAXIMUM (1)
        0x95, 0x03,                    //     REPORT_COUNT (3)
        0x05, 0x09,                    //     USAGE_PAGE (Button)
        0x09, 0x05,                    //     USAGE (Button 5)
        0x09, 0x06,                    //     USAGE (Button 6)
        0x09, 0x0b,                    //     USAGE (Button 11)
        0x81, 0x02,                    //     INPUT (Data,Var,Abs)
        0x75, 0x01,                    //     REPORT_SIZE (1)
        0x95, 0x01,                    //     REPORT_COUNT (1)
        0x81, 0x01,                    //     INPUT (Cnst,Ary,Abs)
        0x75, 0x01,                    //     REPORT_SIZE (1)
        0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
        0x25, 0x01,                    //     LOGICAL_MAXIMUM (1)
        0x35, 0x00,                    //     PHYSICAL_MINIMUM (0)
        0x45, 0x01,                    //     PHYSICAL_MAXIMUM (1)
        0x95, 0x04,                    //     REPORT_COUNT (4)
        0x05, 0x09,                    //     USAGE_PAGE (Button)
        0x19, 0x01,                    //     USAGE_MINIMUM (Button 1)
        0x29, 0x04,                    //     USAGE_MAXIMUM (Button 4)
        0x81, 0x02,                    //     INPUT (Data,Var,Abs)
        0x75, 0x08,                    //     REPORT_SIZE (8)
        0x15, 0x00,                    //     LOGICAL_MINIMUM (0)
        0x26, 0xff, 0x00,              //     LOGICAL_MAXIMUM (255)
        0x35, 0x00,                    //     PHYSICAL_MINIMUM (0)
        0x46, 0xff, 0x00,              //     PHYSICAL_MAXIMUM (255)
        0x95, 0x02,                    //     REPORT_COUNT (2)
        0x05, 0x01,                    //     USAGE_PAGE (Generic Desktop)
        0x09, 0x32,                    //     USAGE (Z)
        0x09, 0x35,                    //     USAGE (Rz)
        0x81, 0x02,                    //     INPUT (Data,Var,Abs)
        0x75, 0x10,                    //     REPORT_SIZE (16)
        0x16, 0x00, 0x80,              //     LOGICAL_MINIMUM (-32768)
        0x26, 0xff, 0x7f,              //     LOGICAL_MAXIMUM (32767)
        0x36, 0x00, 0x80,              //     PHYSICAL_MINIMUM (-32768)
        0x46, 0xff, 0x7f,              //     PHYSICAL_MAXIMUM (32767)
        0x05, 0x01,                    //     USAGE_PAGE (Generic Desktop)
        0x09, 0x01,                    //     USAGE (Pointer)
        0xa1, 0x00,                    //     COLLECTION (Physical)
        0x95, 0x02,                    //       REPORT_COUNT (2)
        0x05, 0x01,                    //       USAGE_PAGE (Generic Desktop)
        0x09, 0x30,                    //       USAGE (X)
        0x09, 0x31,                    //       USAGE (Y)
        0x81, 0x02,                    //       INPUT (Data,Var,Abs)
        0xc0,                          //     END_COLLECTION
        0x05, 0x01,                    //     USAGE_PAGE (Generic Desktop)
        0x09, 0x01,                    //     USAGE (Pointer)
        0xa1, 0x00,                    //     COLLECTION (Physical)
        0x95, 0x02,                    //       REPORT_COUNT (2)
        0x05, 0x01,                    //       USAGE_PAGE (Generic Desktop)
        0x09, 0x33,                    //       USAGE (Rx)
        0x09, 0x34,                    //       USAGE (Ry)
        0x81, 0x02,                    //       INPUT (Data,Var,Abs)
        0xc0,                          //     END_COLLECTION
        0xc0,                          //   END_COLLECTION
        0xc0                           // END_COLLECTION
    };

    static NSData *result = nil;

    if(result == nil)
        result = [[NSData alloc] initWithBytes:descriptor length:sizeof(descriptor)];

    return result;
}

- (id)init
{
    VHIDGameControllerAxisSet axes =
                    VHIDGameControllerAxisX     |
                    VHIDGameControllerAxisY     |
                    VHIDGameControllerAxisZ     |
                    VHIDGameControllerAxisRX    |
                    VHIDGameControllerAxisRY    |
                    VHIDGameControllerAxisRZ;

    self = [super initWithDescriptor:[VHIDXBox360Controller descriptor]
                           stateSize:VHID_XBOX360_STATE_SIZE
                                axes:axes
                         buttonCount:VHID_XBOX360_BTN_COUNT];

    if(self == nil)
        return nil;

    [self reset];
    return self;
}

- (BOOL)isShift:(VHIDGameControllerAxis)axis
{
    return (axis == VHIDGameControllerAxisZ ||
            axis == VHIDGameControllerAxisRZ);
}

- (NSUInteger)shiftIndex:(VHIDGameControllerAxis)axis
{
    return ((axis == VHIDGameControllerAxisZ)?(0):(1));
}

- (NSUInteger)stickIndex:(VHIDGameControllerAxis)axis
{
    NSUInteger result = 0;

    switch(axis) {
        case VHIDGameControllerAxisX:  result = 0; break;
        case VHIDGameControllerAxisY:  result = 1; break;
        case VHIDGameControllerAxisRX: result = 2; break;
        case VHIDGameControllerAxisRY: result = 3; break;
        default:
            break;
    }

    return result;
}

- (uint8_t*)mutableShiftState
{
    return ([self mutableStateBytes] + VHID_XBOX360_SHIFT_STATE_OFFSET);
}

- (uint16_t*)mutableStickState
{
    return ((uint16_t*)([self mutableStateBytes] + VHID_XBOX360_AXIS_STATE_OFFSET));
}

- (uint8_t*)mutableButtonState
{
    return ([self mutableStateBytes] + VHID_XBOX360_BTN_STATE_OFFSET);
}

- (CGFloat)shiftValue:(VHIDGameControllerAxis)axis
{
    NSUInteger  index = [self shiftIndex:axis];
    uint8_t    *state = [self mutableShiftState];

    return [VHIDXBox360Controller xbox360_UInt8ToFloat:state[index]]; 
}

- (void)setShift:(VHIDGameControllerAxis)axis value:(CGFloat)value
{
    if(fabs([self shiftValue:axis] - value) <= VHID_XBOX360_AXIS_VALUE_EPSILON)
        return;

    NSUInteger  index = [self shiftIndex:axis];
    uint8_t    *state = [self mutableShiftState];

    state[index] = [VHIDXBox360Controller xbox360_FloatToUInt8:value];
    [self notifyAboutStateChanged];
}

- (CGFloat)stickValue:(VHIDGameControllerAxis)axis
{
    NSUInteger index = [self stickIndex:axis];
    uint16_t  *state = [self mutableStickState];

    return [VHIDGameController UInt16ToFloat:OSSwapLittleToHostConstInt16(state[index])];
}

- (void)setStick:(VHIDGameControllerAxis)axis value:(CGFloat)value
{
    if(fabs([self stickValue:axis] - value) <= VHID_XBOX360_AXIS_VALUE_EPSILON)
        return;

    NSUInteger  index = [self stickIndex:axis];
    uint16_t   *state = [self mutableStickState];

    state[index] = OSSwapHostToLittleConstInt16([VHIDGameController FloatToUInt16:value]);
    [self notifyAboutStateChanged];
}

- (CGFloat)axisValue:(VHIDGameControllerAxis)axis
{
    if([self isShift:axis])
        return [self shiftValue:axis];

    return [self stickValue:axis];
}

- (void)setAxis:(VHIDGameControllerAxis)axis value:(CGFloat)value
{
    if([self isShift:axis])
        [self setShift:axis value:value];
    else
        [self setStick:axis value:value];
}

- (BOOL)isButtonPressed:(NSUInteger)button
{
    if(button >= [self buttonCount])
        return NO;

    if(button > VHIDXbox360ButtonTypeLogo)
        button++;

    NSUInteger   buttonByte = button / 8;
    NSUInteger   buttonBit  = button % 8;
    uint8_t     *state      = [self mutableButtonState];

    return ((state[buttonByte] & buttonMasks[buttonBit]) != 0);
}

- (void)setButton:(NSUInteger)button pressed:(BOOL)pressed
{
    if(button >= [self buttonCount] || [self isButtonPressed:button] == pressed)
        return;

    if(button > VHIDXbox360ButtonTypeLogo)
        button++;

    NSUInteger   buttonByte = button / 8;
    NSUInteger   buttonBit  = button % 8;
    uint8_t     *state      = [self mutableButtonState];

    if(pressed)
        state[buttonByte] |= buttonMasks[buttonBit];
    else
        state[buttonByte] &= ~(buttonMasks[buttonBit]);

    [self notifyAboutStateChanged];
}

- (void)resetState
{
    uint8_t *state = [self mutableStateBytes];

    [super resetState];
    state[1] = VHID_XBOX360_STATE_SIZE;
}

@end
