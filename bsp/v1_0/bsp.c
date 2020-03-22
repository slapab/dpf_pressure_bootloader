#include "bsp.h"
#include "custom_board.h"
#include "nrf_gpio.h"
#include "nrf_dfu.h"
#include "nrf_dfu_settings.h"
#include "nrf_delay.h"
#include <stdint.h>

void bsp_board_led_on(uint32_t led) {
    nrf_gpio_pin_clear(led);
}

void bsp_board_led_off(uint32_t led) {
    nrf_gpio_pin_set(led);
}

void bsp_board_leds_init(void) {
    nrf_gpio_cfg_output(BSP_LED_0);
    bsp_board_led_off(BSP_LED_0);
}

bool nrf_dfu_enter_check(void) {
    uint32_t retain_reg = 0;

    // read directly from register
    retain_reg = NRF_POWER->GPREGRET;

    // clear for next call
    NRF_POWER->GPREGRET = 0;

//    printf("Retaining reg val = %lu\r\n", retain_reg);
    nrf_delay_ms(50);
    return ENTER_BOOTLOADER_REQ_VALUE == retain_reg;
}

