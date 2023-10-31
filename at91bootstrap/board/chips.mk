ifeq ($(CONFIG_AT91SAM9260), y)
CPPFLAGS += -DCONFIG_AT91SAM9260
ASFLAGS += -DCONFIG_AT91SAM9260
endif

ifeq ($(CONFIG_AT91SAM9261), y)
CPPFLAGS += -DCONFIG_AT91SAM9261
ASFLAGS += -DCONFIG_AT91SAM9261
endif

ifeq ($(CONFIG_AT91SAM9263), y)
CPPFLAGS += -DCONFIG_AT91SAM9263
ASFLAGS += -DCONFIG_AT91SAM9263
endif

ifeq ($(CONFIG_AT91SAM9G10), y)
CPPFLAGS += -DCONFIG_AT91SAM9G10
ASFLAGS += -DCONFIG_AT91SAM9G10
endif

ifeq ($(CONFIG_AT91SAM9G20), y)
CPPFLAGS += -DCONFIG_AT91SAM9G20
ASFLAGS += -DCONFIG_AT91SAM9G20
endif

ifeq ($(CONFIG_AT91SAM9RL), y)
CPPFLAGS += -DCONFIG_AT91SAM9RL
ASFLAGS += -DCONFIG_AT91SAM9RL
endif

ifeq ($(CONFIG_AT91SAM9G45), y)
CPPFLAGS += -DCONFIG_AT91SAM9G45
ASFLAGS += -DCONFIG_AT91SAM9G45
endif

ifeq ($(CONFIG_AT91SAM9XE), y)
CPPFLAGS += -DCONFIG_AT91SAM9XE
ASFLAGS += -DCONFIG_AT91SAM9XE
endif

ifeq ($(CONFIG_AT91SAM9X5), y)
CPPFLAGS += -DCONFIG_AT91SAM9X5
ASFLAGS += -DCONFIG_AT91SAM9X5
endif

ifeq ($(CONFIG_AT91SAM9N12), y)
CPPFLAGS += -DCONFIG_AT91SAM9N12
ASFLAGS += -DCONFIG_AT91SAM9N12
endif

ifeq ($(CONFIG_SAM9X60), y)
CPPFLAGS += -DCONFIG_SAM9X60
ASFLAGS += -DCONFIG_SAM9X60
endif

ifeq ($(CONFIG_SAMA5D3X), y)
CPPFLAGS += -DCONFIG_SAMA5D3X
ASFLAGS += -DCONFIG_SAMA5D3X
endif

ifeq ($(CONFIG_SAMA5D4), y)
CPPFLAGS += -DCONFIG_SAMA5D4
ASFLAGS += -DCONFIG_SAMA5D4
endif

ifeq ($(CONFIG_SAMA5D2), y)
CPPFLAGS += -DCONFIG_SAMA5D2
ASFLAGS += -DCONFIG_SAMA5D2
endif

ifeq ($(CONFIG_SAMA7G5), y)
CPPFLAGS += -DCONFIG_SAMA7G5
ASFLAGS += -DCONFIG_SAMA7G5
endif

ifeq ($(CONFIG_CORE_ARM926EJS), y)
CPPFLAGS += -mcpu=arm926ej-s -mtune=arm926ej-s -mfloat-abi=soft
ASFLAGS += -mcpu=arm926ej-s -mtune=arm926ej-s -mfloat-abi=soft
endif

ifeq ($(CONFIG_CORE_CORTEX_A5), y)
CPPFLAGS += -mcpu=cortex-a5 -mtune=cortex-a5
ASFLAGS += -mcpu=cortex-a5 -mtune=cortex-a5
endif

ifeq ($(CONFIG_CORE_CORTEX_A7), y)
CPPFLAGS += -mcpu=cortex-a7 -mtune=cortex-a7
ASFLAGS += -mcpu=cortex-a7 -mtune=cortex-a7
endif

