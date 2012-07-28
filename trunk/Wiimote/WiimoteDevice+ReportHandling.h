//
//  WiimoteDevice+ReportHandling.h
//  Wiimote
//
//  Created by alxn1 on 27.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteDevice.h"

@interface WiimoteDevice (ReportHandling)

- (BOOL)handleReport:(const unsigned char*)data length:(NSUInteger)length;
- (BOOL)handleCoreButtonReport:(const unsigned char*)data length:(NSUInteger)length;
- (BOOL)handleCoreButtonAndExtStat:(const unsigned char*)data length:(NSUInteger)length;
- (BOOL)handleReadMemoryReport:(const unsigned char*)data length:(NSUInteger)length;
- (BOOL)handleAcknowledgeReport:(const unsigned char*)data length:(NSUInteger)length;
- (BOOL)handleStatusReport:(const unsigned char*)data length:(NSUInteger)length;

@end
