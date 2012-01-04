#!/bin/bash
# v1.2 - got it down to requiring root on bionic to one-click - crpeck
#
# THANKS P3DROID!
#
# forever root a bionic
# this is driven by the main menu script

### include definitions and functions library
if [ -r bin/includes.lib ]; then
  . bin/includes.lib
else
  echo "ERROR missing file lib/includes.lib"
  exit 1
fi

# always set the trap for a Ctrl-C
trap adios_mofo INT TERM 

if [ $DEBUG -eq 1 ]; then
  echo "Sorry cannot run in debug mode."
  exit 1
fi

# sanity checks
check_required_files "${bionic_files}/do_MR4everRoot.file"

print_dashes

# intro
cat <<_EOF
Ready to install the Forever Root hack.

Make sure you have done the following:
 1. On your Bionic under Menu -> Settings -> Applications-> Development
    USB Development must be checked/enabled.
 2. The USB cable must be plugged into your Bionic and PC.
_EOF

if [ $platform = "Linux" ]; then
    echo " 3. Set your USB connection to 'PC Mode'(Linux) on your Bionic."
    echo "      (if it hangs, try setting it to 'Charge Only')"
else
    echo " 3. Set your USB connection to 'Charge Only' mode(Mac) on your Bionic"
    echo "      (if it hangs, try setting it to 'PC Mode')"
fi

echo "Ready to forever root your Droid Bionic when you are."
echo ""
read -n1 -s -p "Press enter to continue. "
echo "  Waiting to connect to phone..."
echo ""

# loop until bionic is in correct state for adb to talk to it
check_adb_state

# just be sure it's ready :)
$adb wait-for-device

# check to see if it's already there
# using regexp pattern [46]755 to match 6755 or 4755
$adb shell cat /system/bin/mount_ext3.sh | grep -q "chmod [46]755 /system/bin/su"
if [ $? -eq 0 ]; then
  echo ""
  echo "$bold Forever root hack was already installed. $nobold"
  echo "If not, you need to do it some other way. $nobold"
  echo ""
  read -n1 -s -p "Press enter to continue. "
  exit 1
fi

echo "Make sure your phone is awake, and, then you need to"
echo "Allow SuperUser access when prompted on the screen"
read -n1 -s -p "Press enter to continue. "

# No need for this, check is in the script run on the Bionic now
# test for rooted phone
#root=$($adb shell su -c "id" | grep uid=0)
#if [ -z "$root" ]; then
#    echo "*** ERROR - Phone may not have been rooted ***"
#    echo "Try rebooting your phone and running this again to root it."
#    exit 1;
#fi

print_dashes

# copy our shell script over and execute it there as root
$adb push ${bionic_files}/do_MR4everRoot.file /tmp/do_MR4everRoot.sh
if [ $? -ne 0 ]; then
  echo "*** ERROR trying to copy file to Bionic"
  echo "${bionic_files}/do_MR4everRoot.file /tmp/do_MR4everRoot.sh"
  err_exit "4everRoot.sh file copy failure"
fi

echo ""
echo "Applying Forever Root hack (thanks P3!)"
echo "Watch your phone for a Superuser popup"
$adb shell su -c "sh /tmp/do_MR4everRoot.sh"
$adb shell cat /system/bin/mount_ext3.sh | grep -q "chmod [46]755 /system/bin/su"
if [ $? -eq 0 ]; then
  echo "Forever root hack installed successfully."
  echo ""
else
  echo "*** ERROR Forever root hack may not be installed. ***"
  echo ""
fi

read -n1 -p "Press enter to continue. "
exit 0

#
#eof
