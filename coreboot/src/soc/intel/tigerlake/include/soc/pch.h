/*
 * This file is part of the coreboot project.
 *
 * Copyright (C) 2019 Intel Corporation.
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

#ifndef _SOC_TIGERLAKE_PCH_H_
#define _SOC_TIGERLAKE_PCH_H_

#include <stdint.h>

#define PCH_H				1
#define PCH_LP				2
#define PCH_UNKNOWN_SERIES		0xFF

#define PCIE_CLK_NOTUSED		0xFF
#define PCIE_CLK_LAN			0x70
#define PCIE_CLK_FREE			0x80

#endif
