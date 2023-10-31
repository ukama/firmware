/*
 * This file is part of the coreboot project.
 *
 * Copyright 2018 MediaTek Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#ifndef __SOC_MEDIATEK_MT8183_INCLUDE_SOC_ADDRESSMAP_H__
#define __SOC_MEDIATEK_MT8183_INCLUDE_SOC_ADDRESSMAP_H__

enum {
	MCUCFG_BASE	= 0x0C530000,
	IO_PHYS		= 0x10000000,
};

enum {
	CKSYS_BASE		= IO_PHYS,
	INFRACFG_AO_BASE	= IO_PHYS + 0x00001000,
	GPIO_BASE		= IO_PHYS + 0x00005000,
	SPM_BASE		= IO_PHYS + 0x00006000,
	RGU_BASE		= IO_PHYS + 0x00007000,
	GPT_BASE		= IO_PHYS + 0x00008000,
	EINT_BASE		= IO_PHYS + 0x0000B000,
	APMIXED_BASE		= IO_PHYS + 0x0000C000,
	PWRAP_BASE		= IO_PHYS + 0x0000D000,
	EMI_BASE		= IO_PHYS + 0x00219000,
	EMI_MPU_BASE		= IO_PHYS + 0x00226000,
	DRAMC_CH_BASE		= IO_PHYS + 0x00228000,
	SSPM_SRAM_BASE		= IO_PHYS + 0x00400000,
	SSPM_CFG_BASE		= IO_PHYS + 0x00440000,
	I2C_DMA_BASE		= IO_PHYS + 0x01000080,
	AUXADC_BASE		= IO_PHYS + 0x01001000,
	UART0_BASE		= IO_PHYS + 0x01002000,
	I2C_BASE		= IO_PHYS + 0x01005000,
	SPI0_BASE		= IO_PHYS + 0x0100A000,
	SPI1_BASE		= IO_PHYS + 0x01010000,
	SPI2_BASE		= IO_PHYS + 0x01012000,
	SPI3_BASE		= IO_PHYS + 0x01013000,
	SPI4_BASE		= IO_PHYS + 0x01014000,
	SPI5_BASE		= IO_PHYS + 0x01015000,
	SSUSB_MAC_BASE		= IO_PHYS + 0x01200000,
	SSUSB_IPPC_BASE		= IO_PHYS + 0x01203e00,
	IOCFG_RT_BASE		= IO_PHYS + 0x01C50000,
	IOCFG_RM_BASE		= IO_PHYS + 0x01D20000,
	IOCFG_RB_BASE		= IO_PHYS + 0x01D30000,
	MIPITX_BASE             = IO_PHYS + 0x01E50000,
	IOCFG_LB_BASE		= IO_PHYS + 0x01E70000,
	IOCFG_LM_BASE		= IO_PHYS + 0x01E80000,
	IOCFG_BL_BASE		= IO_PHYS + 0x01E90000,
	EFUSEC_BASE		= IO_PHYS + 0x01F10000,
	IOCFG_LT_BASE		= IO_PHYS + 0x01F20000,
	IOCFG_TL_BASE		= IO_PHYS + 0x01F30000,
	SSUSB_SIF_BASE		= IO_PHYS + 0x01F40300,
	MMSYS_BASE		= IO_PHYS + 0x04000000,
	DISP_OVL0_BASE		= IO_PHYS + 0x04008000,
	DISP_OVL1_BASE		= IO_PHYS + 0x04009000,
	DISP_OVL1_2L_BASE	= IO_PHYS + 0x0400A000,
	DISP_RDMA0_BASE		= IO_PHYS + 0x0400B000,
	DISP_RDMA1_BASE		= IO_PHYS + 0x0400C000,
	DISP_COLOR0_BASE	= IO_PHYS + 0x0400E000,
	DISP_CCORR0_BASE	= IO_PHYS + 0x0400F000,
	DISP_AAL0_BASE		= IO_PHYS + 0x04010000,
	DISP_GAMMA0_BASE	= IO_PHYS + 0x04011000,
	DISP_DITHER0_BASE	= IO_PHYS + 0x04012000,
	DSI0_BASE               = IO_PHYS + 0x04014000,
	DISP_MUTEX_BASE		= IO_PHYS + 0x04016000,
	SMI_LARB0		= IO_PHYS + 0x04017000,
	SMI_BASE		= IO_PHYS + 0x04019000,
};

#endif
