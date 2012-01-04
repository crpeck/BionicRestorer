#!/bin/bash
#
# root and then foreveroot a bionic works with 5.5.893
# this is driven by the main menu script
# see bottom for history and thanks

### include definitions and functions library
if [ -r bin/includes.lib ]; then
  . bin/includes.lib
else
  echo "ERROR missing file bin/includes.lib"
  exit 1
fi

# always set the trap for a Ctrl-C
trap adios_mofo INT TERM 

# sanity checks
check_required_files "$bin_required_files"
check_required_files "$root_required_files"

print_dashes

# intro
cat <<_EOF
Get ready to root, install su, Superuser.apk, busybox
and apply the ForeverRoot hack.

NOTE: This does NOT work on v5.9.901.

Make sure you have done the following:
 1. On your Bionic under Menu -> Settings -> Applications-> Development
    USB Development must be checked/enabled.
 2. The USB cable must be plugged into your Bionic and PC.
_EOF

if [ $platform = "Linux" ]; then
    echo " 3. Set your USB connection to 'PC Mode'(Linux) on your Bionic."
    echo "      (if it hangs, try setting it to 'Charge Only')"
    echo ""
    echo "Just remember, if you get asked for a password it's your Linux one."
else
    echo " 3. Set your USB connection to 'Charge Only' mode(Mac) on your Bionic"
    echo "      (if it hangs, try setting it to 'PC Mode')"
    echo ""
    echo "Just remember, if you get asked for a password, it's your Mac one."
fi

echo ""
echo "Ready to root your Droid Bionic when you are."
read -n1 -s -p "Press enter to continue. "
echo "  Waiting to connect to phone..."
echo ""

# loop until bionic is in correct state for adb to talk to it
check_adb_state

# just be sure it's ready :)
sudo $adb wait-for-device

get_build_version
echo ""
echo ""
if [ $build_version ==  "ro.build.version.full=Blur_Version.5.9.901.XT875.Verizon.en.US" ]; then
  echo "$bold NOTE: Your Bionic is running: $build_version $nobold"
  echo "This version of zergRush cannot root it, sorry."
  exit 1
else
  echo "$bold NOTE: Your Bionic is running: $build_version $nobold"
fi

echo "Attempting zergRush root exploit."
sudo $adb shell "rm /data/local/tmp/*" > /dev/null
sudo $adb push ${bionic_files}/zergRush /data/local/zergRush
sudo $adb shell chmod 755 /data/local/zergRush
sudo $adb shell /data/local/zergRush
sudo $adb shell "rm /data/local/tmp/*" > /dev/null

check_adb_state
sudo $adb wait-for-device

# check for root
root=$(sudo $adb shell id | grep uid=0)
if [ -z "$root" ]; then
    echo "*** ERROR - Phone may not have been rooted ***"
    echo "Try rebooting your phone and running this again to root it."
    echo "If you have updated to v5.9.901, this will NOT root it."
    exit 1;
fi

echo ""
echo "Installing permanent root (/system/bin/su) along with Superuser app."
echo "If you are staying with this ROM, run Superuser and check for updates"

sudo $adb remount
sudo $adb push ${bionic_files}/su /system/xbin/su
sudo $adb push ${bionic_files}/su /system/bin/su
sudo $adb push ${bionic_files}/busybox /system/xbin/busybox
sudo $adb shell chmod 4755 /system/xbin/su
sudo $adb shell chmod 4755 /system/bin/su
sudo $adb shell chmod 755 /system/xbin/busybox
sudo $adb shell /system/xbin/busybox --install -s /system/xbin/
sudo $adb install ${bionic_files}/Superuser.apk

# ForeverRoot hack
sudo $adb shell cat /system/bin/mount_ext3.sh | grep -q "chmod [46]755 /system/bin/su"
if [ $? -eq 0 ]; then
  echo ""
  echo "$bold It appears that the ForeverRoot hack was already installed. $nobold"
  echo ""
  read -n1 -s -p "Press enter to continue. "
  exit 0
fi

echo ""
echo "Applying ForeverRoot hack (thanks P3!)"
sudo $adb pull /system/bin/mount_ext3.sh ${bionic_files}/mount_ext3.sh.orig
if [ -f ${bionic_files}/mount_ext3.sh.orig ]; then
  cp -f ${bionic_files}/mount_ext3.sh.orig ${bionic_files}/mount_ext3.sh
else
  err_exit "Unable to create ${bionic_files}/mount_ext3.sh - cannot apply ForeverRoot hack"
fi
echo "NOTE: mount_ext3.sh backed up to ${bionic_files}/mount_ext3.sh.orig on your PC"

# tack this stuff onto the end of the mount_ext3.sh file
echo "# 4everRoot hack thanks p3 and crpeck" >> ${bionic_files}/mount_ext3.sh
echo "chmod 6755 /system/bin/su" >> ${bionic_files}/mount_ext3.sh
echo "chmod 6755 /system/xbin/su" >> ${bionic_files}/mount_ext3.sh
sudo $adb push ${bionic_files}/mount_ext3.sh /system/bin/mount_ext3.sh
sudo $adb shell chmod 755 /system/bin/mount_ext3.sh
sudo $adb shell chown root.shell /system/bin/mount_ext3.sh

# check for foreverroot
sudo $adb shell cat /system/bin/mount_ext3.sh | grep -q "chmod [46]755 /system/bin/su"
if [ $? -eq 0 ]; then
  echo "ForeverRoot hack installed successfully."
  echo ""
  read -n1 -p "Press enter to continue. "
  exit 0
else
  echo "$bold ForeverRoot hack may not be in place, check it! $nobold"
  echo ""
  read -n1 -p "Press enter to continue. "
  exit 1
fi

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
# v1.0 - 20111014 - new version numbers to relfect the OneClick ones used by dhacker29
#        complete re-write from the ground up, most things moved to include.lib - function/definition library
# v1.1 - 20120103 - checks build version of Bionic before attempting root - crpeck
#         moved alot of things around, code cleanup, etc - crpeck
#eof
