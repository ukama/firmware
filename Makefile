# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2023-present, Ukama Inc.

include ../config.mk

CUR_MAKE := $(abspath $(firstword $(MAKEFILE_LIST)))
CUR_DIR := $(dir $(CUR_MAKE))

# Targets based on boards
AMPLIFIER_TARGET = at91-bootstrap u-boot
AT91BOOTSTRAPBIN = at91bootstrap.bin
UBOOTBIN = u-boot.bin

ROOTFS_KPATH = $(CUR_DIR)build

# Config for Builds
AT91_CONFIG := sama5d27_ukama_emmc_uboot_defconfig
UBOOT_CONFIG := sama5d27_ukama_anode_emmc_defconfig

# Detect target board and set appropriate variables
ifeq ($(AMPLIFIER_NODE), $(TARGET_BOARD))
	override CC   = arm-linux-gnueabihf-
	override HOST = arm-linux-gnueabihf
	override ARCH = arm
	SRC_DIRS = $(AMPLIFIER_TARGET)
endif

ifeq ($(TOWER_NODE), $(TARGET_BOARD))
	override ARCH   = $(ARCH_X86_64)
	override HOST   = x86_64-linux-musl
endif

ifeq ($(ACCESS_NODE), $(TARGET_BOARD))
	override CC     = aarch64-linux-gnu-gcc
	override HOST   = aarch64-linux-gnu
	override ARCH   = arm64
endif

ifeq ($(LOCAL), $(TARGET_BOARD))
	override CC     = gcc
	override ARCH   = $(ARCH_X86_64)
	override HOST   = $(shell gcc -dumpmachine)
	SRC_DIRS = $(LOCAL_TARGET)
endif

# Ensure SRC_DIRS is set, otherwise use all subdirectories
SRC_DIRS ?= $(wildcard */)

$(info TARGET_BOARD = $(TARGET_BOARD) SRC_DIRS = $(SRC_DIRS))

.PHONY: $(SRC_DIRS) info clean distclean

subdirs: info $(SRC_DIRS)

at91-bootstrap:
	@echo "Building $@"
	mkdir -p $(ROOTFS_KPATH)/$@ && \
	$(MAKE) -j$(NPROCS) -C at91-bootstrap ARCH=$(ARCH) CROSS_COMPILE=$(CC) $(AT91_CONFIG) && \
	$(MAKE) -j$(NPROCS) -C at91-bootstrap ARCH=$(ARCH) CROSS_COMPILE=$(CC)
	@echo "Copying at91-bootstrap/build/binaries/$(AT91BOOTSTRAPBIN) to $(ROOTFS_KPATH)/$@/"
	cp -v at91-bootstrap/build/binaries/$(AT91BOOTSTRAPBIN) $(ROOTFS_KPATH)/$@/$(AT91BOOTSTRAPBIN)

u-boot:
	@echo "Building $@"
	mkdir -p $(ROOTFS_KPATH)/$@ && \
	$(MAKE) -s -j$(NPROCS) -C u-boot ARCH=$(ARCH) CROSS_COMPILE=$(CC) $(UBOOT_CONFIG) && \
	$(MAKE) -j$(NPROCS) -C u-boot ARCH=$(ARCH) CROSS_COMPILE=$(CC)
	@echo "Copying u-boot/$(UBOOTBIN) to $(ROOTFS_KPATH)/$@/"
	cp -v u-boot/$(UBOOTBIN) $(ROOTFS_KPATH)/$@/$(UBOOTBIN)

clean:
	@echo "Cleaning firmware build."
	rm -rf $(ROOTFS_KPATH)
	ifneq ($(strip $(SRC_DIRS)),)
		for dir in $(SRC_DIRS); do \
			$(MAKE) -j$(NPROCS) -C $$dir -f Makefile $@; \
		done
	endif

distclean:
	@echo "DistClean started for firmware."
	ifneq ($(strip $(SRC_DIRS)),)
		for dir in $(SRC_DIRS); do \
			$(MAKE) -C $$dir -f Makefile $@; \
		done
	endif
	rm -rf $(ROOTFS_KPATH)
	rm -rf *.img

info:
	@echo "================================="
	@echo " Building Info "
	@echo "---------------------------------"
	@echo " Target Board  : $(TARGET_BOARD)"
	@echo " Source Dirs   : $(SRC_DIRS)"
	@echo " Architecture  : $(ARCH)"
	@echo " Compiler      : $(CC)"
	@echo "================================="

