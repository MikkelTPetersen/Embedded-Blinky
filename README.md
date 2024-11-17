This is a embedded zig / arduino project. The goal of this project is to write custom firmware for the arduino to perform simple tasks. For this project, we start out by making a LED blink! Did we mention that everything will be written in zig, so there is no need for the arduino software. 

We hope that you can learn something from our project! :)

-----------------------
Software 
-----------------------
- zig version 0.13 (Required) 
- Software to flash your MCU. We use avrdude

-----------------------
How to use!
-----------------------
- First ensure that your arduino is picked up by your computer. This can be done with `lsusb` command on Linux.
- Then locate the usb port that the MCU is plugged into. This can be done with `dmesg | grep tty`. Look for either of these outputs:
```
/dev/ttyS0
/dev/ttyS1
/dev/ttyACM0

```
- Look up the MCU type - Ours is the ATmega328P, so the corresponding partno is: m328p.
- Lastly read the flash on the MCU, and store it in flash.bin, using avrdude like so:
`avrdude -c arduino -p m328p -P /dev/ttyACM0 -U flash:r:flash.bin:r`
- The output can be read using hexddump like so:
`hexdump -C flash.bin | more`

We will aim to keep this README up to date with the project. 

-----------------------
NEW FEATURE
-----------------------
You are now able to flash the MCU while building the project with `zig build flash`. It targets ttyAMC0 by default, but can be changed with additional input arguments. 
You are also able to read the content of the chip using `zig build read`. It produces a flash.bin file in your current folder. 
