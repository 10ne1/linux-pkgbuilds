#!/bin/bash

export ARCH=arm
export CROSS_COMPILE=/home/adi/workspace/raspberrypi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
export INSTALL_MOD_PATH=/home/adi/kernel_install
export KERNEL=kernel7

mkdir -p $INSTALL_MOD_PATH
rm -rf $INSTALL_MOD_PATH/*

make -j6 zImage
make -j6 modules
make dtbs
make modules_install

mkdir -p $INSTALL_MOD_PATH/boot
./scripts/mkknlimg ./arch/arm/boot/zImage $INSTALL_MOD_PATH/boot/$KERNEL.img
cp ./arch/arm/boot/dts/*.dtb $INSTALL_MOD_PATH/boot/
cp -r ./arch/arm/boot/dts/overlays $INSTALL_MOD_PATH/boot
pushd $INSTALL_MOD_PATH/
tar -c * | xz > ionel-kernel-new.tar.xz
popd
#mv ionel-kernel-new.tar.xz $INSTALL_MOD_PATH/
