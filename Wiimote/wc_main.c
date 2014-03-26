//
//  main.c
//  wc_test
//
//  Created by alxn1 on 26.03.14.
//
//

#include "WiimoteC.h"

#include <stdio.h>

int main(int argC, char *argV[])
{
    wmc_initialize();
    wmc_set_log_level(wmc_log_level_debug);
    wmc_set_one_button_click_connection_enabled(1);

    wmc_begin_discovery();
    while(wmc_get_count_connected() == 0) {}

    wmc_w_play_connect_effect(0);
    wmc_w_set_led_mask(0, wmc_led_one);
    while(wmc_get_count_connected() != 0)
    {
        if(wmc_w_is_button_pressed(0, wmc_button_left))     printf("L");
        if(wmc_w_is_button_pressed(0, wmc_button_right))    printf("R");
        if(wmc_w_is_button_pressed(0, wmc_button_up))       printf("U");
        if(wmc_w_is_button_pressed(0, wmc_button_down))     printf("D");
        if(wmc_w_is_button_pressed(0, wmc_button_a))        printf("a");
        if(wmc_w_is_button_pressed(0, wmc_button_b))        printf("b");
        if(wmc_w_is_button_pressed(0, wmc_button_plus))     printf("+");
        if(wmc_w_is_button_pressed(0, wmc_button_minus))    printf("-");
        if(wmc_w_is_button_pressed(0, wmc_button_home))     printf("H");
        if(wmc_w_is_button_pressed(0, wmc_button_one))      printf("1");
        if(wmc_w_is_button_pressed(0, wmc_button_two))      printf("2");
    }

    wmc_shutdown();
    printf("\nOK\n");
    return 0;
}
