#!/bin/bash
#
#
# !ATM VBOX 4.3 + Mavericks will not load vbox network drivers!
#
# `sh vboxload.sh` will automatically unload and then load the drivers
# `sh vboxload.sh load` will load drivers
# `sh vboxload.sh unload` will unload drivers
# 
# Note: you could also chmod +x vboxload.sh and execute `./vboxload.sh`
#

unload() {
    echo "Unloading Drivers..."
    kextstat | grep "org.virtualbox.kext.VBoxUSB" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxUSB
    kextstat | grep "org.virtualbox.kext.VBoxNetFlt" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxNetFlt
    kextstat | grep "org.virtualbox.kext.VBoxNetAdp" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxNetAdp
    kextstat | grep "org.virtualbox.kext.VBoxDrv" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxDrv
    echo "Drivers unloaded!"
}

load() {
    echo "Loading Drivers..."
    sudo kextload /Library/Extensions/VBoxDrv.kext -r /Library/Extensions/
    sudo kextload /Library/Extensions/VBoxNetFlt.kext -r /Library/Extensions/
    sudo kextload /Library/Extensions/VBoxNetAdp.kext -r /Library/Extensions/
    sudo kextload /Library/Extensions/VBoxUSB.kext -r /Library/Extensions/
    echo "Drivers Loaded!"
}

case "$1" in
        unload|remove)
                unload
                ;;
        load)
                load
                ;;
        *|reload)
                unload
                load
                ;;
esac