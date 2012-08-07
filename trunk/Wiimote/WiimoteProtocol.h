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

#pragma push(pack)
#pragma pack(1)

#import "WiimoteProtocolBase.h"
#import "WiimoteProtocolCommand.h"
#import "WiimoteProtocolReport.h"
#import "WiimoteProtocolIR.h"
#import "WiimoteProtocolCalibration.h"
#import "WiimoteProtocolExtension.h"
#import "WiimoteProtocolNunchuck.h"
#import "WiimoteProtocolClassicController.h"
#import "WiimoteProtocolUtils.h"

#pragma pop(pack)
