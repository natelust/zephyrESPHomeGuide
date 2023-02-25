This is a basic guide to get get esphome with zephyr support installed. This is intended for test and
development, and should be considered alpha quality. It has been working fine for me, but use at your own
risk. There is minimal risk to a HomeAssistant installation (mostly it might not work) but is a possible risk
to your state of mind while trying to get it to work. Side effects may include frustration and obsessive
behaviors in the development process.

Requires
--------
* A GO installation (with the go workspace in your path)
* Python (tested on python 3.10)
* Cmake and a compiler

* Run the installation script. This should create a directory called ESPHomeZephyr inside whatever directory
  it is run in. It will create (and activate) a python environment at ESPHomeZephyr/zephyrenv that will need
  to be activated any time you intend to use this software.
* Activate an Openthread Border router. This is easiest if you are running HA OS, as you can install the
  development addon (what I am currently testing with). If you are not using HAOS, you can install one with
  this guide: https://openthread.io/guides/border-router. I have used this in the past.
* Whatever hardware this will run on will need a network co-processor (this guide will be expanded in the
  future to talk more about this.
* Create a network on the border router on the 'Form' page. Make note of all the details before leaving the
  page (network name, key, channel, etc)
* Create a new ESPHome yaml file that looks something like https://community.home-assistant.io/t/announcement-esphome-running-on-adafruit-52840-over-thread-mesh-networking-using-zephyrrtos/363712/2#what-does-this-look-like-3
* Substitute in the absolute path to the ESPHomeZephyr/zephyrproject director in the yaml as outlined above
* Compile your yaml using eshopme compile `your_yaml_file`.yaml
* Plug your board in and put it in bootloader mode (single reset press for xiao, double for adafruit feather)
* run esphome upload `your_yaml_file`.yaml
* It will ask you to select the mount point that corresponds to the UF2 volume mounted on your system
* The program will copy over the zephyr bootloader onto your device, which will then reboot
* the upload command should wait a few seconds and then upload the actual esphome zephyr application to the
  board over the usb connection. If it fails for some reason, unplug and plug in the board again. Do not put
  it in bootloader flash mode, the zephyr bootloader should boot itself and wait about 5 seconds for you to
  run the upload command again before attempting to continue to boot, so you might want the command queued up.
  Using upload in the first few seconds after the device is plugged in causes the esphome application to be
  written directly into the first image slot, and it will be the one the one the bootloader goes it. After
  the first time the esphome application is installed, you can perform a usb upload at any time as the
  application listens for it. When flashing while the application is running it will write into the second
  slot, reboot the device, and then the primary slot will be updated to the new image. If the device is up and
  running on the thread network, the upload command will show an address you can flash over the network to
  (again after the first flash of the esphome program) IF the computer you are flashing from has an IPV6
  route to the device (via the border router). This will be expanded with more info in the future, for now
  google adding routes if you dont know.
* Add the device to HomeAssistant, it does not seem to discover it automatically, so you will have to go in
  and manually select the addon and put in your devicename.local address, and it should ask for the
  password/api key
* beware, if your border router goes down for a long time one of your devices may take over the leadership
  role for a while, and if you bring your router back up it sometimes joins not as the leader (as the network
  is supposed to be self healing. It is supposed to eventually fix that, but I find if I power all devices
  down, turn the router back on, and then all the devices it is fixed right away.
