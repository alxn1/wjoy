//
//  WiimoteProtocol.h
//  Wiimote
//
//  Created by alxn1 on 29.07.12.
//  Copyright (c) 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

// WARNING!!! Wiimote use big-endian data format!!!

// This file contain all hardware-specific type definitions for Wii Remote.

#pragma pack(push, 1)

#import <Wiimote/WiimoteProtocolCommand.h>
#import <Wiimote/WiimoteProtocolReport.h>
#import <Wiimote/WiimoteProtocolIR.h>
#import <Wiimote/WiimoteProtocolCalibration.h>
#import <Wiimote/WiimoteProtocolExtension.h>
#import <Wiimote/WiimoteProtocolNunchuck.h>
#import <Wiimote/WiimoteProtocolClassicController.h>
#import <Wiimote/WiimoteProtocolUProController.h>
#import <Wiimote/WiimoteProtocolBalanceBoard.h>
#import <Wiimote/WiimoteProtocolUDraw.h>
#import <Wiimote/WiimoteProtocolMotionPlus.h>
#import <Wiimote/WiimoteProtocolUtils.h>

#pragma pack(pop)
