/* SPDX-License-Identifier: GPL-2.0+ */
/*
 * Configuration file for the SAMA5D27 OC CA Board.
 *
 * Copyright (C) 2017 OpenCellular
 *		      Vishal Thakur <vthakur@fb.com>
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#include "at91-sama5_common.h"

#undef CONFIG_SYS_AT91_MAIN_CLOCK
#define CONFIG_SYS_AT91_MAIN_CLOCK      24000000 /* from 24 MHz crystal */

/* SDRAM */
#define CONFIG_NR_DRAM_BANKS            1
#define CONFIG_SYS_SDRAM_BASE		0x20000000
#define CONFIG_SYS_SDRAM_SIZE		0x8000000

#ifdef CONFIG_SPL_BUILD
#define CONFIG_SYS_INIT_SP_ADDR		0x218000
#else
#define CONFIG_SYS_INIT_SP_ADDR \
	(CONFIG_SYS_SDRAM_BASE + 16 * 1024 - GENERATED_GBL_DATA_SIZE)
#endif

#define CONFIG_SYS_LOAD_ADDR		0x22000000 /* load address */

/* NAND flash */
#undef CONFIG_CMD_NAND

/* SPI flash */
#define CONFIG_SF_DEFAULT_SPEED         66000000


/* Boot device and partition*/
#ifdef CONFIG_SYS_DUAL_ROOT_PARTITION
#undef CONFIG_SYS_LOAD_ROOT_PARTITION
#define CONFIG_SYS_LOAD_ROOT_PARTITION CONFIG_SYS_LOAD_LINUX_PARTITION
#endif

/* SPI flash */

#undef CONFIG_BOOTCOMMAND
#ifdef CONFIG_SD_BOOT
/* u-boot env in sd/mmc card */
#define CONFIG_ENV_SIZE		0x4000
/* bootstrap + u-boot + env in sd card */
#ifndef CONFIG_SYS_DUAL_ROOT_PARTITION
#define CONFIG_BOOTCOMMAND	"fatload mmc " CONFIG_ENV_FAT_DEVICE_AND_PART " 0x21000000 at91-sama5d27_som1_ek.dtb; " \
				"fatload mmc " CONFIG_ENV_FAT_DEVICE_AND_PART " 0x22000000 zImage; " \
				"bootz 0x22000000 - 0x21000000"
#else
#define CONFIG_BOOTCOMMAND     "ext4load mmc ${mmciface} 0x21000000 /boot/at91-sama5d27_ukama_anode.dtb; " \
			       "ext4load mmc ${mmciface} 0x22000000 /boot/zImage; " \
			       "run ramargs;" \
			       "bootz 0x22000000 - 0x21000000"
#endif
#endif

#ifdef CONFIG_QSPI_BOOT
#undef CONFIG_BOOTARGS
#ifndef CONFIG_SYS_DUAL_ROOT_PARTITION
#define CONFIG_BOOTARGS \
	"console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rw rootwait"
#else
#define CONFIG_BOOTARGS \
	"console=ttyS0,115200 earlyprintk root=/dev/mmcblk${bootdev}p${bootpart} rw rootwait"
#endif
#endif

/* SPL */
#define CONFIG_SPL_TEXT_BASE		0x200000
#define CONFIG_SPL_MAX_SIZE		0x10000
#define CONFIG_SPL_BSS_START_ADDR	0x20000000
#define CONFIG_SPL_BSS_MAX_SIZE		0x80000
#define CONFIG_SYS_SPL_MALLOC_START	0x20080000
#define CONFIG_SYS_SPL_MALLOC_SIZE	0x80000

#define CONFIG_SYS_MONITOR_LEN		(512 << 10)

#ifdef CONFIG_SD_BOOT
#define CONFIG_SYS_MMCSD_FS_BOOT_PARTITION	1
#define CONFIG_SPL_FS_LOAD_PAYLOAD_NAME		"u-boot.img"
#endif

#ifdef CONFIG_QSPI_BOOT
#define CONFIG_SYS_SPI_U_BOOT_OFFS	0x10000
#endif

#endif
