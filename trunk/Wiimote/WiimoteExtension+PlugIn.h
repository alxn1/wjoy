//
//  WiimoteExtension+PlugIn.h
//  Wiimote
//
//  Created by alxn1 on 28.07.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteExtension.h"
#import "WiimoteIOManager.h"
#import "WiimoteEventDispatcher.h"

typedef enum
{
    WiimoteExtensionMeritClassSystemHigh    = 1000,
    WiimoteExtensionMeritClassUserHigh      = 10000,
    WiimoteExtensionMeritClassSystem        = 100000,
    WiimoteExtensionMeritClassUser          = 1000000,
    WiimoteExtensionMeritClassUnknown       = 10000000
} WiimoteExtensionMeritClass;

@interface WiimoteExtension (PlugIn)

+ (void)registerExtensionClass:(Class)cls;

+ (NSUInteger)merit;
+ (NSUInteger)minReportDataSize;

+ (void)initialize:(WiimoteIOManager*)ioManager;

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action;

- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher;

- (WiimoteEventDispatcher*)eventDispatcher;

- (void)calibrate:(WiimoteIOManager*)ioManager;
- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length;

@end

@interface WiimoteExtension (CalibrationUtils)

- (BOOL)beginReadCalibrationData:(WiimoteIOManager*)ioManager
                     memoryRange:(NSRange)memoryRange;

- (void)handleCalibrationData:(const uint8_t*)data length:(NSUInteger)length;

@end

@interface WiimoteExtension (PlugInUtils)

+ (NSUInteger)nextFreedomMeritInClass:(WiimoteExtensionMeritClass)meritClass;

+ (void)probeFinished:(BOOL)result
               target:(id)target
               action:(SEL)action;

@end

/*

WiimoteExtension class - it's base class for all Wii Remote extensions.
You can write you own subclass of WiimoteExtension for handling new type of
extension.

You need to reimplement some of methods of WiimoteExtension class:

// merit - it's some number, if number is smaller - you extension class probed
// in first time, if is bigger - in second. You can control extension probe sequence
// with this number. You need implement this method, default implementation return very big number,
// and you class newer be called, if you don't reimplement this.
// If you want implement extension, what already implemented (write own nunchuck plugin
// with cool interface), you can return merit number smaller, than WiimoteExtensionMeritClassSystem -
// all standart plugins return bigger number.
// For dynamic number generation, you can use nextFreedomMeritInClass: methods. And it's reccomended
// method for obtaining new, not busy merit number.

+ (NSUInteger)merit;

// minimum data size of hardware device report. It's only hint for plugin subsustem,
// and in handleReport: can be occured smapper data, but only in small situations.
// Implement this, if you handle some data in handleReport: method.

+ (NSUInteger)minReportDataSize;

// Called befor probe:, implement this, if you extension
// needed non-sandart initialize routine. Standart initialization
// performed in all cases before calling initialize:.
+ (void)initialize:(WiimoteIOManager*)ioManager;

// Probing method. It's called after initialize:, and after some extension
// connected to Wiimote. Wiimote known about all extension classes, and it
// call probe: method on all extensions in sequence, controlled by merit number.
// If some probe method return YES (internally, after probe, probe: method need to
// call probeFinished: method with probe result), probe sequence ended, and object
// of finded class created. Last class (with biggest merit) is UnknownExtension.

+ (void)probe:(WiimoteIOManager*)ioManager
       target:(id)target
       action:(SEL)action;

// Init routine, called on creating instance of class.
- (id)initWithOwner:(Wiimote*)owner
    eventDispatcher:(WiimoteEventDispatcher*)dispatcher;

- (WiimoteEventDispatcher*)eventDispatcher;

// Calibrate method called after creating instance of extension. You can use
// beginReadCalibrationData:(WiimoteIOManager*)ioManager memoryRange:(NSRange)memoryRange;
// method, if calibration data can be readed simply from some address space.
// beginReadCalibrationData:(WiimoteIOManager*)ioManager, on finish,
// call handleCalibrationData: data.
- (void)calibrate:(WiimoteIOManager*)ioManager;

// And this method called, if some data report received from extension device.
// Handle data here :)
- (void)handleReport:(const uint8_t*)extensionData length:(NSUInteger)length;

If you extension need to call some Wiimote delegate methods, or post notification,
you can add cathegory to WiimoteDelegate and WiimoteEventDispatcher, and call this
methods from extension plugin (eventDispatcher accessible all time, if plugin exist).
For more details, see WiimotePart class.

After creating extension plugin, you need registry newly created class. You can
do it with registerExtensionClass: method. You can do it in + (void)load; method:

@interface MyExtension : WiimoteExtension

@en

@implementation MyExtension

+ (void)load
{
    [WiimoteExtension registerExtensionClass:[MyExtension class]];
}

// you need to implement this method.
- (NSString*)name
{
    return @"MyExtension";
}

@end

*/
