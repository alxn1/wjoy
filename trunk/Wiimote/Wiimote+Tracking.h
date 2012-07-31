//
//  Wiimote+Tracking.h
//  Wiimote
//
//  Created by alxn1 on 30.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "Wiimote.h"

@interface Wiimote (Tracking)

+ (NSArray*)connectedWiimotes;
+ (void)wiimoteConnected:(Wiimote*)wiimote;
+ (void)wiimoteDisconnected:(Wiimote*)wiimote;

@end
