//
//  WiimoteDevice+Hardware.m
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice+Hardware.h"
#import "WiimoteDevice+Notification.h"
#import "WiimoteDevice+ReportHandling.h"

@interface WiimoteDevice (IOBluetoothL2CAPChannelDelegate)

- (void)l2capChannelData:(IOBluetoothL2CAPChannel*)l2capChannel
                    data:(void*)dataPointer
                  length:(size_t)dataLength;

- (void)l2capChannelClosed:(IOBluetoothL2CAPChannel*)l2capChannel;

@end

@implementation WiimoteDevice (Hardware)

- (IOBluetoothL2CAPChannel*)openChannel:(BluetoothL2CAPPSM)channelID
{
    IOBluetoothL2CAPChannel *result = nil;

	if([m_Device openL2CAPChannelSync:&result
                              withPSM:channelID
                             delegate:self] != kIOReturnSuccess)
    {
		return nil;
    }

	return result;
}

- (void)initialize
{
    [self setVibrationEnabled:YES];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.35]];
    [self setVibrationEnabled:NO];
    [self updateState];

    if(![self enableButtonReport])
        [self disconnect];
}

- (BOOL)postCommand:(WiimoteDeviceCommandType)command
               data:(const void*)data
             length:(NSUInteger)length
{
    if(m_DataChannel == nil)
        return NO;

    unsigned char buffer[length + 2];

    buffer[0] = WiimoteDevicePacketTypeCommand;
    buffer[1] = command;
    memcpy(buffer + 2, data, length);

    return ([m_DataChannel writeSync:buffer length:length + 2] == kIOReturnSuccess);
}

- (BOOL)updateLEDStates
{
    unsigned char data = 0;

    if(m_IsVibrationEnabled)
        data |= WiimoteDeviceCommandFlagVibraEnabled;

    if((m_HighlightedLEDMask & WiimoteLEDOne) != 0)
        data |= WiimoteDeviceCommandFlagLEDOneEnabled;

    if((m_HighlightedLEDMask & WiimoteLEDTwo) != 0)
        data |= WiimoteDeviceCommandFlagLEDTwoEnabled;

    if((m_HighlightedLEDMask & WiimoteLEDThree) != 0)
        data |= WiimoteDeviceCommandFlagLEDThreeEnabled;

    if((m_HighlightedLEDMask & WiimoteLEDFour) != 0)
        data |= WiimoteDeviceCommandFlagLEDFourEnabled;

    return [self postCommand:WiimoteDeviceCommandTypeSetLEDStates
                        data:&data
                      length:sizeof(data)];
}

- (BOOL)beginUpdateState
{
    unsigned char data = 0;

    if(m_IsVibrationEnabled)
        data |= WiimoteDeviceCommandFlagVibraEnabled;

    return [self postCommand:WiimoteDeviceCommandTypeGetStatus
                        data:&data
                      length:sizeof(data)];
}

- (BOOL)writeData:(const unsigned char*)data
		   length:(NSUInteger)length
		  address:(NSUInteger)address
{
	if(length > WiimoteDeviceWriteMemotyDataSize)
		return NO;

	uint32_t addr	= OSSwapHostToBigInt32(address);
	uint8_t  len	= length;

	unsigned char buffer[WiimoteDeviceWriteMemotyDataSize + 5];

	memcpy(buffer, &addr, sizeof(addr));
	memcpy(buffer + sizeof(addr), &len, sizeof(len));
	memset(buffer + sizeof(addr) + sizeof(len), 0, WiimoteDeviceWriteMemotyDataSize);
	memcpy(buffer + sizeof(addr) + sizeof(len), data, length);

	if(m_IsVibrationEnabled)
        buffer[0] |= WiimoteDeviceCommandFlagVibraEnabled;

	return [self postCommand:WiimoteDeviceCommandTypeWriteMemory
						data:buffer
					  length:sizeof(buffer)];
}

- (BOOL)beginReadFromMemory:(NSRange)range
{
	uint32_t address	= range.location;
	uint16_t length		= range.length;

	OSSwapHostToBigInt32(address);
	OSSwapHostToBigInt16(length);

	unsigned char data[6];

	memcpy(data, &address, sizeof(address));
	memcpy(data + sizeof(address), &length, sizeof(length));

	if(m_IsVibrationEnabled)
        data[0] |= WiimoteDeviceCommandFlagVibraEnabled;

	return [self postCommand:WiimoteDeviceCommandTypeReadMemory
						data:data
					  length:sizeof(data)];
}

- (BOOL)enableButtonReport
{
    unsigned char data[2];

    data[0] = 0;
    data[1] = WiimoteDeviceReportTypeCoreButtons;

	if(m_IsExtensionInitialized)
		data[1] = WiimoteDeviceReportTypeCoreButtonsAndExtStat;

    if(m_IsVibrationEnabled)
        data[0] |= WiimoteDeviceCommandFlagVibraEnabled;

    return [self postCommand:WiimoteDeviceCommandTypeEnableButtonReport
                        data:data
                      length:sizeof(data)];
}

@end

@implementation WiimoteDevice (IOBluetoothL2CAPChannelDelegate)

- (void)l2capChannelData:(IOBluetoothL2CAPChannel*)l2capChannel
                    data:(void*)dataPointer
                  length:(size_t)dataLength
{
    if(![self handleReport:(unsigned char*)dataPointer length:dataLength])
        [self disconnect];
}

- (void)l2capChannelClosed:(IOBluetoothL2CAPChannel*)l2capChannel
{
    [self disconnect];
}

@end
