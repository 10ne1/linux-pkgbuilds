#!/bin/bash

export ARCH=arm
export CROSS_COMPILE=/home/adi/workspace/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
#export CROSS_COMPILE=/home/adi/workspace/raspberrypi-tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
export INSTALL_MOD_PATH=/home/adi/kernel_install
[ -f localversion-rt ] && export RTVERSION="$(cat localversion-rt)"
export KVERSION="$(cat Makefile | head -5 | tail -n 4 | awk '{print $3.}' |  tr '\n' '.' | sed 's/\.*$//; s/.-/-/')$RTVERSION"
export KERNEL="kernel-${KVERSION}"

mkdir -p $INSTALL_MOD_PATH
rm -rf $INSTALL_MOD_PATH/*

make -j6 zImage
make dtbs

mkdir -p $INSTALL_MOD_PATH/boot/overlays
#cp ./arch/arm/boot/zImage $INSTALL_MOD_PATH/boot/${KERNEL}.img
#cp ./arch/arm/boot/dts/bcm2837-rpi-3-b.dtb $INSTALL_MOD_PATH/boot/
./scripts/mkknlimg ./arch/arm/boot/zImage $INSTALL_MOD_PATH/boot/${KERNEL}.img
cp ./arch/arm/boot/dts/bcm2710-rpi-3-b.dtb $INSTALL_MOD_PATH/boot/
cp ./arch/arm/boot/dts/overlays/iqaudio-dacplus.dtbo $INSTALL_MOD_PATH/boot/overlays/

echo "root=/dev/mmcblk0p2 rw rootwait console=ttyAMA0,115200 console=tty1 selinux=0 plymouth.enable=0 smsc95xx.turbo_mode=N dwc_otg.lpm_enable=0 kgdboc=ttyAMA0,115200 elevator=noop loglevel=7 sdhci_bcm2708.enable_llm=0" > $INSTALL_MOD_PATH/boot/cmdline.txt

cat >$INSTALL_MOD_PATH/boot/config.txt <<EOL
disable_splash
gpu_mem=64
avoid_warnings=2
#hdmi_safe=1
#hdmi_force_hotplug=1
dtparam=audio=off
disable_audio_dither=1
device_tree=bcm2710-rpi-3-b.dtb
dtoverlay=iqaudio-dacplus,unmute_amp
kernel=${KERNEL}.img
EOL

pushd $INSTALL_MOD_PATH/
tar -c * | xz > "${KERNEL}.tar.xz"
popd
#mv ionel-kernel-new.tar.xz $INSTALL_MOD_PATH/
