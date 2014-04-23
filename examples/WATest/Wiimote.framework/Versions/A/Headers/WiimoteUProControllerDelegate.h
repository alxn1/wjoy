//
//  WiimoteUProControllerDelegate.h
//  Wiimote
//
//  Created by alxn1 on 16.06.13.
//
//

#import <Foundation/Foundation.h>

#define WiimoteUProControllerButtonCount			   14
#define WiimoteUProControllerStickCount					2

typedef enum
{
	WiimoteUProControllerButtonTypeUp				=  0,
    WiimoteUProControllerButtonTypeDown				=  1,
    WiimoteUProControllerButtonTypeLeft				=  2,
    WiimoteUProControllerButtonTypeRight			=  3,
    WiimoteUProControllerButtonTypeA				=  4,
    WiimoteUProControllerButtonTypeB				=  5,
    WiimoteUProControllerButtonTypeX				=  6,
    WiimoteUProControllerButtonTypeY				=  7,
    WiimoteUProControllerButtonTypeL				=  8,
    WiimoteUProControllerButtonTypeR				=  9,
    WiimoteUProControllerButtonTypeZL				= 10,
    WiimoteUProControllerButtonTypeZR				= 11,
	WiimoteUProControllerButtonTypeStickL			= 12,
	WiimoteUProControllerButtonTypeStickR			= 13
} WiimoteUProControllerButtonType;

typedef enum
{
    WiimoteUProControllerStickTypeLeft				=  0,
    WiimoteUProControllerStickTypeRight				=  1
} WiimoteUProControllerStickType;

FOUNDATION_EXPORT NSString *WiimoteUProControllerButtonPressedNotification;
FOUNDATION_EXPORT NSString *WiimoteUProControllerButtonReleasedNotification;
FOUNDATION_EXPORT NSString *WiimoteUProControllerStickPositionChangedNotification;

FOUNDATION_EXPORT NSString *WiimoteUProControllerStickKey;
FOUNDATION_EXPORT NSString *WiimoteUProControllerButtonKey;
FOUNDATION_EXPORT NSString *WiimoteUProControllerStickPositionKey;

@class Wiimote;
@class WiimoteExtension;

@protocol WiimoteUProControllerProtocol

- (NSPoint)stickPosition:(WiimoteUProControllerStickType)stick;
- (BOOL)isButtonPressed:(WiimoteUProControllerButtonType)button;

@end

typedef WiimoteExtension<WiimoteUProControllerProtocol> WiimoteUProControllerExtension;

@interface NSObject (WiimoteUProControllerDelegate)

- (void)      wiimote:(Wiimote*)wiimote
	   uProController:(WiimoteUProControllerExtension*)uPro
        buttonPressed:(WiimoteUProControllerButtonType)button;

- (void)      wiimote:(Wiimote*)wiimote
	   uProController:(WiimoteUProControllerExtension*)uPro
       buttonReleased:(WiimoteUProControllerButtonType)button;

- (void)      wiimote:(Wiimote*)wiimote
	   uProController:(WiimoteUProControllerExtension*)uPro
                stick:(WiimoteUProControllerStickType)stick
      positionChanged:(NSPoint)position;

@end
