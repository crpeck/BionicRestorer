#!/bin/bash
#
# copy the file Blur_Version.5.9.901.XT875.Verizon.en.US.zip to /sdcard-ext

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
check_required_files "${bionic_files}/Blur_Version.5.9.901.XT875.Verizon.en.US.zip"

print_dashes

# intro
cat <<_EOF
Ready to copy Blur_Version.5.9.901.XT875.Verizon.en.US.zip to your Bionic

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
echo ""
read -n1 -s -p "Press enter to continue. "
echo "  Waiting to connect to phone..."
echo ""

# loop until bionic is in correct state for adb to talk to it
check_adb_state

# just be sure it's ready :)
$adb wait-for-device

echo ""

echo "Copying file now..."
INSTALLTXT=`$adb push ${bionic_files}/Blur_Version.5.9.901.XT875.Verizon.en.US.zip /mnt/sdcard/Blur_Version.5.9.901.XT875.Verizon.en.US.zip`
echo $INSTALLTXT | grep -q FAILED
if [ $? -eq 1 ]; then
  echo "Blur_Version.5.9.901.XT875.Verizon.en.US.zip copied to /mnt/sdcard-ext"
else
  echo "*** Error copying file"
  echo ${INSTALLTXT}
  echo ""
fi

read -n1 -s -p "Press enter to continue. "

exit
