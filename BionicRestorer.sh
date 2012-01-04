#!/bin/bash
#
# BionicRestorer
#  This uses the fastboot files 5.5.893 FXZ for the Bionic from
#   VRZ_XT875_5.5.893.XT875.Verizon.en.US_CFC_01.xml.zip
#   http://rootzwiki.com/topic/13700-fastboot-files-55893-fxz-leaked/
#
#  I simply extracted them, then used the xml file as a guideline 
#  to put this all together.
#
#  Option 1 will completely restore your Bionic to v5.5.893, all
#  user data will be removed.
#  
#  NOTE: This uses moto-fastboot for Linux or the Mac, without this
#        the webtop image would not be restored, as the google fastboot
#        chokes on large files.
#
#  v1.0 2012-01-01 - crpeck initial creation from MotoRooter
#
# MotoRooter
#  v1.0 2011-10-28 - crpeck initial creation
#  v1.1 2011-10-29 - simplification of scripts - thanks dhacker29
#                  - fixed bug in 4everRoot.sh - thanks tfast500
#  v1.2 2011-11-01 - added in cheesecake - thanks dhacker29
#                  - moved MotoRooter.txt file to the main loop
#                  - remove option for factory restore - was same as 4
#                  - removed 'credits' from menu to match r3l3as3d
#                    -prints at start and end of script now
#                  - removed lib directory, put function lib in bin
#                  - call all scripts with bash now
#                  - more changes to 4everRoot.sh, mostly error checking
#                    -added mount rw/remount /system to mount_ext3.sh
#                  - added a cookie for readers - lol
#                  - remove install of busybox - get it from the market
#                  - install Superuser.apk in /data/app instead of /system/app
#  v1.3 2011-11-02 - added busybox back in
#  v1.4 2011-12-14 - new version of zerg, may work with latest OTA?
#                  - fixed missing end quote bug, may have messed with 3everroot
#                  - remove zergs files in /data/local/tmp before running zergRush,
#                    that should fix the issue with zergRush crapping out
#                  - thanks to @dam for debugging this
#
# BionicRestorer script - this puppy drives the train
#
# check if source directory was passed in as an argument
# for Mac clicky commandfile to know where its run from
NUM_ARGS=$#

if [ $NUM_ARGS -ge 1 ]; then
  if [ -d "$1" ]; then
    cd "$1"
  else
    echo "Danger, Danger Will Robinson!!!"
    echo "Error finding the directory installed to: $1"
    exit 1
  fi
fi

# load the function definition library - where the guts are
if [ -r ./bin/includes.lib ]; then
  source ./bin/includes.lib
else
  echo "Danger, Danger Will Robinson!!!"
  echo "Missing or can't find file ./bin/includes.lib"
  exit 1
fi

#############################################

# NOTE: if this script is called with more than 1 argument
# then it runs in DEBUG mode, where it prints stuff out, but,
# it doesn't do squat.

if [ $NUM_ARGS -gt 1 ]; then
  DEBUG=1
  print_debug_mode
fi

# loop forever
FINISHED=0
while [ $FINISHED -ne 1 ]; do
  term_width=`tput cols`
  print_dashes
  echo "      $bold $progname ($version) by crpeck $nobold"
  cat << _EOF

1. Restore a Bionic to 5.5.893 - NOT FOR 5.9.901 BIONICS!
   -restores EVERYTHING to official 5.5.893
   -wipes data

2. Restore a 5.9.901 Bionic to 5.5.893
   -restores EVERYTHING EXCEPT for the cdt.bin to 5.5.893
   -cdt.bin is restored using the 5.9.901 file
   -wipes data
   ** YOU SHOULD ONLY USE THIS IF YOU ARE OR HAVE BEEN ON 5.9.901 **

3. Restore /system only
   -restores ONLY the system partition to official 5.5.893, 
   -wipes data

4. Root and ForeverRoot a non-rooted Bionic
   -roots and installs the ForeverRoot hack

5. Copy 5.9.901 update file to sdcard
   -this copies the unoffical 5.9.901 update file to your sdcard
    chances are, your Bionic will bug you to do an update when it see's it
    there, you can usually force it via the 'Check for Updates' screen.

6. Help - I need more information!

q. Quit

_EOF
  echo -n "$ul_on By Your Command (1-6,q): $ul_off "
  read answer

  case $answer in
    1)
      echo ""
      echo "$bold Restoring 5.5.893 to Your Bionic $nobold"
      echo "$bold This is NOT for Bionics that have had 5.9.901 installed!!! $nobold"
      bash ${basedir}/bin/restore.sh
      echo ""
      ;;

    2)
      echo "$bold Restoring Everything on Your 5.9.901 Bionic to 5.5.893 $nobold"
      echo "$bold This is ONLY for Bionics that have had 5.9.901 installed!!! $nobold"
      bash ${basedir}/bin/restore901.sh
      echo ""
      ;;

    3)
      echo ""
      echo "$bold Restoring /system partition ONLY to 5.5.893"
      echo "This only flashes /system."
      bash ${basedir}/bin/restore-system.sh
      echo ""
      ;;

    4)
      echo ""
      echo "$bold Rooting and ForEverRooting a non-rooted Bionic $nobold"
      bash ${basedir}/bin/root4everRoot.sh
      echo ""
      ;;

    5)
      echo ""
      echo "$bold Copying the 5.9.901 update to external sdcard on your Bionic $nobold"
      bash ${basedir}/bin/copy-5.9.901.sh
      echo ""
      ;;

    6|h|H)
      echo ""
      echo "$bold Getting help... $nobold"
      bash ${basedir}/bin/help.sh
      echo ""
      ;;
  
    q|Q)
      echo ""
      echo "$bold All done - Cleaning up.. $nobold"
      echo ""
      FINISHED=1
      ;;

    c|C)
      echo ""
      echo "$bold You found a cookie, yumyum."
      echo "Congrats on looking at the script before"
      echo "blindly trusting it. $nobold"
      echo ""
      read -n1 -p "Press enter to continue. "
      echo ""
      ;;

    *)
      echo ""
      echo "$bold Sorry, I didn't get that. $nobold"
      read -n1 -p "Press enter to continue. "
      echo ""
      ;;

  esac
done

# give credit to everyone
print_credits

exit 0
# eof
