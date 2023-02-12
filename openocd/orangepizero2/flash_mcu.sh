#!/bin/bash
#systemctl stop klipper
POWER=8
gpio mode $POWER out
gpio write $POWER 1


SRST=14
gpio mode $SRST out

# Set RESET PIN value to LOW
gpio write $SRST 0

cd klipper
make
cd ..

sudo openocd -f wiringop.cfg -f target/stm32f1x.cfg -c "sysfsgpio srst_num $SRST" -c "program klipper/out/klipper.bin verify 0x08000000" -c exit
# Workaround to set PIN state to OFF
#gpio mode $SRST in

# Power OFF/ON MCU
#gpio mode 8 out
#gpio toggle 8
#sleep 10s
#gpio toggle 8

#systemctl start klipper

#reboot