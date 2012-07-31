//
//  WiimoteClassicControllerDelegate.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Wiimote;
@class WiimoteExtension;

@protocol WiimoteClassicControllerProtocol

@end

typedef WiimoteExtension<WiimoteClassicControllerProtocol> WiimoteClassicControllerExtension;

@interface NSObject (WiimoteClassicControllerDelegate)

@end
