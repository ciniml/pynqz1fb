.PHONY: all clean

SRC_DIR := $(shell pwd)
BUILD_DIR := $(shell pwd)/kernel-build

MODULES = pynqz1fb.o

obj-m := $(MODULES)

ARCH = arm
CROSS_COMPILE = arm-linux-gnueabihf-

pynqz1fb.ko: pynqz1fb.c pynqz1fb.h
	mkdir -p $(BUILD_DIR)
	cp config.pynq $(BUILD_DIR)/.config
	cp Module.symvers.pynq $(BUILD_DIR)/Module.symvers
	cd $(BUILD_DIR)
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNEL_SRC_ROOT) O=$(BUILD_DIR) oldconfig
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNEL_SRC_ROOT) O=$(BUILD_DIR) prepare
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNEL_SRC_ROOT) O=$(BUILD_DIR) modules_prepare
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KERNEL_SRC_ROOT) O=$(BUILD_DIR) M=$(SRC_DIR) modules

all: pynqz1fb.ko

clean:
	@$(RM) -rf $(BUILD_DIR)
	@$(RM) *.o *.ko *.mod.c *.mod.o 
	@$(RM) Module.symvers modules.order
	@$(RM) .pynqz1fb.*.cmd
	@$(RM) -rf .tmp_versions