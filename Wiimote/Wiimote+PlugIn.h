//
//  Wiimote+PlugIn.h
//  Wiimote
//
//  Created by alxn1 on 03.08.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote.h"
#import "WiimotePart.h"
#import "WiimoteGenericExtension.h"
#import "WiimoteAccelerometer+PlugIn.h"

@interface Wiimote (PlugIn)

+ (void)registerSupportedModelName:(NSString*)name;

- (void)deviceConfigurationChanged;

- (WiimotePart*)partWithClass:(Class)cls;

@end

/*

Methods, what can be accessed only from part or extension.

+ (void)registerSupportedModelName:(NSString*)name; - register bluetooth name of
wiimote device. I know, what balance board use non-standart name for self. You can
register it's name, if you need to handle it (you write balance board extension) :)

- (void)deviceConfigurationChanged; - you can call it, if some configuration changes,
and you need set new wiimote hardware reporting type. If you write part, and you change
result of - (NSSet*)allowedReportTypeSet; method, call this mehtod on owner of part.
Wiimote call this method from all parts immediately, select best reporting mode,
and send needed command to device. 

- (WiimotePart*)partWithClass:(Class)cls; - if you write new part class, register it,
and you need add cachegory to Wiimote class for accessing part methods,
you can add methods to Wiimote and access you part throught this method.

*/
