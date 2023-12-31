/* Copyright 2019 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
#include "config.h"

#define STRINGIFY0(name) #name
#define STRINGIFY(name) STRINGIFY0(name)

#define FW_OFF_(section) CONFIG_##section##_MEM_OFF
#define FW_OFF(section) (CONFIG_PROGRAM_MEMORY_BASE + FW_OFF_(section))

#define FW_SIZE_(section) CONFIG_##section##_SIZE
#define FW_SIZE(section) FW_SIZE_(section)


OUTPUT_FORMAT(BFD_FORMAT, BFD_FORMAT, BFD_FORMAT)
OUTPUT_ARCH(BFD_ARCH)
ENTRY(__reset)
MEMORY
{
    FLASH (rx) : ORIGIN = FW_OFF(SECTION) - CHIP_ILM_BASE, \
                 LENGTH = FW_SIZE(SECTION)
    /*
     * ILM (Instruction Local Memory).
     * We connect ILM to internal flash so we are able to boot from the flash.
     */
    ILM   (rx) : ORIGIN = FW_OFF(SECTION), LENGTH = FW_SIZE(SECTION)
    IRAM (rw)  : ORIGIN = CONFIG_RAM_BASE + CHIP_RAM_SPACE_RESERVED,
                 LENGTH = CONFIG_RAM_SIZE - CHIP_RAM_SPACE_RESERVED
#if defined(CONFIG_HOSTCMD_X86) || defined(CONFIG_I2C_SLAVE)
    H2RAM (rw) : ORIGIN = CONFIG_H2RAM_BASE, LENGTH = CONFIG_H2RAM_SIZE
#endif
}
SECTIONS
{
    .text : {
        /* We put "__flash_dma_start" at the beginning of the text section
         * to avoid gap.
         */
        __flash_dma_start = .;
        ASSERT((__flash_dma_start == 0),
                "__flash_dma_start has to be 4k-byte aligned");
        KEEP(STRINGIFY(OUTDIR/core/CORE/init.o) (.text.vecttable))
        . = ALIGN(4);
        __image_data_offset = .;
        KEEP(*(.rodata.ver))
        . = ALIGN(4);
        KEEP(STRINGIFY(OUTDIR/core/CORE/init.o) (.text.vectirq))
        KEEP(STRINGIFY(OUTDIR/core/CORE/init.o) (.text))
        KEEP(*(.flash_direct_map))
        . = ALIGN(16);
        KEEP(*(.ram_code))
        __flash_dma_size = . - __flash_dma_start;
        ASSERT((__flash_dma_size < IT83XX_ILM_BLOCK_SIZE),
                "__flash_dma_size < IT83XX_ILM_BLOCK_SIZE");
        . = ALIGN(IT83XX_ILM_BLOCK_SIZE);
        __flash_text_start = .;
        *(.text*)
        . = ALIGN(4);
    } > ILM AT>FLASH

    . = ALIGN(4);
    .rodata :  {
        /* Symbols defined here are declared in link_defs.h */
        __irqprio = .;
        KEEP(*(.rodata.irqprio))
        __irqprio_end = .;

        . = ALIGN(4);
        __irqhandler = .;
        KEEP(STRINGIFY(OUTDIR/core/CORE/init.o) (.rodata.vecthandlers))

        . = ALIGN(4);
        __cmds = .;
        KEEP(*(SORT(.rodata.cmds*)))
        __cmds_end = .;

        . = ALIGN(4);
        __hcmds = .;
        KEEP(*(SORT(.rodata.hcmds*)))
        __hcmds_end = .;

        . = ALIGN(4);
        __mkbp_evt_srcs = .;
        KEEP(*(.rodata.evtsrcs))
        __mkbp_evt_srcs_end = .;

        . = ALIGN(4);
        __hooks_init = .;
        KEEP(*(.rodata.HOOK_INIT))
        __hooks_init_end = .;

        __hooks_pre_freq_change = .;
        KEEP(*(.rodata.HOOK_PRE_FREQ_CHANGE))
        __hooks_pre_freq_change_end = .;

        __hooks_freq_change = .;
        KEEP(*(.rodata.HOOK_FREQ_CHANGE))
        __hooks_freq_change_end = .;

        __hooks_sysjump = .;
        KEEP(*(.rodata.HOOK_SYSJUMP))
        __hooks_sysjump_end = .;

        __hooks_chipset_pre_init = .;
        KEEP(*(.rodata.HOOK_CHIPSET_PRE_INIT))
        __hooks_chipset_pre_init_end = .;

        __hooks_chipset_startup = .;
        KEEP(*(.rodata.HOOK_CHIPSET_STARTUP))
        __hooks_chipset_startup_end = .;

        __hooks_chipset_resume = .;
        KEEP(*(.rodata.HOOK_CHIPSET_RESUME))
        __hooks_chipset_resume_end = .;

        __hooks_chipset_suspend = .;
        KEEP(*(.rodata.HOOK_CHIPSET_SUSPEND))
        __hooks_chipset_suspend_end = .;

        __hooks_chipset_shutdown = .;
        KEEP(*(.rodata.HOOK_CHIPSET_SHUTDOWN))
        __hooks_chipset_shutdown_end = .;

        __hooks_chipset_reset = .;
        KEEP(*(.rodata.HOOK_CHIPSET_RESET))
        __hooks_chipset_reset_end = .;

        __hooks_ac_change = .;
        KEEP(*(.rodata.HOOK_AC_CHANGE))
        __hooks_ac_change_end = .;

        __hooks_lid_change = .;
        KEEP(*(.rodata.HOOK_LID_CHANGE))
        __hooks_lid_change_end = .;

        __hooks_tablet_mode_change = .;
        KEEP(*(.rodata.HOOK_TABLET_MODE_CHANGE))
        __hooks_tablet_mode_change_end = .;

        __hooks_base_attached_change = .;
        KEEP(*(.rodata.HOOK_BASE_ATTACHED_CHANGE))
        __hooks_base_attached_change_end = .;

        __hooks_pwrbtn_change = .;
        KEEP(*(.rodata.HOOK_POWER_BUTTON_CHANGE))
        __hooks_pwrbtn_change_end = .;

        __hooks_battery_soc_change = .;
        KEEP(*(.rodata.HOOK_BATTERY_SOC_CHANGE))
        __hooks_battery_soc_change_end = .;

#ifdef CONFIG_USB_SUSPEND
	__hooks_usb_change = .;
	KEEP(*(.rodata.HOOK_USB_PM_CHANGE))
	__hooks_usb_change_end = .;
#endif

        __hooks_tick = .;
        KEEP(*(.rodata.HOOK_TICK))
        __hooks_tick_end = .;

        __hooks_second = .;
        KEEP(*(.rodata.HOOK_SECOND))
        __hooks_second_end = .;

        __hooks_usb_pd_disconnect = .;
        KEEP(*(.rodata.HOOK_USB_PD_DISCONNECT))
        __hooks_usb_pd_disconnect_end = .;

        __hooks_usb_pd_connect = .;
        KEEP(*(.rodata.HOOK_USB_PD_CONNECT))
        __hooks_usb_pd_connect_end = .;

        __deferred_funcs = .;
        KEEP(*(.rodata.deferred))
        __deferred_funcs_end = .;

        . = ALIGN(4);
        *(.rodata*)

        . = ALIGN(4);
        *(.srodata*)
#if defined(SECTION_IS_RO) && defined(CONFIG_FLASH)
        . = ALIGN(64);
        KEEP(*(.google))
#endif
        . = ALIGN(4);
    } > ILM AT>FLASH
    __data_lma_start = .;

    .data : {
        . = ALIGN(4);
        __data_start = .;
        *(.data)
        *(.sdata)
        . = ALIGN(4);
        __data_end = .;
    } > IRAM AT>FLASH

    .bss : {
        /* Stacks must be 128-bit aligned */
        . = ALIGN(16);
        __bss_start = .;
        *(.bss.tasks)
        . = ALIGN(16);
        *(.bss.system_stack)
        . = ALIGN(16);
        *(.bss.task_scratchpad)
        . = ALIGN(16);
        __global_pointer$ = .;
        *(.sbss)
        . = ALIGN(4);
        /* Rest of .bss takes care of its own alignment */
        *(.bss)
        *(.bss.slow)

	/*
	 * Reserve space for deferred function firing times.  Each time is a
	 * uint64_t, each func is a 32-bit pointer, thus the scaling factor of
	 * two.
	 */
        . = ALIGN(8);
        __deferred_until = .;
	. += (__deferred_funcs_end - __deferred_funcs) * (8 / 4);
        __deferred_until_end = .;

        . = ALIGN(4);
        __bss_end = .;

        /* Shared memory buffer must be at the end of preallocated RAM, so it
         * can expand to use all the remaining RAM. */
        __shared_mem_buf = .;

    } > IRAM

    ASSERT((__shared_mem_buf + CONFIG_SHAREDMEM_MINIMUM_SIZE) <=
               (CONFIG_RAM_BASE + CONFIG_RAM_SIZE),
           "Not enough space for shared memory.")
    __ram_free = (CONFIG_RAM_BASE + CONFIG_RAM_SIZE) -
        (__shared_mem_buf + CONFIG_SHAREDMEM_MINIMUM_SIZE);
    __image_size = LOADADDR(.data) + SIZEOF(.data) + \
                        CHIP_ILM_BASE - FW_OFF(SECTION);

#if defined(CONFIG_HOSTCMD_X86) || defined(CONFIG_I2C_SLAVE)
    .h2ram (NOLOAD) : {
        . += CONFIG_H2RAM_HOST_LPC_IO_BASE;
        *(.h2ram.pool.hostcmd)
        . = ALIGN(256);
        *(.h2ram.pool.acpiec)
#ifdef CONFIG_I2C_SLAVE
        . = ALIGN(256);
        *(.h2ram.pool.i2cslv)
#endif
        __h2ram_end = .;
    } > H2RAM
#endif
    ASSERT((__h2ram_end) <= (CONFIG_H2RAM_BASE + CONFIG_H2RAM_SIZE),
            "Not enough space for h2ram section.")

#if !(defined(SECTION_IS_RO) && defined(CONFIG_FLASH))
    /DISCARD/ : {
              *(.google)
              }
#endif

    /DISCARD/ : { *(.ARM.*) }
}
