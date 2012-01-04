#!/bin/bash
# restore.sh - restores EVERYTHING from leaked 5.5.893 files
# v 1.0 - crpeck - 2012-01-01, check Bionic version and restores the correct cdt for 5.9.901

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
if [ $? -eq 1 ]; then
  echo "Missing files needed to run."
  echo "Did you remove anything, maybe try unzipping again."
  err_exit "Are you running from the correct directory?"
fi

check_required_files "$fxz_required_files"
if [ $? -eq 1 ]; then
  print_dashes
  echo ""
  echo "Missing FXZ Files from VRZ_XT875_5.5.893.XT875.Verizon.en.US_CFC_01.xml.zip"
  echo "Did you download the VRZ_XT875_5.5.893.XT875.Verizon.en.US_CFC_01.xml.zip"
  echo "and unzip it here: $basedir"
  echo "You can find them at: http://rootzwiki.com/topic/13700-fastboot-files-55893-fxz-leaked/"
  print_dashes
  err_exit "Missing files"
fi

print_dashes
cat <<_EOF

This script will:
-restore your phone to 5.5.893 from leaked VZW File
 (VRZ_XT875_5.5.893.XT875.Verizon.en.US_CFC_01.xml.zip)

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
It then restores from the Offical 5.5.893 images and wipes your data    

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
echo "Here we go, I don't stop on errors, once it starts there is no stopping"
my_fastboot reboot-bootloader
my_fastboot erase cache
my_fastboot erase userdata
my_fastboot flash system system.img

echo ""
print_dashes

echo "Rebooting your phone now... "
echo "You may see the Motorola Logo for a long time before it boots"

my_fastboot reboot

if [ $? -ne 0 ]; then
  echo ""
  echo "Possible issue rebooting your phone. You may need to power it off and"
  echo "on manually."
  echo ""
fi

# print out a message to chill out
echo " In the immortal words from Hitchhikers Guide to the Galaxy:"
echo $bold; print_out "                           DON'T PANIC!";echo $nobold
 
cat <<_EOF 

 Relax, the reboot takes a long time. DON'T PANIC! You do have your towel
 don't you?  Why a towel? http://www.imdb.com/title/tt0371724/faq

 If you are still stuck in the AP Fastboot screen for more than a few minutes,
 go ahead and power your Bionic off and on.

_EOF

exit 0

# 
#############################################################################
# version 1.0 - 2012-01-02 - crpeck
#
#eof
