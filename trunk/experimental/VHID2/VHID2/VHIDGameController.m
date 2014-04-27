//
//  VHIDGameController.m
//  VHID2
//
//  Created by alxn1 on 21.03.14.
//  Copyright (c) 2014 alxn1. All rights reserved.
//

#import "VHIDGameController+Private.h"

#define VHID_BTN_DESCRIPTOR_MIN_SIZE    16
#define VHID_BTN_DESCRIPTOR_MAX_SIZE    22
#define VHID_AXIS_DESCRIPTOR_MIN_SIZE   14
#define VHID_MIN_AXIS                   VHIDGameControllerAxisX
#define VHID_MAX_AXIS                   VHIDGameControllerAxisRZ
#define VHID_AXIS_DESCRIPTOR_INDEX_BASE 0x30
#define VHID_DESCRIPTOR_MIN_SIZE        10
#define VHID_AXIS_VALUE_EPSILON         0.01

static const unsigned char buttonMasks[] =
{
    1, 2, 4, 8, 16, 32, 64, 128
};

@implementation VHIDGameController

+ (VHIDGameController*)gameControllerWithAxes:(VHIDGameControllerAxisSet)axes
                                  buttonCount:(NSUInteger)count
{
    return [[[VHIDGameController alloc] initWithAxes:axes buttonCount:count] autorelease];
}

+ (NSData*)buttonDescriptor:(NSUInteger)buttonCount
{
    if(buttonCount == 0)
        return nil;

    NSUInteger     paddingBits  = (8 - buttonCount % 8) % 8;
    NSMutableData *result       = [NSMutableData dataWithLength:(paddingBits != 0)?
                                                            (VHID_BTN_DESCRIPTOR_MAX_SIZE):
                                                            (VHID_BTN_DESCRIPTOR_MIN_SIZE)];

    unsigned char *data         = [result mutableBytes];

    *data = 0x05; data++; *data = 0x09;         data++;     //  USAGE_PAGE (Button)
    *data = 0x19; data++; *data = 0x01;         data++;     //  USAGE_MINIMUM (Button 1)
    *data = 0x29; data++; *data = buttonCount;  data++;     //  USAGE_MAXIMUM (Button buttonCount)
    *data = 0x15; data++; *data = 0x00;         data++;     //  LOGICAL_MINIMUM (0)
    *data = 0x25; data++; *data = 0x01;         data++;     //  LOGICAL_MAXIMUM (1)
    *data = 0x95; data++; *data = buttonCount;  data++;     //  REPORT_COUNT (buttonCount)
    *data = 0x75; data++; *data = 0x01;         data++;     //  REPORT_SIZE (1)
    *data = 0x81; data++; *data = 0x02;         data++;     //  INPUT (Data, Var, Abs)

    if(paddingBits != 0)
    {
        *data = 0x95; data++; *data = 0x1;          data++; //  REPORT_COUNT (1)
        *data = 0x75; data++; *data = paddingBits;  data++; //  REPORT_SIZE (paddingBits)
        *data = 0x81; data++; *data = 0x03;         data++; //  INPUT (Cnst, Var, Abs)
    }

    return result;
}

+ (NSUInteger)axisCount:(VHIDGameControllerAxisSet)axes
{
    NSUInteger result = 0;

    for(NSUInteger axis = VHID_MIN_AXIS; axis <= VHID_MAX_AXIS; axis <<= 1)
    {
        if((axes & axis) != 0)
            result++;
    }

    return result;
}

+ (NSUInteger)axisDescriptorIndex:(VHIDGameControllerAxis)axis
{
    NSUInteger result = VHID_AXIS_DESCRIPTOR_INDEX_BASE;

    switch(axis)
    {
        case VHIDGameControllerAxisX:  result += 0; break;
        case VHIDGameControllerAxisY:  result += 1; break;
        case VHIDGameControllerAxisZ:  result += 2; break;
        case VHIDGameControllerAxisRX: result += 3; break;
        case VHIDGameControllerAxisRY: result += 4; break;
        case VHIDGameControllerAxisRZ: result += 5; break;
    }

    return result;
}

+ (NSData*)axisDescriptor:(VHIDGameControllerAxisSet)axes
{
    if(axes == 0)
        return nil;

    NSUInteger     axisCount    = [self axisCount:axes];
    NSUInteger     length       = VHID_AXIS_DESCRIPTOR_MIN_SIZE + axisCount * 2;
    NSMutableData *result       = [NSMutableData dataWithLength:length];

    unsigned char *data         = [result mutableBytes];

    *data = 0x05; data++; *data = 0x01;                       data++; //  USAGE_PAGE (Generic Desktop)

    for(NSUInteger axis = VHID_MIN_AXIS; axis <= VHID_MAX_AXIS; axis <<= 1)
    {
        if((axes & axis) != 0)
        {
            NSUInteger index = [self axisDescriptorIndex:(VHIDGameControllerAxis)axis];

            *data = 0x09; data++; *data = index; data++;              //  USAGE (X + index)
        }
    }

    *data = 0x81; data++; *data = 0x02;                       data++; //  INPUT (Data,Var,Abs)
    *data = 0x75; data++; *data = 0x10;                       data++; //  REPORT_SIZE (16)
    *data = 0x95; data++; *data = axisCount;                  data++; //  REPORT_COUNT (axisCount)
    *data = 0x16; data++; *data = 0x00; data++; *data = 0x80; data++; //  LOGICAL_MINIMUM (-32768)
    *data = 0x26; data++; *data = 0xff; data++; *data = 0x7f; data++; //  LOGICAL_MAXIMUM (32767)

    return result;
}

+ (NSData*)descriptorWithAxes:(VHIDGameControllerAxisSet)axes
                  buttonCount:(NSUInteger)buttonCount
{
    NSData          *buttonDescriptor = [self buttonDescriptor:buttonCount];
    NSData          *axisDescriptor   = [self axisDescriptor:axes];
    NSUInteger       length           = VHID_DESCRIPTOR_MIN_SIZE + [buttonDescriptor length] + [axisDescriptor length];
    NSMutableData   *result           = [NSMutableData dataWithLength:length];

    unsigned char   *data             = [result mutableBytes];

    *data = 0x05; data++; *data = 0x01; data++;             // USAGE_PAGE (Generic Desktop)
    *data = 0x09; data++; *data = 0x05; data++;             // USAGE (Game Pad)
    *data = 0xA1; data++; *data = 0x01; data++;             // COLLECTION (Application)
    *data = 0xA1; data++; *data = 0x00; data++;             // COLLECTION (Physical)

    if(buttonDescriptor != nil)
    {
        memcpy(data, [buttonDescriptor bytes], [buttonDescriptor length]);
        data += [buttonDescriptor length];
    }

    if(axisDescriptor != nil)
    {
        memcpy(data, [axisDescriptor bytes], [axisDescriptor length]);
        data += [axisDescriptor length];
    }

    *data = 0xC0; data++;                                   // END_COLLECTION
    *data = 0xC0; data++;                                   // END_COLLECTION

    return result;
}

+ (NSUInteger)buttonStateSize:(NSUInteger)buttonCount
{
    NSUInteger     paddingBits  = (8 - buttonCount % 8) % 8;
    NSUInteger     result       = (buttonCount + paddingBits) / 8;

    return result;
}

+ (NSUInteger)axesStateSize:(VHIDGameControllerAxisSet)axes
{
    return ([self axisCount:axes] * sizeof(uint16_t));
}

+ (NSUInteger)stateSizeWithAxes:(VHIDGameControllerAxisSet)axes
                    buttonCount:(NSUInteger)buttonCount
{
    return ([self buttonStateSize:buttonCount] + [self axesStateSize:axes]);
}

- (id)initWithAxes:(VHIDGameControllerAxisSet)axes
       buttonCount:(NSUInteger)buttonCount
{
    NSData      *descriptor = [VHIDGameController descriptorWithAxes:axes buttonCount:buttonCount];
    NSUInteger   stateSize  = [VHIDGameController stateSizeWithAxes:axes buttonCount:buttonCount];

    return [self initWithDescriptor:descriptor
                          stateSize:stateSize
                               axes:axes
                        buttonCount:buttonCount];
}

- (VHIDGameControllerAxisSet)axes
{
    return m_Axes;
}

- (NSUInteger)buttonCount
{
    return m_ButtonCount;
}

- (uint16_t*)mutableAxisState
{
    unsigned char *result = [self mutableStateBytes];

    result += [VHIDGameController buttonStateSize:m_ButtonCount];
    return ((uint16_t*)result);
}

- (uint8_t*)mutableButtonState
{
    return [self mutableStateBytes];
}

- (NSUInteger)axisIndex:(VHIDGameControllerAxis)value
{
    NSUInteger result = 0;
    NSUInteger index  = 0;

    for(NSUInteger axis = VHID_MIN_AXIS; axis <= VHID_MAX_AXIS; axis <<= 1)
    {
        if(value == axis)
        {
            result = index;
            break;
        }

        if((m_Axes & axis) != 0)
            index++;
    }

    return result;
}

- (CGFloat)axisValue:(VHIDGameControllerAxis)axis
{
    if((m_Axes & axis) == 0)
        return 0.0;

    NSUInteger   index = [self axisIndex:axis];
    uint16_t    *state = [self mutableAxisState];

    return [VHIDGameController UInt16ToFloat:OSSwapLittleToHostConstInt16(state[index])];
}

- (void)setAxis:(VHIDGameControllerAxis)axis value:(CGFloat)value
{
    if((m_Axes & axis) == 0 || fabs([self axisValue:axis] - value) <= VHID_AXIS_VALUE_EPSILON)
        return;

    NSUInteger   index = [self axisIndex:axis];
    uint16_t    *state = [self mutableAxisState];

    state[index] = OSSwapHostToLittleConstInt16([VHIDGameController FloatToUInt16:value]);
    [self notifyAboutStateChanged];
}

- (BOOL)isButtonPressed:(NSUInteger)button
{
    if(button >= m_ButtonCount)
        return NO;

    NSUInteger   buttonByte = button / 8;
    NSUInteger   buttonBit  = button % 8;
    uint8_t     *state      = [self mutableButtonState];

    return ((state[buttonByte] & buttonMasks[buttonBit]) != 0);
}

- (void)setButton:(NSUInteger)button pressed:(BOOL)pressed
{
    if(button >= m_ButtonCount || [self isButtonPressed:button] == pressed)
        return;

    NSUInteger   buttonByte = button / 8;
    NSUInteger   buttonBit  = button % 8;
    uint8_t     *state      = [self mutableButtonState];

    if(pressed)
        state[buttonByte] |= buttonMasks[buttonBit];
    else
        state[buttonByte] &= ~(buttonMasks[buttonBit]);

    [self notifyAboutStateChanged];
}

@end
