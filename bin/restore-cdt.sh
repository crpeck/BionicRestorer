#!/bin/bash
# restore-cdt.sh - restores cdt.bin image from 5.9.901 files
# if you went to 5.9.901 then attempt to flash back to 5.5.893
# the cdt.bin image file will NOT flash correctly

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
check_required_files "$restore_required_files"

print_dashes
cat <<_EOF

This script will:
-restore cdt.bin on your phone to 5.9.901
 (from VRZ_XT875_5.5.893.XT875.Verizon.en.US_CFC_01.xml.zip)

              DANGER, DANGER, WILL ROBINSON!!!!!!!

Make sure that the battery level on your Bionic is at least at 25%, if
it drops too low, the phone WILL REFUSE TO ALLOW THIS TO WORK!!!
Should this happen you will have a pretty brick until you can find a
charged battery somewhere.

_EOF
read -n1 -p "Press Enter to continue "

# warning
cat <<_EOF

              THIS WILL WIPE YOUR PHONE
It restores from the Offical 5.5.893 system image and wipes your data    

Make sure you have done the following:
 1. Remove USB Cable from phone
 2. Power off your phone.
 3. Hold down the Volume down button and push power to enter AP Fastboot mode
 4. Plug the USB cable into your phone and computer 
NOTE: If you are prompted for a password, enter YOUR PASSWORD
      Nothing will print while you enter your password.

_EOF

# preload sudo to rule out that as an issue
preload_sudo

read -n1 -p "Press enter when you are ready. "
sudo $adb kill-server > /dev/null 2>&1
echo ""
print_dashes
echo "Here we go, I don't stop on errors, once it starts there is no stopping"
my_fastboot reboot-bootloader
my_fastboot erase cache
my_fastboot flash cdt.bin cdt.bin.901
echo ""
print_dashes

echo "Rebooting your phone now, cdt.bin restore complete"
echo "NOTE: If this takes a long time, just go ahead and power off/on your Bionic"
my_fastboot reboot

if [ $? -ne 0 ]; then
  echo ""
  echo "Possible issue rebooting your phone. You may need to power it off and"
  echo "on manually."
  echo ""
fi

# print out a message to chill out
cat <<_EOF

 In the immortal words from Hitchhikers Guide to the Galaxy:
_EOF

echo $bold; print_out "                           DON'T PANIC!";echo $nobold
 
cat <<_EOF 
 Relax, the reboot takes a long time. DON'T PANIC! You do have your towel
 don't you?  Why a towel? http://www.imdb.com/title/tt0371724/faq

 If you are stuck in the AP Fastboot screen for more than a few minutes,
 go ahead and power your Bionic off and on.

_EOF

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
#############################################################################
# version 1.0 - menudriven - renamed - complete re-write Oct 28 2011 - crpeck
#
#eof
