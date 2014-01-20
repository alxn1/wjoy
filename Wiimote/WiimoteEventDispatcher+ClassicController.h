//
//  WiimoteEventDispatcher+ClassicController.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteEventDispatcher.h"
#import "WiimoteClassicControllerDelegate.h"

@interface WiimoteEventDispatcher (ClassicController)

- (void)postClassicController:(WiimoteClassicControllerExtension*)classic
                buttonPressed:(WiimoteClassicControllerButtonType)button;

- (void)postClassicController:(WiimoteClassicControllerExtension*)classic
               buttonReleased:(WiimoteClassicControllerButtonType)button;

- (void)postClassicController:(WiimoteClassicControllerExtension*)classic
                        stick:(WiimoteClassicControllerStickType)stick
              positionChanged:(NSPoint)position;

- (void)postClassicController:(WiimoteClassicControllerExtension*)classic
                  analogShift:(WiimoteClassicControllerAnalogShiftType)shift
              positionChanged:(CGFloat)position;

@end
