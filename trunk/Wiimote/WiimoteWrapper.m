//
//  WiimoteWrapper.m
//  Wiimote
//
//  Created by alxn1 on 09.10.12.
//  Copyright 2012 alxn1. All rights reserved.
//

#import "WiimoteWrapper.h"

static NSString *wiimoteButtonName(WiimoteButtonType button)
{
    NSString *result = @"unknown";

    switch(button)
    {
        case WiimoteButtonTypeLeft:
            result = @"left";
            break;

        case WiimoteButtonTypeRight:
            result = @"right";
            break;

        case WiimoteButtonTypeUp:
            result = @"up";
            break;

        case WiimoteButtonTypeDown:
            result = @"down";
            break;

        case WiimoteButtonTypeA:
            result = @"A";
            break;

        case WiimoteButtonTypeB:
            result = @"B";
            break;

        case WiimoteButtonTypePlus:
            result = @"+";
            break;

        case WiimoteButtonTypeMinus:
            result = @"-";
            break;

        case WiimoteButtonTypeHome:
            result = @"home";
            break;

        case WiimoteButtonTypeOne:
            result = @"1";
            break;

       case  WiimoteButtonTypeTwo:
            result = @"2";
            break;
    }

    return result;
}

static NSString *nunchuckButtonName(WiimoteNunchuckButtonType button)
{
    NSString *result = @"unknown";

    switch(button)
    {
        case WiimoteNunchuckButtonTypeC:
            result = @"C";
            break;

        case WiimoteNunchuckButtonTypeZ:
            result = @"Z";
            break;
    }

    return result;
}

static NSString *classicButtonName(WiimoteClassicControllerButtonType button)
{
    NSString *result = @"unknown";

    switch(button)
    {
        case WiimoteClassicControllerButtonTypeA:
            result = @"A";
            break;

        case WiimoteClassicControllerButtonTypeB:
            result = @"B";
            break;

        case WiimoteClassicControllerButtonTypeMinus:
            result = @"minus";
            break;

        case WiimoteClassicControllerButtonTypeHome:
            result = @"home";
            break;

        case WiimoteClassicControllerButtonTypePlus:
            result = @"plus";
            break;

        case WiimoteClassicControllerButtonTypeX:
            result = @"X";
            break;

        case WiimoteClassicControllerButtonTypeY:
            result = @"Y";
            break;

        case WiimoteClassicControllerButtonTypeUp:
            result = @"Up";
            break;

        case WiimoteClassicControllerButtonTypeDown:
            result = @"Down";
            break;

        case WiimoteClassicControllerButtonTypeLeft:
            result = @"Left";
            break;

        case WiimoteClassicControllerButtonTypeRight:
            result = @"Right";
            break;

        case WiimoteClassicControllerButtonTypeL:
            result = @"L";
            break;

        case WiimoteClassicControllerButtonTypeR:
            result = @"R";
            break;

        case WiimoteClassicControllerButtonTypeZL:
            result = @"ZL";
            break;

        case WiimoteClassicControllerButtonTypeZR:
            result = @"ZR";
            break;
    }

    return result;
}

static NSString *classicStickName(WiimoteClassicControllerStickType stick)
{
    NSString *result = @"unknown";

    switch(stick)
    {
        case WiimoteClassicControllerStickTypeLeft:
            result = @"left";
            break;

        case WiimoteClassicControllerStickTypeRight:
            result = @"right";
            break;
    }

    return result;
}

static NSString *classicShiftName(WiimoteClassicControllerAnalogShiftType shift)
{
    NSString *result = @"unknown";

    switch(shift)
    {
        case WiimoteClassicControllerAnalogShiftTypeLeft:
            result = @"left";
            break;

        case WiimoteClassicControllerAnalogShiftTypeRight:
            result = @"right";
            break;
    }

    return result;
}

@implementation NSObject (WiimoteWrapperLog)

- (void)wiimoteWrapper:(WiimoteWrapper*)wrapper log:(NSString*)logLine
{
    NSLog(@"%@", logLine);
}

@end

@implementation WiimoteWrapper

- (void)log:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);

    NSString *line = [[NSString alloc] initWithFormat:format arguments:args];
    [[WiimoteWrapper log] wiimoteWrapper:self log:line];
    [line release];

    va_end(args);
}

- (id)initWithDevice:(Wiimote*)device
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Device = [device retain];
    [m_Device setDelegate:self];
    [m_Device setHighlightedLEDMask:WiimoteLEDFlagOne];
    [m_Device playConnectEffect];
	// [[m_Device accelerometer] setEnabled:YES];
    // [m_Device setIREnabled:YES];
    // [m_Device detectMotionPlus];

    [self log:@"Wrapper created"];
    [self log:@"%@", [m_Device modelName]];
	[self log:@"%@", [Wiimote connectedDevices]];

    return self;
}

- (void)dealloc
{
	[self log:@"%@", [Wiimote connectedDevices]];
    [self log:@"Wrapper deleted"];
    [m_Device setDelegate:nil];
    [m_Device release];
    [super dealloc];
}

static NSObject *sLog = nil;

+ (NSObject*)log
{
    if(sLog == nil)
        sLog = [[NSObject alloc] init];

    return sLog;
}

+ (void)setLog:(NSObject*)log
{
    if(sLog != log)
    {
        [sLog release];
        sLog = [log retain];
    }
}

+ (void)newDeviceConnected:(NSNotification*)notification
{
    [[WiimoteWrapper alloc] initWithDevice:[notification object]];
}

+ (void)discoveryNew
{
    static BOOL isInit = NO;

    if(!isInit)
    {
        [[Wiimote notificationCenter]
                                addObserver:self
                                   selector:@selector(newDeviceConnected:)
                                       name:WiimoteConnectedNotification
                                     object:nil];

        [[WiimoteWatchdog sharedWatchdog] setEnabled:YES];
        isInit = YES;
    }

    [Wiimote beginDiscovery];
}

- (void)wiimote:(Wiimote*)wiimote buttonPressed:(WiimoteButtonType)button
{
    [self log:@"buttonPressed: %@", wiimoteButtonName(button)];
}

- (void)wiimote:(Wiimote*)wiimote buttonReleased:(WiimoteButtonType)button
{
    [self log:@"buttonReleased: %@", wiimoteButtonName(button)];
}

- (void)wiimote:(Wiimote*)wiimote vibrationStateChanged:(BOOL)isVibrationEnabled
{
    [self log:@"vibrationStateChanged: %@", ((isVibrationEnabled)?(@"YES"):(@"NO"))];
}

- (void)wiimote:(Wiimote*)wiimote highlightedLEDMaskChanged:(NSUInteger)mask
{
    [self log:@"highlightedLEDMaskChanged: %lX", mask];
}

- (void)wiimote:(Wiimote*)wiimote batteryLevelUpdated:(double)batteryLevel isLow:(BOOL)isLow
{
    [self log:@"batteryLevelUpdated: %.0lf%%, isLow: %@", batteryLevel, ((isLow)?(@"YES"):(@"NO"))];
}

- (void)wiimote:(Wiimote*)wiimote extensionConnected:(WiimoteExtension*)extension
{
    [self log:@"Extension connected: %@", [extension name]];
	// [m_Device detectMotionPlus];
    // if([extension conformsToProtocol:@protocol(WiimoteNunchuckProtocol)])
    //    [[(WiimoteNunchuckExtension*)extension accelerometer] setEnabled:YES];
}

- (void)wiimote:(Wiimote*)wiimote extensionDisconnected:(WiimoteExtension*)extension
{
    [self log:@"Extension disconnected: %@", [extension name]];
	// [m_Device detectMotionPlus];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonPressed:(WiimoteNunchuckButtonType)button
{
    [self log:@"Nunchuck button pressed: %@", nunchuckButtonName(button)];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck buttonReleased:(WiimoteNunchuckButtonType)button
{
    [self log:@"Nunchuck button released: %@", nunchuckButtonName(button)];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck stickPositionChanged:(NSPoint)position
{
    [self log:@"Nunchuck position changed: %.02f %.02f", position.x, position.y];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerEnabledStateChanged:(BOOL)enabled
{
    [self log:@"Nunchuck accelerometer %@", ((enabled)?(@"enabled"):(@"disabled"))];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerChangedGravityX:(double)x y:(double)y z:(double)z
{
    [self log:@"Nunchuck accelerometer position (gravity) changed: %.02f %.02f %.02f", x, y, z];
}

- (void)wiimote:(Wiimote*)wiimote nunchuck:(WiimoteNunchuckExtension*)nunchuck accelerometerChangedPitch:(double)pitch roll:(double)roll
{
    [self log:@"Nunchuck accelerometer position (pitch-roll) changed: %.02f %.02f", pitch, roll];
}

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
        buttonPressed:(WiimoteClassicControllerButtonType)button
{
    [self log:@"Classic Controller button pressed: %@", classicButtonName(button)];
}

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
       buttonReleased:(WiimoteClassicControllerButtonType)button
{
    [self log:@"Classic Controller button released: %@", classicButtonName(button)];
}

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
                stick:(WiimoteClassicControllerStickType)stick
      positionChanged:(NSPoint)position
{
    [self log:@"Classic Controller stick (%@) position changed: %.02f %.02f", classicStickName(stick), position.x, position.y];
}

- (void)      wiimote:(Wiimote*)wiimote
    classicController:(WiimoteClassicControllerExtension*)classic
          analogShift:(WiimoteClassicControllerAnalogShiftType)shift
      positionChanged:(float)position
{
	[self log:@"Classic Controller analog shift (%@) position changed: %.02f", classicShiftName(shift), position];
}

- (void)wiimoteDisconnected:(Wiimote*)wiimote
{
    [self log:@"Disconnected"];
    [self autorelease];
}

- (void)wiimote:(Wiimote*)wiimote accelerometerEnabledStateChanged:(BOOL)enabled
{
    [self log:@"Accelerometer %@", ((enabled)?(@"enabled"):(@"disabled"))];
}

- (void)wiimote:(Wiimote*)wiimote accelerometerChangedGravityX:(double)x y:(double)y z:(double)z
{
    [self log:@"Accelerometer position (gravity) changed: %.02f %.02f %.02f", x, y, z];
}

- (void)wiimote:(Wiimote*)wiimote accelerometerChangedPitch:(double)pitch roll:(double)roll
{
    [self log:@"Accelerometer position (pitch-roll) changed: %.02f %.02f", pitch, roll];
}

- (void)wiimote:(Wiimote*)wiimote irEnabledStateChanged:(BOOL)enabled
{
    [self log:@"IR state: %@", ((enabled)?(@"enabled"):(@"disabled"))];
}

- (void)wiimote:(Wiimote*)wiimote irPointPositionChanged:(WiimoteIRPoint*)point
{
    if([point isOutOfView])
        [self log:@"IR point %li os out of view", [point index]];
    else
        [self log:@"IR point position (%li): %.0f %.0f", [point index], [point position].x, [point position].y];
}

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
	  subExtensionConnected:(WiimoteExtension*)extension
{
	[self log:@"Motion Plus sub extension connected: %@", [extension name]];
}

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
   subExtensionDisconnected:(WiimoteExtension*)extension
{
	[self log:@"Motion Plus sub extension disconnected: %@", [extension name]];
}

- (void)			wiimote:(Wiimote*)wiimote
				 motionPlus:(WiimoteMotionPlusExtension*)motionPlus
					 report:(const WiimoteMotionPlusReport*)report
{
	[self log:@"yaw: %u (%@)", report->yaw.speed, ((report->yaw.isSlowMode)?(@"slow"):(@"normal"))];
	[self log:@"roll: %u (%@)", report->roll.speed, ((report->roll.isSlowMode)?(@"slow"):(@"normal"))];
	[self log:@"pitch: %u (%@)", report->pitch.speed, ((report->pitch.isSlowMode)?(@"slow"):(@"normal"))];
}

@end
