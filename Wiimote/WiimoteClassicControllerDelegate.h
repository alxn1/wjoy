//
//  WiimoteClassicControllerDelegate.h
//  Wiimote
//
//  Created by alxn1 on 31.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WiimoteClassicControllerButtonCount           15
#define WiimoteClassicControllerStickCount             2
#define WiimoteClassicControllerAnalogShiftCount       2

typedef enum
{
    WiimoteClassicControllerButtonTypeA             =  0,
    WiimoteClassicControllerButtonTypeB             =  1,
    WiimoteClassicControllerButtonTypeMinus         =  2,
    WiimoteClassicControllerButtonTypeHome          =  3,
    WiimoteClassicControllerButtonTypePlus          =  4,
    WiimoteClassicControllerButtonTypeX             =  5,
    WiimoteClassicControllerButtonTypeY             =  6,
    WiimoteClassicControllerButtonTypeUp            =  7,
    WiimoteClassicControllerButtonTypeDown          =  8,
    WiimoteClassicControllerButtonTypeLeft          =  9,
    WiimoteClassicControllerButtonTypeRight         = 10,
    WiimoteClassicControllerButtonTypeL             = 11,
    WiimoteClassicControllerButtonTypeR             = 12,
    WiimoteClassicControllerButtonTypeZL            = 13,
    WiimoteClassicControllerButtonTypeZR            = 14
} WiimoteClassicControllerButtonType;

typedef enum
{
    WiimoteClassicControllerStickTypeLeft           =  0,
    WiimoteClassicControllerStickTypeRight          =  1
} WiimoteClassicControllerStickType;

typedef enum
{
    WiimoteClassicControllerAnalogShiftTypeLeft     =  0,
    WiimoteClassicControllerAnalogShiftTypeRight    =  1
} WiimoteClassicControllerAnalogShiftType;

FOUNDATION_EXPORT NSString *WiimoteClassicControllerButtonPressedNotification;
FOUNDATION_EXPORT NSString *WiimoteClassicControllerButtonReleasedNotification;
FOUNDATION_EXPORT NSString *WiimoteClassicControllerStickPositionChangedNotification;
FOUNDATION_EXPORT NSString *WiimoteClassicControllerAnalogShiftPositionChangedNotification;

FOUNDATION_EXPORT NSString *WiimoteClassicControllerStickKey;
FOUNDATION_EXPORT NSString *WiimoteClassicControllerButtonKey;
FOUNDATION_EXPORT NSString *WiimoteClassicControllerAnalogShiftKey;
FOUNDATION_EXPORT NSString *WiimoteClassicControllerStickPositionKey;
FOUNDATION_EXPORT NSString *WiimoteClassicControllerAnalogShiftPositionKey;

@class Wiimote;
@class WiimoteExtension;

@protocol WiimoteClassicControllerProtocol

- (NSPoint)stickPosition:(WiimoteClassicControllerStickType)stick;
- (BOOL)isButtonPressed:(WiimoteClassicControllerButtonType)button;
- (CGFloat)analogShiftPosition:(WiimoteClassicControllerAnalogShiftType)shift;

@end

typedef WiimoteExtension<WiimoteClassicControllerProtocol> WiimoteClassicControllerExtension;

@interface NSObject (WiimoteClassicControllerDelegate)

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
        buttonPressed:(WiimoteClassicControllerButtonType)button;

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
       buttonReleased:(WiimoteClassicControllerButtonType)button;

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
                stick:(WiimoteClassicControllerStickType)stick
      positionChanged:(NSPoint)position;

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
          analogShift:(WiimoteClassicControllerAnalogShiftType)shift
      positionChanged:(CGFloat)position;

@end
