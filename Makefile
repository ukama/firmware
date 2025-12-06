# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2023-present, Ukama Inc.

include ../config.mk

CURMAKE := $(abspath $(firstword $(MAKEFILE_LIST)))
CURDIR := $(dir $(CURMAKE))

COREBOOTSRC = coreboot
AT91BOOTSTRAPBIN = at91bootstrap.bin
UBOOTBIN = u-boot.bin
COREBOOTBIN = coreboot.rom

#Output
ifndef ROOTFSPATH
override ROOTFSPATH = $(CURDIR)_ukamafs
endif
ROOTFSKPATH = $(ROOTFSPATH)/boot

# Config for Builds
AT91CONFIG := sama5d27_ukama_eksd1_uboot_defconfig
UBOOTCONFIG := sama5d27_ukama_anode_sdcard_defconfig
CBCONFIG := config.ukama_comv1_16mb
# Path to coreboot tool chain
COREBOOTXCCPATH := $(COREBOOTSRC)/util/crossgcc/xgcc
COREBOOTXCC := i386-elf-gcc

# Set build parameters based on targets
ifeq ($(TARGET),amplifier)
BUILDS  := at91bootstrap uboot
SRCDIRS := at91-bootstrap u-boot
override CC = arm-linux-gnueabihf-
endif

ifeq ($(TARGET),tower)
BUILDS  := coreboot
SRCDIRS := coreboot
endif

ifeq ($(TARGET),local)
BUILDS  := coreboot
SRCDIRS := coreboot
endif

define checkxcc
	@echo Checking for coreboot toolchain.
	$(shell if [ ! -f "$(COREBOOTXCCPATH)/bin/$(COREBOOTXCC)" ] ; then \
		(echo "$(MAKE) -C $(COREBOOTSRC) crossgcc-i386 CPUS=$(NPROCS)") \
	fi;)

endef

#make crossgcc-i386 CPUS=$(NPROCS)
#$(shell test -s $(COREBOOTXCC) || { echo "Coreboot toolcahin missing.Staring build for one"; \
#	cd $(COREBOOTXCC) && $(MAKE) crossgcc-i386 CPUS=$(NPROCS); })

.PHONY: subdirs $(BUILDS) coreboot grub clean distclean info

subdirs: $(BUILDS)

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
	(cp -v u-boot/$(UBOOTBIN) $(ROOTFSKPATH)/$@/$(UBOOTBIN) )

coreboot:
	@echo Building $@
	mkdir -p $(ROOTFSKPATH)/$@
	$(call checkxcc)
	(cd $@ && cp -v configs/config.ukama_comv1_16mb .config)
	$(MAKE) -j$(NPROCS) -C $@ 
	@echo Copy $@/build/$(COREBOOTBIN) $(ROOTFSKPATH)/$@/$(COREBOOTBIN)
	(cp -v $@/build/$(COREBOOTBIN) $(ROOTFSKPATH)/$@/$(COREBOOTBIN))

grub:
	@echo Building $@
	mkdir -p $(ROOTFSKPATH)/$@
	(cd $@ && ./bootstrap && ./configure --prefix=$(ROOTFSKPATH)/$@)
	$(MAKE) -j$(NPROCS) -C $@ ARCH=$(ARCH) CROSS_COMPILE=$(CC)
	$(MAKE) -j$(NPROCS) -C $@ install

clean :
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
	$(info [$@] Building $(TARGET) for $(ARCH) with $(CC) )
