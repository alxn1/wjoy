//
//  WiimoteC.c
//  Wiimote
//
//  Created by alxn1 on 26.03.14.
//
//

#import "WiimoteC.h"

#import "WiimoteLog.h"
#import "Wiimote.h"

NSString *WiimoteIDKey = @"WiimoteIDKey";

@interface WiimoteThread : NSObject
{
    @private
        NSThread *m_Thread;
}

+ (WiimoteThread*)thread;

- (void)invoke:(void (^)(void))block;

- (void)shutdown;

@end

@implementation WiimoteThread

+ (WiimoteThread*)thread
{
    static WiimoteThread *result = nil;

    if(result == nil)
        result = [[WiimoteThread alloc] init];

    return result;
}

- (id)init
{
    self = [super init];
    if(self == nil)
        return nil;

    m_Thread = [[NSThread alloc]
                            initWithTarget:self
                                  selector:@selector(thread)
                                    object:nil];

    [m_Thread start];

    return self;
}

- (void)dealloc
{
    [self shutdown];
    [super dealloc];
}

- (void)thread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [[WiimoteWatchdog sharedWatchdog] setEnabled:YES];
    [[NSRunLoop currentRunLoop] run];
    [pool release];
}

- (void)runBlock:(void (^)(void))block
{
    block();
}

- (void)invoke:(void (^)(void))block
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    [self performSelector:@selector(runBlock:)
                 onThread:m_Thread
               withObject:block
            waitUntilDone:YES
                    modes:[NSArray arrayWithObject:NSRunLoopCommonModes]];

    [pool release];
}

- (void)shutdown
{
    if(m_Thread == nil)
        return;

    [self invoke:^{ CFRunLoopStop([[NSRunLoop currentRunLoop] getCFRunLoop]); }];
    [m_Thread release];
    m_Thread = nil;
}

@end

//------------------------------------------------------------------------------
// utilities
//------------------------------------------------------------------------------

static Wiimote *wiimote_at_index(int index)
{
    Wiimote *result = nil;
    NSArray *all    = [Wiimote connectedDevices];

    if(index >= 0 && index < [all count])
        result = [all objectAtIndex:index];

    return result;
}

static WiimoteNunchuckExtension *nunchuck_at_index(int index)
{
    WiimoteExtension *e = [wiimote_at_index(index) connectedExtension];

    if([[e name] isEqualToString:@"Nunchuck"])
        return (WiimoteNunchuckExtension*)e;

    return nil;
}

static WiimoteClassicControllerExtension *ccontroller_at_index(int index)
{
    WiimoteExtension *e = [wiimote_at_index(index) connectedExtension];

    if([[e name] isEqualToString:@"Classic Controller"])
        return (WiimoteClassicControllerExtension*)e;

    return nil;
}

static WiimoteUProControllerExtension *upro_at_index(int index)
{
    WiimoteExtension *e = [wiimote_at_index(index) connectedExtension];

    if([[e name] isEqualToString:@"Wii U Pro Controller"])
        return (WiimoteUProControllerExtension*)e;

    return nil;
}

static WiimoteBalanceBoardExtension *bboard_at_index(int index)
{
    WiimoteExtension *e = [wiimote_at_index(index) connectedExtension];

    if([[e name] isEqualToString:@"Balance Board"])
        return (WiimoteBalanceBoardExtension*)e;

    return nil;
}

static WiimoteUDrawExtension *udraw_at_index(int index)
{
    WiimoteExtension *e = [wiimote_at_index(index) connectedExtension];

    if([[e name] isEqualToString:@"uDraw"])
        return (WiimoteUDrawExtension*)e;

    return nil;
}

static int wiimote_get_id(Wiimote *wiimote)
{
    return [[[wiimote userInfo] objectForKey:WiimoteIDKey] intValue];
}

static void wiimote_set_id(Wiimote *wiimote, int wid)
{
    [wiimote setUserInfo:
                [NSMutableDictionary
                            dictionaryWithObject:[NSNumber numberWithInt:wid]
                                          forKey:WiimoteIDKey]];
}

//------------------------------------------------------------------------------
// main API
//------------------------------------------------------------------------------

int wmc_initialize(void)
{
    [WiimoteThread thread];
    return 0;
}

int wmc_shutdown(void)
{
    [[WiimoteThread thread] invoke:^
    {
        NSArray     *connectedDevices   = [[[Wiimote connectedDevices] copy] autorelease];
        NSUInteger   count              = [connectedDevices count];

        for(NSUInteger i = 0; i < count; i++)
            [[connectedDevices objectAtIndex:i] disconnect];
    }];

    [[WiimoteThread thread] shutdown];
    return 0;
}

int wmc_get_log_level(void)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[WiimoteLog sharedLog] level];
    }];

    return result;
}

int wmc_set_log_level(int level)
{
    __block int result = YES;

    [[WiimoteThread thread] invoke:^
    {
        [[WiimoteLog sharedLog] setLevel:(WiimoteLogLevel)level];
    }];

    return result;
}

//------------------------------------------------------------------------------
// discovery API
//------------------------------------------------------------------------------

int wmc_is_bluetooth_enabled(void)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [Wiimote isBluetoothEnabled];
    }];

    return result;
}

int wmc_is_discovering(void)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [Wiimote isDiscovering];
    }];

    return result;
}

int wmc_begin_discovery(void)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [Wiimote beginDiscovery];
    }];

    return result;
}

int wmc_is_one_button_click_connection_enabled(void)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [Wiimote isUseOneButtonClickConnection];
    }];

    return result;
}

int wmc_set_one_button_click_connection_enabled(int enabled)
{
    [[WiimoteThread thread] invoke:^
    {
        [Wiimote setUseOneButtonClickConnection:enabled];
    }];

    return YES;
}

//------------------------------------------------------------------------------
// wiimote API
//------------------------------------------------------------------------------

int wmc_get_count_connected(void)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = (int)[[Wiimote connectedDevices] count];
    }];

    return result;
}

int wmc_disconnect(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        Wiimote *w = wiimote_at_index(index);

        if(w != nil)
        {
            [w disconnect];
            result = YES;
        }
    }];

    return result;
}

int wmc_w_get_id(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = wiimote_get_id(wiimote_at_index(index));
    }];

    return result;
}

int wmc_w_set_id(int index, int wid)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        Wiimote *w = wiimote_at_index(index);

        if(w != nil)
        {
            wiimote_set_id(w, wid);
            result = YES;
        }
    }];

    return result;
}

int wmc_w_index_with_id(int wid)
{
    __block int result = -1;

    [[WiimoteThread thread] invoke:^
    {
        NSArray     *all    = [Wiimote connectedDevices];
        NSUInteger   count  = [all count];

        for(NSUInteger i = 0; i < count; i++)
        {
            if(wiimote_get_id([all objectAtIndex:i]) == wid)
            {
                result = (int)i;
                break;
            }
        }
    }];

    return result;
}

int wmc_w_play_connect_effect(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        Wiimote *w = wiimote_at_index(index);

        if(w != nil)
        {
            [w playConnectEffect];
            result = YES;
        }
    }];

    return result;
}

int wmc_w_get_led_mask(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = (int)[wiimote_at_index(index) highlightedLEDMask];
    }];

    return result;
}

int wmc_w_set_led_mask(int index, int mask)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        Wiimote *w = wiimote_at_index(index);

        if(w != nil)
        {
            [w setHighlightedLEDMask:mask];
            result = YES;
        }
    }];

    return result;
}

int wmc_w_is_vibration_enabled(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [wiimote_at_index(index) isVibrationEnabled];
    }];

    return result;
}

int wmc_w_set_vibration_enabled(int index, int enabled)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        Wiimote *w = wiimote_at_index(index);

        if(w != nil)
        {
            [w setVibrationEnabled:enabled];
            result = YES;
        }
    }];

    return result;
}

int wmc_w_is_button_pressed(int index, int button)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [wiimote_at_index(index) isButtonPressed:(WiimoteButtonType)button];
    }];

    return result;
}

int wmc_w_is_battery_low(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [wiimote_at_index(index) isBatteryLevelLow];
    }];

    return result;
}

float wmc_w_get_battery_level(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [wiimote_at_index(index) batteryLevel];
    }];

    return result;
}

int wmc_w_is_ir_enabled(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [wiimote_at_index(index) isIREnabled];
    }];

    return result;
}

int wmc_w_set_ir_enabled(int index, int enabled)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        Wiimote *w = wiimote_at_index(index);

        if(w != nil)
        {
            [w setIREnabled:enabled];
            result = YES;
        }
    }];

    return result;
}

int wmc_w_is_ir_point_out_of_view(int index, int point)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) irPoint:point] isOutOfView];
    }];

    return result;
}

float wmc_w_get_ir_point_x(int index, int point)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) irPoint:point] position].x;
    }];

    return result;
}

float wmc_w_get_ir_point_y(int index, int point)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) irPoint:point] position].y;
    }];

    return result;
}

int wmc_w_is_accelerometer_enabled(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) accelerometer] isEnabled];
    }];

    return result;
}

int wmc_w_set_accelerometer_enabled(int index, int enabled)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        Wiimote *w = wiimote_at_index(index);

        if(w != nil)
        {
            [[w accelerometer] setEnabled:enabled];
            result = YES;
        }
    }];

    return result;
}

float wmc_w_get_accelerometer_x(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) accelerometer] gravityX];
    }];

    return result;
}

float wmc_w_get_accelerometer_y(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) accelerometer] gravityY];
    }];

    return result;
}

float wmc_w_get_accelerometer_z(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) accelerometer] gravityZ];
    }];

    return result;
}

float wmc_w_get_accelerometer_pitch(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) accelerometer] pitch];
    }];

    return result;
}

float wmc_w_get_accelerometer_roll(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[wiimote_at_index(index) accelerometer] roll];
    }];

    return result;
}

//------------------------------------------------------------------------------
// nunchuck API
//------------------------------------------------------------------------------

int wmc_w_is_nunchuck_connected(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = (nunchuck_at_index(index) != nil);
    }];

    return result;
}

int wmc_w_is_nunchuck_button_pressed(int index, int button)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [nunchuck_at_index(index) isButtonPressed:(WiimoteNunchuckButtonType)button];
    }];

    return result;
}

float wmc_w_get_nunchuck_stick_x(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [nunchuck_at_index(index) stickPosition].x;
    }];

    return result;
}

float wmc_w_get_nunchuck_stick_y(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [nunchuck_at_index(index) stickPosition].y;
    }];

    return result;
}

int wmc_w_is_nunchuck_accelerometer_enabled(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[nunchuck_at_index(index) accelerometer] isEnabled];
    }];

    return result;
}

int wmc_w_set_nunchuck_accelerometer_enabled(int index, int enabled)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        WiimoteNunchuckExtension *n = nunchuck_at_index(index);

        if(n != nil)
        {
            [[n accelerometer] setEnabled:enabled];
            result = YES;
        }
    }];

    return result;
}

float wmc_w_get_nunchuck_accelerometer_x(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[nunchuck_at_index(index) accelerometer] gravityX];
    }];

    return result;
}

float wmc_w_get_nunchuck_accelerometer_y(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[nunchuck_at_index(index) accelerometer] gravityY];
    }];

    return result;
}

float wmc_w_get_nunchuck_accelerometer_z(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[nunchuck_at_index(index) accelerometer] gravityZ];
    }];

    return result;
}

float wmc_w_get_nunchuck_accelerometer_pitch(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[nunchuck_at_index(index) accelerometer] pitch];
    }];

    return result;
}

float wmc_w_get_nunchuck_accelerometer_roll(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [[nunchuck_at_index(index) accelerometer] roll];
    }];

    return result;
}

//------------------------------------------------------------------------------
// classic controller API
//------------------------------------------------------------------------------

int wmc_w_is_ccontroller_connected(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = (ccontroller_at_index(index) != nil);
    }];

    return result;
}

int wmc_w_is_ccontroller_button_pressed(int index, int button)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [ccontroller_at_index(index) isButtonPressed:(WiimoteClassicControllerButtonType)button];
    }];

    return result;
}

float wmc_w_get_ccontroller_stick_x(int index, int stick)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [ccontroller_at_index(index) stickPosition:(WiimoteClassicControllerStickType)stick].x;
    }];

    return result;
}

float wmc_w_get_ccontroller_stick_y(int index, int stick)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [ccontroller_at_index(index) stickPosition:(WiimoteClassicControllerStickType)stick].y;
    }];

    return result;
}

float wmc_w_get_ccontroller_shift(int index, int shift)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [ccontroller_at_index(index) analogShiftPosition:(WiimoteClassicControllerAnalogShiftType)shift];
    }];

    return result;
}

//------------------------------------------------------------------------------
// wii u pro controller API (yes, like extension)
//------------------------------------------------------------------------------

int wmc_w_is_upro_connected(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = (upro_at_index(index) != nil);
    }];

    return result;
}

int wmc_w_is_upro_button_pressed(int index, int button)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [upro_at_index(index) isButtonPressed:(WiimoteUProControllerButtonType)button];
    }];

    return result;
}

float wmc_w_get_upro_stick_x(int index, int stick)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [upro_at_index(index) stickPosition:(WiimoteUProControllerStickType)stick].x;
    }];

    return result;
}

float wmc_w_get_upro_stick_y(int index, int stick)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [upro_at_index(index) stickPosition:(WiimoteUProControllerStickType)stick].y;
    }];

    return result;
}

//------------------------------------------------------------------------------
// balance boars API (yes, like extension)
//------------------------------------------------------------------------------

int wmc_w_is_bboard_connected(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = (bboard_at_index(index) != nil);
    }];

    return result;
}

float wmc_w_get_bboard_press(int index, int point)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        WiimoteBalanceBoardExtension *bboard = bboard_at_index(index);

        switch(point) {
            case wmc_bboard_point_left_top:     result = [bboard topLeftPress];     break;
            case wmc_bboard_point_left_bottom:  result = [bboard bottomLeftPress];  break;
            case wmc_bboard_point_right_top:    result = [bboard topRightPress];    break;
            case wmc_bboard_point_right_bottom: result = [bboard bottomRightPress]; break;
        }
    }];

    return result;
}

//------------------------------------------------------------------------------
// uDraw API (yes, like extension)
//------------------------------------------------------------------------------

int wmc_w_is_udraw_connected(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = (udraw_at_index(index) != nil);
    }];

    return result;
}

int wmc_w_is_pen_pressed(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [udraw_at_index(index) isPenPressed];
    }];

    return result;
}

float wmc_w_get_pen_x(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [udraw_at_index(index) penPosition].x;
    }];

    return result;
}

float wmc_w_get_pen_y(int index)
{
    __block float result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [udraw_at_index(index) penPosition].y;
    }];

    return result;
}

int wmc_w_is_pen_button_pressed(int index)
{
    __block int result = 0;

    [[WiimoteThread thread] invoke:^
    {
        result = [udraw_at_index(index) isPenButtonPressed];
    }];

    return result;
}
