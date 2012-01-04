#!/bin/bash
# minmal - no error checking
# simply roots the phone, installs su & superser.apk
#
platform=`uname`

# see bottom for history and thanks
if [ $platform != "Linux" -a $platform != "Darwin" ]; then
   err_exit "Unsupported Operating System: $platform"
fi

adb="./bin/adb.$platform"
fastboot="./bin/fastboot.$platform"

bionic_files="./bionic_files"

echo "Ready to root your Droid Bionic when you are."
echo ""
read -n1 -s -p "Press enter to continue. "
echo "  Waiting to connect to phone..."
echo ""

$adb wait-for-device
$adb wait-for-device
echo ""
echo "Attempting Exploit 1 of 2."
$adb shell "if [ -e /data/local/12m.bak ]; then rm /data/local/12m.bak; fi"
$adb shell mv /data/local/12m /data/local/12m.bak
$adb shell ln -s /data /data/local/12m
$adb reboot

echo "+--------------------------------------------------------------------------------+"
echo ""
echo "Rebooting the phone... "
echo "After the phone reboots, you may need to unlock it to continue."
echo ""

read -p "Press Enter when you are ready..."

$adb kill-server
$adb wait-for-device
$adb wait-for-device

echo ""
echo "Attempting Exploit 2 of 2."
$adb shell rm /data/local/12m
$adb shell mv /data/local/12m.bak /data/local/12m
$adb shell "if [ -e /data/local.prop.bak ]; then rm /data/local.prop.bak; fi"
$adb shell mv /data/local.prop /data/local.prop.bak
$adb shell 'echo "ro.sys.atvc_allow_netmon_usb=0" > /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_netmon_ih=0" > /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_res_core=0" >> /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_res_panic=0" >> /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_all_adb=1" >> /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_all_core=0" >> /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_efem=0" >> /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_bp_log=0" >> /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_ap_mot_log=0" >> /data/local.prop'
$adb shell 'echo "ro.sys.atvc_allow_gki_log=0" >> /data/local.prop'
$adb reboot

echo "+--------------------------------------------------------------------------------+"
echo ""
echo "Rebooting the phone..."
echo "After the phone reboots, you may need to unlock it to continue."
echo ""

read -p "Press Enter when you are ready..."

$adb kill-server
$adb wait-for-device
$adb wait-for-device

  root=$($adb shell id | grep uid=0)

if [ -z "$root" ]; then
    echo "*** ERROR - Phone may not have been rooted ***"
    echo "Try rebooting your phone and running the $0 again"
    exit 1;
fi

echo "+--------------------------------------------------------------------------------+"
echo ""
echo "Phone has been rooted for now. Do you want to PERMANENTLY root your phone, and,"
read -p "install su in /system/bin, /system and /osh? " ANSWER
case $ANSWER in
    Y | Yes | y | yes | YES ) echo "";;
    N | No | n | no | NO ) echo "";echo "Permanent root not done, you are root now, but, will lose it on a reboot.";exit;;
    *) echo "I didn't understand that, assuming you want permanent root.";;
esac

echo "+--------------------------------------------------------------------------------+"
echo "|                                                                                |"
echo "| Installing permanent root along with Superuser app                             |"
echo "|                                                                                |"
echo "+--------------------------------------------------------------------------------+"
$adb remount
$adb push su /system/bin/su
$adb install Superuser.apk
$adb shell chmod 4755 /system/bin/su
$adb shell chown system.system /data

exit 0

#
# Modified from original script by Framework, psouza4_, method by bliss
#
# http://vulnfactory.org/blog/2011/08/25/rooting-the-droid-3/
#
# Some things from Continuum one-click script by bubby323 (OSX support mainly)
#
# v7a - updated from psouza's v7, added check for already rooted, added check in case root fails
# v7b - attempt to better set up adb on OSX, removed Windows files from package, call for pc only mode
# v7c - rework platform detection/adb setup, handle case where system adb is installed
#       This is what I get for copying bubby323's script.  Sigh.
# v7d - document charge mode for mac, remove initial kill-server
# v7e - cleanup, more sanity checks - 20111004 crpeck
# v8a - ripped out the fastboot restore stuff - only roots now - crpeck
#       mod to allow passing in the directory it is running from so mac .command files can know where they are
#
# v3.0 - 20111014 - new version numbers to relfect the OneClick ones used by dhacker29
#        complete re-write from the ground up, most things moved to include.lib - function/definition library

#eof
