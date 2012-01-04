#!/bin/bash
#
# install the cheesecake app

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
check_required_files "${bionic_files}/cheesecakev2.apk"

print_dashes

# intro
cat <<_EOF
Ready to install cheesecake v2 on your Bionic

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
echo "If you want to update to the latest OTA (Over The Air) unreleased update this"
echo "will install the apk.  Launch the app and run the first menu option and then"
echo "the second one until you find a server offering the updates."
echo "NOTE: You must be on the complete stock full bloat ROM for this to work"
echo "NOTE: Some versions require you to be on the last prior update to recieve them"
echo ""
echo "Ready to install cheesecake v2 app on your Droid Bionic when you are."
echo ""
read -n1 -s -p "Press enter to continue. "
echo "  Waiting to connect to phone..."
echo ""

# loop until bionic is in correct state for adb to talk to it
check_adb_state

# just be sure it's ready :)
$adb wait-for-device

echo ""

INSTALLTXT=`$adb install ${bionic_files}/cheesecakev2.apk 2>/dev/null`
echo $INSTALLTXT | grep -q FAILED
if [ $? -eq 1 ]; then
  echo "cheesecake v2 installed"
else
  echo "*** Error installing cheesecake v2"
  echo ${INSTALLTXT}
  echo ""
fi

read -n1 -s -p "Press enter to continue. "

exit
