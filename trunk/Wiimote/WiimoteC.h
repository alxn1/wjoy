//
//  WiimoteC.h
//  Wiimote
//
//  Created by alxn1 on 26.03.14.
//
//

#ifndef WIIMOTE_C_API
#define WIIMOTE_C_API

#ifdef __cplusplus
    extern "C" {
#endif

typedef enum {
    wmc_log_level_error             =  0,
    wmc_log_level_warning           =  1,
    wmc_log_level_debug             =  2
} wmc_log_level;

typedef enum
{
    wmc_led_one                     =  1,
    wmc_led_two                     =  2,
    wmc_led_tree                    =  4,
    wmc_led_four                    =  8
} wmc_led;

typedef enum
{
    wmc_button_left                 =  0,
    wmc_button_right                =  1,
    wmc_button_up                   =  2,
    wmc_button_down                 =  3,
    wmc_button_a                    =  4,
    wmc_button_b                    =  5,
    wmc_button_plus                 =  6,
    wmc_button_minus                =  7,
    wmc_button_home                 =  8,
    wmc_button_one                  =  9,
    wmc_button_two                  = 10
} wmc_button;

typedef enum
{
	wmc_nunchuck_button_c           =  0,
	wmc_nunchuck_button_z           =  1
} wmc_nunchuck_button;

typedef enum {
    wmc_ccontroller_button_a        =  0,
    wmc_ccontroller_button_b        =  1,
    wmc_ccontroller_button_minus    =  2,
    wmc_ccontroller_button_home     =  3,
    wmc_ccontroller_button_plus     =  4,
    wmc_ccontroller_button_x        =  5,
    wmc_ccontroller_button_y        =  6,
    wmc_ccontroller_button_up       =  7,
    wmc_ccontroller_button_down     =  8,
    wmc_ccontroller_button_left     =  9,
    wmc_ccontroller_button_right    = 10,
    wmc_ccontroller_button_l        = 11,
    wmc_ccontroller_button_r        = 12,
    wmc_ccontroller_button_zl       = 13,
    wmc_ccontroller_button_zr       = 14
} wmc_ccontroller_button;

typedef enum {
    wmc_ccontroller_stick_left      =  0,
    wmc_ccontroller_stick_right     =  1
} wmc_ccontroller_stick;

typedef enum {
    wmc_ccontroller_shift_left      =  0,
    wmc_ccontroller_shift_right     =  1
} wmc_ccontroller_shift;

typedef enum {
    wmc_upro_button_up				=  0,
    wmc_upro_button_down            =  1,
    wmc_upro_button_left            =  2,
    wmc_upro_button_right			=  3,
    wmc_upro_button_a				=  4,
    wmc_upro_button_b				=  5,
    wmc_upro_button_x				=  6,
    wmc_upro_button_y				=  7,
    wmc_upro_button_l				=  8,
    wmc_upro_button_r				=  9,
    wmc_upro_button_zl				= 10,
    wmc_upro_button_zr				= 11,
	wmc_upro_button_stick_l			= 12,
	wmc_upro_button_stick_r			= 13
} wmc_upro_button;

typedef enum {
    wmc_upro_stick_left             =  0,
    wmc_upro_stick_right            =  1
} wmc_upro_stick;

typedef enum {
    wmc_bboard_point_left_top       =  0,
    wmc_bboard_point_left_bottom    =  1,
    wmc_bboard_point_right_top      =  2,
    wmc_bboard_point_right_bottom   =  3
} wmc_bboard_point;

//------------------------------------------------------------------------------
// main API
//------------------------------------------------------------------------------

int wmc_initialize(void);
int wmc_shutdown(void);

int wmc_get_log_level(void);                                    // wmc_log_level
int wmc_set_log_level(int level);                               // wmc_log_level

//------------------------------------------------------------------------------
// discovery API
//------------------------------------------------------------------------------

int wmc_is_bluetooth_enabled(void);

int wmc_is_discovering(void);
int wmc_begin_discovery(void);

int wmc_is_one_button_click_connection_enabled(void);
int wmc_set_one_button_click_connection_enabled(int enabled);

//------------------------------------------------------------------------------
// wiimote API
//------------------------------------------------------------------------------

int wmc_get_count_connected(void);
int wmc_disconnect(int index);

int wmc_w_get_id(int index);                                    // any number
int wmc_w_set_id(int index, int wid);                           // any number
int wmc_w_index_with_id(int wid);                               // -1, if disconnected

int wmc_w_play_connect_effect(int index);

int wmc_w_get_led_mask(int index);                              // wmc_led (by or)
int wmc_w_set_led_mask(int index, int mask);                    // wmc_led (by or)

int wmc_w_is_vibration_enabled(int index);
int wmc_w_set_vibration_enabled(int index, int enabled);

int wmc_w_is_button_pressed(int index, int button);             // one of wmc_button

int wmc_w_is_battery_low(int index);
float wmc_w_get_battery_level(int index);

int wmc_w_is_ir_enabled(int index);
int wmc_w_set_ir_enabled(int index, int enabled);

int wmc_w_is_ir_point_out_of_view(int index, int point);
float wmc_w_get_ir_point_x(int index, int point);
float wmc_w_get_ir_point_y(int index, int point);

int wmc_w_is_accelerometer_enabled(int index);
int wmc_w_set_accelerometer_enabled(int index, int enabled);

float wmc_w_get_accelerometer_x(int index);
float wmc_w_get_accelerometer_y(int index);
float wmc_w_get_accelerometer_z(int index);

float wmc_w_get_accelerometer_pitch(int index);
float wmc_w_get_accelerometer_roll(int index);

//------------------------------------------------------------------------------
// nunchuck API
//------------------------------------------------------------------------------

int wmc_w_is_nunchuck_connected(int index);
int wmc_w_is_nunchuck_button_pressed(int index, int button);    // wmc_nunchuck_button

float wmc_w_get_nunchuck_stick_x(int index);
float wmc_w_get_nunchuck_stick_y(int index);

int wmc_w_is_nunchuck_accelerometer_enabled(int index);
int wmc_w_set_nunchuck_accelerometer_enabled(int index, int enabled);

float wmc_w_get_nunchuck_accelerometer_x(int index);
float wmc_w_get_nunchuck_accelerometer_y(int index);
float wmc_w_get_nunchuck_accelerometer_z(int index);

float wmc_w_get_nunchuck_accelerometer_pitch(int index);
float wmc_w_get_nunchuck_accelerometer_roll(int index);

//------------------------------------------------------------------------------
// classic controller API
//------------------------------------------------------------------------------

int wmc_w_is_ccontroller_connected(int index);
int wmc_w_is_ccontroller_button_pressed(int index, int button); // wmc_ccontroller_button

float wmc_w_get_ccontroller_stick_x(int index, int stick);      // wmc_ccontroller_stick
float wmc_w_get_ccontroller_stick_y(int index, int stick);      // wmc_ccontroller_stick

float wmc_w_get_ccontroller_shift(int index, int shift);        // wmc_ccontroller_shift

//------------------------------------------------------------------------------
// wii u pro controller API (yes, like extension)
//------------------------------------------------------------------------------

int wmc_w_is_upro_connected(int index);
int wmc_w_is_upro_button_pressed(int index, int button);        // wmc_upro_button

float wmc_w_get_upro_stick_x(int index, int stick);             // wmc_upro_stick
float wmc_w_get_upro_stick_y(int index, int stick);             // wmc_upro_stick

//------------------------------------------------------------------------------
// balance board API (yes, like extension)
//------------------------------------------------------------------------------

int wmc_w_is_bboard_connected(int index);
float wmc_w_get_bboard_press(int index, int point);             // wmc_bboard_point

//------------------------------------------------------------------------------
// uDraw API (yes, like extension)
//------------------------------------------------------------------------------

int wmc_w_is_udraw_connected(int index);
int wmc_w_is_pen_pressed(int index);
float wmc_w_get_pen_x(int index);
float wmc_w_get_pen_y(int index);
int wmc_w_is_pen_button_pressed(int index);

#ifdef __cplusplus
    } /* extern "C" */
#endif

#endif /* WIIMOTE_C_API */
