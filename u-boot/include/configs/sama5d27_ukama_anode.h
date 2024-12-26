/* SPDX-License-Identifier: GPL-2.0+ */
/*
 * Configuration file for the SAMA5D27 UKAMA ANode Board.
 *
 * Copyright (C) 2024 Ukama Inc.
 *		      Vishal Thakur <vishal@ukama.com>
 */

#ifndef __CONFIG_H
#define __CONFIG_H

#include "at91-sama5_common.h"

#undef CFG_SYS_AT91_MAIN_CLOCK
#define CFG_SYS_AT91_MAIN_CLOCK      24000000 /* from 24 MHz crystal */

#define CFG_SYS_PL310_BASE		0xa00000

#define ENV_UPGRADE_AVAILABLE "upgrade_available=1 \0"
#define ENV_SW_INITIATED_UPGRADE "sw_initiated_upgrade=0 \0"
#define ENV_ALT_BOOT_CMD "altbootcmd=run bootcmd \0"
#define MMC_BLK_ID "mmcblkid=0 \0"

#define ENV_SET_DEFAULT "set_uboot_env=" \
    "echo Initializing ubootenv;" \
    "setenv partition_good 1;" \
    "setenv partition_bad 2;" \
    "setenv rootfs_dev /dev/mmcblk;" \
    "setenv bootlimit 3;" \
    "setenv rootfs_part_A 5;" \
    "setenv rootfs_part_B 6;" \
    "setenv rootfs_part_R 3;" \
    "setenv altbootcmd run bootcmd;" \
    "saveenv; \0"

#define ENV_SET_CONDITIONAL "set_conditional_env=" \
    "if test -n ${partition_status_A}; then " \
        "echo partition_status_A ${partition_status_A};" \
    "else " \
        "setenv partition_status_A ${partition_good};" \
    "fi;" \
    "if test -n ${partition_status_B}; then "\
        "echo partition_status_B ${partition_status_B};"\
    "else " \
        "setenv partition_status_B ${partition_good};" \
    "fi;" \
    "if test -n ${upgrade_available}; then " \
        "echo upgrade_available ${upgrade_available};" \
    "else " \
        "setenv upgrade_available 1;" \
    "fi;" \
    "if test -n ${sw_initiated_upgrade}; then " \
        "echo sw_initiated_upgrade ${sw_initiated_upgrade};" \
    "else " \
        "setenv sw_initiated_upgrade 0;" \
    "fi;" \
    "saveenv; \0"

#define ENV_SET_ACTIVE_PART "set_active_part=" \
    "if test -n ${active_part}; then " \
        "echo active_part ${active_part};" \
        "if test ${active_part} -eq ${rootfs_part_A}; then " \
            "setenv partitionset_active A;" \
            "env delete B;" \
            "env delete R;" \
        "fi;" \
        "if test ${active_part} -eq ${rootfs_part_B}; then " \
            "setenv partitionset_active B;" \
            "env delete A;" \
            "env delete R;" \
        "fi;" \
        "if test ${active_part} -eq ${rootfs_part_R}; then " \
            "setenv partitionset_active R;" \
            "env delete A;" \
            "env delete B;" \
        "fi;" \
    "else  " \
        "setenv active_part ${rootfs_part_A};" \
        "setenv partitionset_active A;" \
        "env delete B;" \
        "env delete R;" \
    "fi; " \
    "setenv ${partitionset_active} true;"\
    "saveenv; \0"

#define ENV_SET_BOOTARGS "set_bootargs="\
    "setenv bootargs console=ttyS0,115200 earlyprintk root=${mmc_active_vol} rw rootwait \0"

#define ENV_SET_MMC_IFACE "set_mmc_iface=setenv mmc_iface ${mmcblkid}:${active_part} \0"

#define ENV_SET_MMC_VOL "set_mmc_vol=setenv mmc_active_vol ${rootfs_dev}${mmcblkid}p${active_part}; \0"

#define ENV_TOGGLE_PARTITION "toggle_partition="\
    "if test -n ${A}; then " \
        "run  if_switch_from_A;" \
    "else " \
        "if test -n ${B}; then " \
            "run  if_switch_from_B;" \
        "else " \
            "run  if_switch_from_R;" \
        "fi;" \
    "fi;" \
    "setenv bootcount 0;" \
    "run set_active_part;" \
    "saveenv; \0"

#define ENV_LOAD_FILES "load_bootfiles=" \
    "echo Loading dtb from eMMC ...:;" \
    "ext4load mmc ${mmc_iface} 0x21000000 /boot/ukama_anode.dtb;" \
    "echo Loading kernel from eMMC ...;" \
    "ext4load mmc ${mmc_iface} 0x22000000 /boot/zImage;" \
    "echo Booting ${partitionset_active} fspart: ${active_part} from mmc ${mmc_iface} with args ${bootargs}; \0"

#define ENV_IF_SWITCH_FROM_R "if_switch_from_R=" \
    "if test ${partition_status_A} -eq ${partition_good}; then " \
        "echo Switching to A after recovery;" \
        "setenv active_part ${rootfs_part_A};" \
        "env delete R;"\
    "fi;" \
    "if test ${partition_status_B} -eq ${partition_good}; then " \
        "echo Switching to B after recovery;" \
        "setenv active_part ${rootfs_part_B};" \
        "env delete R;" \
    "else " \
        "echo Booting recovery;" \
        "setenv active_part ${rootfs_part_R};" \
    "fi;" \
    "saveenv; \0"

#define ENV_IF_SWITCH_FROM_A "if_switch_from_A=" \
    "if test ${partition_status_B} -eq ${partition_good}; then " \
        "echo Booting B;" \
        "setenv active_part ${rootfs_part_B};" \
        "env delete A;" \
    "else " \
        "echo Booting recovery;" \
        "setenv active_part ${rootfs_part_R};" \
        "env delete A;" \
    "fi;" \
    "saveenv;\0"

#define ENV_IF_SWITCH_FROM_B "if_switch_from_B=" \
    "if test ${partition_status_A} -eq ${partition_good}; then " \
        "echo Booting A;" \
        "setenv active_part ${rootfs_part_A};" \
        "env delete B;" \
    "else " \
    "echo Booting recovery;" \
        "setenv active_part ${rootfs_part_R};" \
        "env delete B;" \
    "fi;" \
    "saveenv; \0"

#define ENV_CHECK_UPGARDES "check_upgrade="\
    "if test ${upgrade_available} -eq 1; then " \
        "echo  upgrade_available is set;" \
        "if test ${bootcount} -gt ${bootlimit}; then " \
            "if test -n ${A}; then " \
                "setenv partition_status_A ${partition_bad};" \
                "echo  partition A marked bad; " \
            "fi;" \
            "if test -n ${B}; then " \
                "setenv partition_status_B ${partition_bad};" \
                "echo  partition B marked bad; " \
            "fi;" \
            "if test -n ${R}; then " \
                "echo Still boot from recovery;" \
            "else " \
                "echo toggle partition due to boot failure for last ${bootcount} count;" \
                "run toggle_partition;" \
            "fi;" \
        "fi;" \
    "fi;" \
    "if test ${sw_initiated_upgrade} -eq 1; then " \
        "echo  sw initiated upgrade is set; " \
        "echo toggle partition due to sw upgrade is set; " \
        "run toggle_partition;" \
        "setenv sw_initiated_upgrade 0;" \
    "fi;" \
    "saveenv; \0"

#define ENV_EMMC_BOOT "emmc_boot="\
    "run set_uboot_env;" \
    "run set_conditional_env;" \
    "run set_active_part;" \
    "run check_upgrade; " \
    "run set_mmc_vol;" \
    "run set_bootargs;" \
    "run set_mmc_iface;" \
    "run load_bootfiles; \0"

#define ENV_BOOT_CMD "bootcmd=run emmc_boot; bootz 0x22000000 - 0x21000000; \0"

#define CFG_EXTRA_ENV_SETTINGS \
	ENV_MMC_BLK_ID \
        ENV_SET_DEFAULT \
        ENV_SET_CONDITIONAL \
        ENV_SET_ACTIVE_PART \
        ENV_SET_BOOTARGS \
        ENV_SET_MMC_IFACE \
        ENV_SET_MMC_VOL \
        ENV_TOGGLE_PARTITION \
        ENV_LOAD_FILES \
        ENV_IF_SWITCH_FROM_R \
        ENV_IF_SWITCH_FROM_A \
        ENV_IF_SWITCH_FROM_B \
        ENV_CHECK_UPGARDES \
        ENV_EMMC_BOOT \
        ENV_BOOT_CMD "\0"

#endif  
