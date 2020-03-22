/**
 * Copyright (c) 2016 - 2017, Nordic Semiconductor ASA
 * 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form, except as embedded into a Nordic
 *    Semiconductor ASA integrated circuit in a product or a software update for
 *    such product, must reproduce the above copyright notice, this list of
 *    conditions and the following disclaimer in the documentation and/or other
 *    materials provided with the distribution.
 * 
 * 3. Neither the name of Nordic Semiconductor ASA nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 * 
 * 4. This software, with or without modification, must only be used with a
 *    Nordic Semiconductor ASA integrated circuit.
 * 
 * 5. Any software provided in binary form under this license must not be reverse
 *    engineered, decompiled, modified and/or disassembled.
 * 
 * THIS SOFTWARE IS PROVIDED BY NORDIC SEMICONDUCTOR ASA "AS IS" AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY, NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL NORDIC SEMICONDUCTOR ASA OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 */

/** @file
 *
 * @defgroup bootloader_secure main.c
 * @{
 * @ingroup dfu_bootloader_api
 * @brief Bootloader project main file for secure DFU.
 *
 */

#include <stdint.h>
#include "boards.h"
#include "nrf_mbr.h"
#include "nrf_bootloader.h"
#include "nrf_bootloader_app_start.h"
#include "nrf_dfu.h"
#include "nrf_log.h"
#include "nrf_log_ctrl.h"
#include "app_error.h"
#include "app_error_weak.h"
#include "nrf_bootloader_info.h"
#include "app_uart.h"
#include "nrf_delay.h"

static void uart_init(void);
void uart_event_handle(app_uart_evt_t* p_event);

void app_error_fault_handler(uint32_t id, uint32_t pc, uint32_t info)
{
    NRF_LOG_ERROR("received a fault! id: 0x%08x, pc: 0x&08x\r\n", id, pc);
    NVIC_SystemReset();
}

void app_error_handler_bare(uint32_t error_code)
{
    (void)error_code;
    NRF_LOG_ERROR("received an error: 0x%08x!\r\n", error_code);
    NVIC_SystemReset();
}


/**@brief Function for initialization of LEDs.
 */
static void leds_init(void)
{
    bsp_board_leds_init();
    bsp_board_led_on(LED_1);
}

/**@brief   Function for handling app_uart events.
 *
 * @details This function will receive a single character from the app_uart module and append it to
 *          a string. The string will be be sent over BLE when the last character received was a
 *          'new line' i.e '\r\n' (hex 0x0D) or if the string has reached a length of
 *          @ref NUS_MAX_DATA_LENGTH.
 */
void uart_event_handle(app_uart_evt_t * p_event) {
    // static uint8_t index = 0;

    switch (p_event->evt_type)
    {
        /**@snippet [Handling data from UART] */
        case APP_UART_DATA_READY:
            // UNUSED_VARIABLE(app_uart_get(&data_array[index]));
            // index++;

            // if ((data_array[index - 1] == '\n') || (index >= (BLE_NUS_MAX_DATA_LEN)))
            // {
            //     while (ble_nus_c_string_send(&m_ble_nus_c, data_array, index) != NRF_SUCCESS)
            //     {
            //         // repeat until sent.
            //     }
            //     index = 0;
            // }
            break;
        /**@snippet [Handling data from UART] */
        case APP_UART_COMMUNICATION_ERROR:
            APP_ERROR_HANDLER(p_event->data.error_communication);
            break;

        case APP_UART_FIFO_ERROR:
            APP_ERROR_HANDLER(p_event->data.error_code);
            break;

        default:
            break;
    }
}


/**@brief Function for initializing the UART.
 */
static void uart_init(void) {
    uint32_t err_code;

    const app_uart_comm_params_t comm_params =
       {
           RX_PIN_NUMBER,
           TX_PIN_NUMBER,
           UART_PIN_DISCONNECTED, //rts
           UART_PIN_DISCONNECTED, //cts
           APP_UART_FLOW_CONTROL_DISABLED,
           false,
           UART_BAUDRATE_BAUDRATE_Baud115200
       };

    APP_UART_FIFO_INIT(&comm_params,
                          RX_BUF_SIZE,
                          TX_BUF_SIZE,
                          uart_event_handle,
                          APP_IRQ_PRIORITY_LOW,
                          err_code);
    UNUSED_VARIABLE(err_code);
}


/**@brief Function for application main entry.
 */
int main(void) {
    uint32_t ret_val;

    // Set the external high frequency clock source to 32 MHz
    NRF_CLOCK->XTALFREQ = 0xFFFFFF00;


    leds_init();

//    uart_init();

//    app_uart_put('S'); app_uart_put(' ');

//    NRF_LOG_INIT(NULL);

//    NRF_LOG_INFO("BL: Inside main\r\n");
    NRF_LOG_PROCESS();
//    printf("Bootloader init\r\n");


    nrf_delay_ms(50);
    ret_val = nrf_bootloader_init();
//    printf("nrf_bootl_init ret = %lu\r\n", ret_val);
    // APP_ERROR_CHECK(ret_val);

    // Either there was no DFU functionality enabled in this project or the DFU module detected
    // no ongoing DFU operation and found a valid main application.
    // Boot the main application.
//    printf("Running main application\r\n");
    nrf_delay_ms(50);
    nrf_bootloader_app_start(MAIN_APPLICATION_START_ADDR);
    // volatile int i = 0;
    // while (true) {
    //     i *= 3;
    // }
    // i++;

    // Should never be reached.
//    NRF_LOG_INFO("After main\r\n");

    return (int)ret_val;
}

/**
 * @}
 */
