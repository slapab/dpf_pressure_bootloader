PROJECT_NAME     := secure_dfu_ble_s130_nrf51822
TARGETS          := nrf51822_xxaa_s130_bootloader
OUTPUT_DIRECTORY := _build

OPENOCD_PATH := /opt/openocd/0.10.0-201610281609-dev/bin/
OPENOCD_CMD_COMMON := $(OPENOCD_PATH)/openocd -f interface/ftdi/jtag-lock-pick_tiny_2.cfg -c "transport select swd;" -c "set WORKAREASIZE 0;" -f "target/nrf51.cfg" -c "adapter_khz 1000;"
STDERR_TO_STDOUT := 2>&1

SDK_ROOT := ./nRF5_SDK_12.3.0_d7731ad/
PROJ_DIR := .

$(OUTPUT_DIRECTORY)/nrf51822_xxaa_s130_bootloader.out: \
  LINKER_SCRIPT  := $(PROJ_DIR)/secure_dfu_gcc_nrf51.ld

# [in] path to the softdevice hex
SOFTDEVICE_HEX := $(SDK_ROOT)/components/softdevice/s130/hex/s130_nrf51_2.0.1_softdevice.hex

# List of supported BSPs
# 10 - v1_0
# Select compilation BSP version (valid values are from suported BSP list) 
BSP_USE_VER := 10
ifeq ($(BSP_USE_VER),10)
	BSP_DIR := $(PROJ_DIR)/bsp/v1_0
else
	$(error Please selct valid BSP version!)
endif


# Source files common to all targets
SRC_FILES += \
  $(SDK_ROOT)/components/libraries/util/app_error_weak.c \
  $(SDK_ROOT)/components/libraries/scheduler/app_scheduler.c \
  $(SDK_ROOT)/components/libraries/timer/app_timer.c \
  $(SDK_ROOT)/components/libraries/timer/app_timer_appsh.c \
  $(SDK_ROOT)/components/libraries/util/app_util_platform.c \
  $(SDK_ROOT)/components/libraries/crc32/crc32.c \
  $(SDK_ROOT)/components/libraries/ecc/ecc.c \
  $(SDK_ROOT)/components/libraries/fstorage/fstorage.c \
  $(SDK_ROOT)/components/libraries/hci/hci_mem_pool.c \
  $(SDK_ROOT)/components/libraries/util/nrf_assert.c \
  $(SDK_ROOT)/components/libraries/crypto/nrf_crypto.c \
  $(SDK_ROOT)/components/libraries/queue/nrf_queue.c \
  $(SDK_ROOT)/components/libraries/util/sdk_errors.c \
  $(SDK_ROOT)/components/libraries/sha256/sha256.c \
  $(SDK_ROOT)/components/drivers_nrf/common/nrf_drv_common.c \
  $(SDK_ROOT)/components/drivers_nrf/rng/nrf_drv_rng.c \
  $(SDK_ROOT)/components/drivers_nrf/hal/nrf_nvmc.c \
  $(SDK_ROOT)/components/ble/common/ble_advdata.c \
  $(SDK_ROOT)/components/ble/common/ble_conn_params.c \
  $(SDK_ROOT)/components/ble/common/ble_srv_common.c \
  $(SDK_ROOT)/external/nano-pb/pb_common.c \
  $(SDK_ROOT)/external/nano-pb/pb_decode.c \
  $(SDK_ROOT)/components/toolchain/gcc/gcc_startup_nrf51.S \
  $(SDK_ROOT)/components/toolchain/system_nrf51.c \
  $(SDK_ROOT)/components/softdevice/common/softdevice_handler/softdevice_handler.c \
  $(SDK_ROOT)/components/softdevice/common/softdevice_handler/softdevice_handler_appsh.c \
  $(SDK_ROOT)/components/drivers_nrf/uart/nrf_drv_uart.c \
  $(SDK_ROOT)/components/libraries/uart/app_uart_fifo.c \
  $(SDK_ROOT)/components/libraries/fifo/app_fifo.c \
  $(SDK_ROOT)/components/libraries/uart/retarget.c \
  $(PROJ_DIR)/dfu-cc.pb.c \
  $(PROJ_DIR)/dfu_public_key.c \
  $(PROJ_DIR)/dfu_req_handling.c \
  $(PROJ_DIR)/main.c \
  $(PROJ_DIR)/bootloader/ble_dfu/nrf_ble_dfu.c \
  $(PROJ_DIR)/bootloader/nrf_bootloader.c \
  $(PROJ_DIR)/bootloader/nrf_bootloader_app_start.c \
  $(PROJ_DIR)/bootloader/nrf_bootloader_info.c \
  $(PROJ_DIR)/bootloader/dfu/nrf_dfu.c \
  $(PROJ_DIR)/bootloader/dfu/nrf_dfu_flash.c \
  $(PROJ_DIR)/bootloader/dfu/nrf_dfu_mbr.c \
  $(PROJ_DIR)/bootloader/dfu/nrf_dfu_settings.c \
  $(PROJ_DIR)/bootloader/dfu/nrf_dfu_transport.c \
  $(PROJ_DIR)/bootloader/dfu/nrf_dfu_utils.c \
  $(BSP_DIR)/bsp.c \
  
  #$(SDK_ROOT)/components/libraries/bootloader/ble_dfu/nrf_ble_dfu.c \

# Include folders common to all targets
INC_FOLDERS += \
  $(SDK_ROOT)/components/drivers_nrf/rng \
  $(SDK_ROOT)/components/device \
  $(SDK_ROOT)/components/drivers_nrf/hal \
  $(SDK_ROOT)/components/libraries/sha256 \
  $(SDK_ROOT)/components/libraries/crc32 \
  $(SDK_ROOT)/components/libraries/experimental_section_vars \
  $(SDK_ROOT)/components/libraries/fstorage \
  $(SDK_ROOT)/components/libraries/util \
  $(SDK_ROOT)/components \
  $(SDK_ROOT)/components/softdevice/common/softdevice_handler \
  $(SDK_ROOT)/components/libraries/timer \
  $(SDK_ROOT)/components/drivers_nrf/clock \
  $(SDK_ROOT)/components/softdevice/s130/headers \
  $(SDK_ROOT)/components/libraries/log/src \
  $(SDK_ROOT)/components/drivers_nrf/delay \
  $(SDK_ROOT)/components/ble/common \
  $(SDK_ROOT)/components/drivers_nrf/common \
  $(SDK_ROOT)/components/libraries/svc \
  $(SDK_ROOT)/components/libraries/scheduler \
  $(SDK_ROOT)/components/libraries/log \
  $(SDK_ROOT)/components/libraries/hci \
  $(SDK_ROOT)/components/boards \
  $(SDK_ROOT)/components/libraries/crypto \
  $(SDK_ROOT)/components/toolchain \
  $(SDK_ROOT)/components/toolchain/cmsis/include \
  $(SDK_ROOT)/external/micro-ecc/micro-ecc \
  $(SDK_ROOT)/external/nano-pb \
  $(SDK_ROOT)/components/libraries/ecc \
  $(SDK_ROOT)/components/softdevice/s130/headers/nrf51 \
  $(SDK_ROOT)/components/libraries/queue \
  $(SDK_ROOT)/components/toolchain/gcc \
  $(SDK_ROOT)/components/libraries/uart/ \
  $(SDK_ROOT)/components/drivers_nrf/uart \
  $(SDK_ROOT)/components/libraries/fifo/ \
  $(PROJ_DIR)/config \
  $(PROJ_DIR)/ \
  $(PROJ_DIR)/bsp \
  $(BSP_DIR)/ \
  $(PROJ_DIR)/bootloader/ble_dfu \
  $(PROJ_DIR)/bootloader/dfu \
  $(PROJ_DIR)/bootloader \
  
    #$(SDK_ROOT)/components/libraries/bootloader/ble_dfu \

# Libraries common to all targets
LIB_FILES += \
  $(SDK_ROOT)/external/micro-ecc/nrf51_armgcc/armgcc/micro_ecc_lib_nrf51.a \

# C flags common to all targets
CFLAGS += -DSWI_DISABLE0
CFLAGS += -DBOARD_CUSTOM
CFLAGS += -DSOFTDEVICE_PRESENT
CFLAGS += -DNRF51
CFLAGS += -DNRF_DFU_SETTINGS_VERSION=1
CFLAGS += -D__HEAP_SIZE=0
CFLAGS += -DSVC_INTERFACE_CALL_AS_NORMAL_FUNCTION
CFLAGS += -DS130
CFLAGS += -DBLE_STACK_SUPPORT_REQD
CFLAGS += -DNRF51822
CFLAGS += -DNRF_SD_BLE_API_VERSION=2
CFLAGS += -mcpu=cortex-m0
CFLAGS += -mthumb -mabi=aapcs
CFLAGS +=  -Wall  -Os -g3 # -Werror
CFLAGS += -mfloat-abi=soft
# keep every function in separate section, this allows linker to discard unused ones
CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
CFLAGS += -fno-builtin --short-enums -fomit-frame-pointer -flto 

# C++ flags common to all targets
CXXFLAGS += \

# Assembler flags common to all targets
ASMFLAGS += -x assembler-with-cpp
ASMFLAGS += -DSWI_DISABLE0
ASMFLAGS += -DBOARD_CUSTOM
ASMFLAGS += -DSOFTDEVICE_PRESENT
ASMFLAGS += -DNRF51
ASMFLAGS += -DNRF_DFU_SETTINGS_VERSION=1
ASMFLAGS += -D__HEAP_SIZE=0
ASMFLAGS += -DSVC_INTERFACE_CALL_AS_NORMAL_FUNCTION
ASMFLAGS += -DS130
ASMFLAGS += -DBLE_STACK_SUPPORT_REQD
ASMFLAGS += -DNRF51822
ASMFLAGS += -DNRF_SD_BLE_API_VERSION=2

# Linker flags
LDFLAGS += -mthumb -mabi=aapcs -L $(TEMPLATE_PATH) -T$(LINKER_SCRIPT)
LDFLAGS += -mcpu=cortex-m0
# let linker to dump unused sections
LDFLAGS += -Wl,--gc-sections
# use newlib in nano version
LDFLAGS += --specs=nano.specs -lc -lnosys


.PHONY: $(TARGETS) default all clean help flash 

# Default target - first one defined
default: nrf51822_xxaa_s130_bootloader

# Print all targets that can be built
help:
	@echo following targets are available:
	@echo 	nrf51822_xxaa_s130_bootloader
	
# Flash softdevice
flash_softdevice:
	@echo "Flashing: $(SOFTDEVICE_HEX)"
#	$(OPENOCD_CMD_COMMON) -c "init; reset halt;" -c "program $(SOFTDEVICE_HEX) verify reset; reset run; exit;" $(STDERR_TO_STDOUT)
	nrfjprog --program $(SOFTDEVICE_HEX) -f nrf51 --sectorerase
	nrfjprog --reset -f nrf51
	

# Flash the program
flash: $(OUTPUT_DIRECTORY)/nrf51822_xxaa_s130_bootloader.hex
	@echo Flashing: $<
#	$(OPENOCD_CMD_COMMON) -c "init; reset halt;" -c "program $< verify reset; reset run; exit;" $(STDERR_TO_STDOUT)

	nrfjprog --program $< -f nrf51 --sectorerase --reset
#	nrfjprog --reset -f nrf51

erase:
#	@echo Erasing
#	$(OPENOCD_CMD_COMMON) -c "init; reset; halt; nrf51 mass_erase; reset halt; exit;" $(STDERR_TO_STDOUT)
	nrfjprog --eraseall -f nrf51
	
# Informs system by writing to UCIR that there is 32MHz crystal 
set_uicr_32mhz:
	@echo Current settings are:
	@nrfjprog -f nrf51 --memrd 0x10001008 --n 4
	@echo Trying to write config \(will fail if already set\)
	nrfjprog -f nrf51 --memwr 0x10001008 --val 0xFFFFFF00

TEMPLATE_PATH := $(SDK_ROOT)/components/toolchain/gcc

include $(TEMPLATE_PATH)/Makefile.common

$(foreach target, $(TARGETS), $(call define_target, $(target)))

