# PYNQ-Z1 Framebuffer

## Overview
This is a frame buffer driver module for PYNQ-Z1 board with the base overlay,
which enables to use applications which supports kernel framebuffer device to render its graphical outputs like X Window System on PYNQ-Z1 board.

[日本語版](readme_ja.md)

## Requirements
* A PYNQ-Z1 board or equivalent.
* PYNQ-Z1 prebuilt image released at Feb 2017 or later.
* An environment which can compile linux kernel for ARM.
    * PYNQ-Z1 board with prebuilt image also can run compile linux kernel by itself, though it takes very long time.

* Device tree compiler (dtc) command
    * If you are using Ubuntu, you can install this command by installing [`device-tree-compiler`](https://launchpad.net/ubuntu/+source/device-tree-compiler) package
    
    ```
    sudo apt-get install device-tree-compiler
    ```

* A display which supports the resolutions listed below:
    * 640x480 @ 60Hz
    * 800x480 @ 60Hz
    * 800x600 @ 60Hz
    * 1280x720 @ 60Hz
    * 1280x1024 @ 60Hz
    * 1920x1080 @ 60Hz
    * Other display resolutions will be supported in future release.

## Install
1. clone this repository into somewhere.
  
    ```
    git clone https://github.com/ciniml/pynqz1fb
    ```

2. Download Linux kernel source code from Xilinx Linux kernel source repository on GitHub. 
    
    ```
    wget https://github.com/Xilinx/linux-xlnx/archive/xilinx-v2016.4-sdsoc.tar.gz
    tar zxf xilinx-v2016.4-sdsoc.tar.gz
    ```

3. Run `make` on the top directory of `pynqz1fb` working tree with kernel source path.
    
    ```
    cd pynqz1fb
    KERNEL_SRC_ROOT=`pwd`/../linux-xlnx-v2016.4-sdsoc make all -j8
    ```

4. After a few minutes, `pynqz1fb.ko` is generated in the `pynqz1fb` directory.

5. Modify device tree file `pynqz1.dts` if needed.
    * Some settings including screen width and height is stored in the device tree.
    * Modify [`width`](https://github.com/ciniml/pynqz1fb/blob/master/pynqz1.dts#L452) and [`height`](https://github.com/ciniml/pynqz1fb/blob/master/pynqz1.dts#L454) field for the resolution of your display device.
    * The default setting is for displays with 800x480 resolution, which is my HDMI display's resolution.
6. Compile modified device tree source (\*.dts) to device tree binary (\*.dtb) format.
    
    ```
    dtc -I dts -O dtb -o devicetree.dtb pynqz1.dts
    ```

7. Copy `devicetree.dtb` into the boot partition of your SD card.
    * Note that you should backup the original `devicetree.dtb` to somewhere.

8. Turn on your PYNQ-Z1 board and connect a HDMI display to its HDMI out port.

9. Copy `pynqz1fb.ko` to PYNQ-Z1 board via Jupiter notebook.

10. Open a terminal in the Jupyter notebook.

11. Move to the Jupyter notebook root directory.
    
    ```
    cd /home/xilinx/jupyter-notebook
    ```

12. Insert the kernel module with `insmod` command.
    
    ```
    insmod ./pynqz1fb.ko
    ```

13. Now you can see a prompt is shown in your display.

14. If you cannot see anything, please confirm that the parameters in device tree is correct or not.
    
    * Are `width` and `height` parameters correct? 

## License
GPL whose version is the same with the Linux kernel source because this driver is based on `simplefb.c` in the linux kernel source.
