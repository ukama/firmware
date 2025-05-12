# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2023-present, Ukama Inc.

include ../config.mk

CURMAKE := $(abspath $(firstword $(MAKEFILE_LIST)))
CURDIR := $(dir $(CURMAKE))

# Targets based on boards
COREBOOTSRC = coreboot
AMPLIFIER_NODE_TARGET = at91-bootstrap u-boot
TOWER_NODE_TARGET = $(COREBOOTSRC)
LOCAL_TARGET = $(COREBOOTSRC)

AT91BOOTSTRAPBIN = at91bootstrap.bin
UBOOTBIN = u-boot.bin
COREBOOTBIN = coreboot.rom

# Output
ifndef ROOTFSPATH
override ROOTFSPATH = $(CURPATH)_ukamafs
endif
ROOTFSKPATH = $(ROOTFSPATH)/boot

# Config for Builds
AT91CONFIG := sama5d27_ukama_eksd1_uboot_defconfig
UBOOTCONFIG := sama5d27_ukama_anode_sdcard_defconfig
CBCONFIG := config.ukama_comv1_16mb

# Path to coreboot toolchain
COREBOOTXCCPATH := $(COREBOOTSRC)/util/crossgcc/xgcc
COREBOOTXCC := i386-elf-gcc

# Set build parameters based on targets
ifeq ($(AMPLIFIER_NODE), $(TARGET_BOARD))
SRCDIRS = $(AMPLIFIER_NODE_TARGET)
override ARCH = $(ARCH_ARM)

# Use cross-compiler only if not running natively on ARM
UNAME := $(shell uname -m)
ifeq ($(findstring arm,$(UNAME)),)
    override CC = arm-linux-gnueabihf-
else
    override CC =
endif
endif

ifeq ($(TOWER_NODE), $(TARGET_BOARD))
override ARCH = $(ARCH_X86)
SRCDIRS = $(TOWER_NODE_TARGET)
endif

ifeq ($(LOCAL), $(TARGET_BOARD))
override ARCH = $(ARCH_X86)
SRCDIRS = $(LOCAL_TARGET)
endif

export CC
export ARCH

define checkxcc
	@echo Checking for coreboot toolchain.
	$(shell if [ ! -f "$(COREBOOTXCCPATH)/bin/$(COREBOOTXCC)" ] ; then \
		(echo "$(MAKE) -C $(COREBOOTSRC) crossgcc-i386 CPUS=$(NPROCS)") \
	fi;)
endef

.PHONY: subdirs $(SRCDIRS) info firmware

firmware:
ifeq ($(TARGET_BOARD),$(AMPLIFIER_NODE))
	$(MAKE) at91bootstrap
	$(MAKE) uboot
else ifeq ($(TARGET_BOARD),$(TOWER_NODE))
	$(MAKE) coreboot
else
	@echo "Nothing to build for TARGET=$(TARGET_BOARD). Valid options: $(AMPLIFIER_NODE), $(TOWER_NODE)"
endif

subdirs: $(SRCDIRS)

at91bootstrap:
	@echo Building $@
	mkdir -p $(ROOTFSKPATH)/$@
	$(MAKE) -j$(NPROCS) -C at91-bootstrap ARCH=$(ARCH) CROSS_COMPILE=$(CC) $(AT91CONFIG)
	$(MAKE) -j$(NPROCS) -C at91-bootstrap ARCH=$(ARCH) CROSS_COMPILE=$(CC)
	@echo Copy at91-bootstrap/build/binaries/$(AT91BOOTSTRAPBIN) $(ROOTFSKPATH)/$@/$(AT91BOOTSTRAPBIN)
	(cp -v at91-bootstrap/build/binaries/$(AT91BOOTSTRAPBIN) $(ROOTFSKPATH)/$@/$(AT91BOOTSTRAPBIN))

uboot:
	@echo Building $@
	mkdir -p $(ROOTFSKPATH)/$@
	$(MAKE) -s -j$(NPROCS) -C u-boot ARCH=$(ARCH) CROSS_COMPILE=$(CC) $(UBOOTCONFIG)
	$(MAKE) -j$(NPROCS) -C u-boot ARCH=$(ARCH) CROSS_COMPILE=$(CC)
	@echo Copy u-boot/$(UBOOTBIN) $(ROOTFSKPATH)/$@/$(UBOOTBIN)
	(cp -v u-boot/$(UBOOTBIN) $(ROOTFSKPATH)/$@/$(UBOOTBIN))

coreboot:
ifeq ($(TARGET_BOARD),$(TOWER_NODE))
	@echo Building $@
	mkdir -p $(ROOTFSKPATH)/$@
	$(call checkxcc)
	(cd $@ && cp -v configs/$(CBCONFIG) .config)
	$(MAKE) -j$(NPROCS) -C $@
	@echo Copy $@/build/$(COREBOOTBIN) $(ROOTFSKPATH)/$@/$(COREBOOTBIN)
	(cp -v $@/build/$(COREBOOTBIN) $(ROOTFSKPATH)/$@/$(COREBOOTBIN))
else
	@echo "Skipping coreboot: not required for TARGET=$(TARGET_BOARD)"
endif

grub:
	@echo Building $@
	mkdir -p $(ROOTFSKPATH)/$@
	(cd $@ && ./bootstrap && ./configure --prefix=$(ROOTFSKPATH)/$@)
	$(MAKE) -j$(NPROCS) -C $@ ARCH=$(ARCH) CROSS_COMPILE=$(CC)
	$(MAKE) -j$(NPROCS) -C $@ install

clean:
	@echo Cleaning firmware build.
	rm -rf $(ROOTFSKPATH)
	for dir in $(SRCDIRS); do \
		$(MAKE) -j$(NPROCS) -C $$dir -f Makefile $@; \
	done

distclean:
	@echo DistClean started for firmware.
	for dir in $(SRCDIRS); do \
		$(MAKE) -C $$dir -f Makefile $@; \
	done
	rm -rf $(COREBOOTXCCPATH)
	rm -rf $(ROOTFSPATH)
	rm -rf *.img

info:
	$(info [$@] Building $(TARGET_BOARD) for $(ARCH) with $(CC) )
