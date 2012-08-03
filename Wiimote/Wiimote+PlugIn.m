//
//  Wiimote+PlugIn.m
//  Wiimote
//
//  Created by alxn1 on 03.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote+PlugIn.h"
#import "WiimoteInquiry.h"
#import "WiimotePartSet.h"
#import "WiimoteDevice.h"

@implementation Wiimote (PlugIn)

+ (void)registerSupportedModelName:(NSString*)name
{
    [WiimoteInquiry registerSupportedModelName:name];
}

- (void)deviceConfigurationChanged
{
	[m_Device requestReportType:[m_PartSet bestReportType]];
}

- (WiimotePart*)partWithClass:(Class)cls
{
    return [m_PartSet partWithClass:cls];
}

@end
