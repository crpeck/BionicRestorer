#!/bin/bash
source ./bin/includes.lib

print_dashes

echo "$bold Help - If you need help, you better exit this and do some research. $nobold"
echo "$bold You can also take a look at the 00_README.txt file, as well as the code. $nobold"
echo ""
echo "All of these use the leaked fastboot FXZ files for the Bionic v5.5.893."
echo "You $bold MUST $nobold download them and unzip them into the same directory"
echo "that this is running from: ${basedir}."
echo "Once you have, there should be a directory named"
echo "VRZ_XT875_5.5.893.XT875.Verizon.en.US_CFC_01.xml"
cat << _EOF

Menu Selections:

1. This uses the leaked fastboot files for the Bionic v5.5.893 
   and restores EVERYTHING - it should work on a bricked Bionic,
   It should also put you back on the upgrade path for future
   updates OTA.
   Be sure to run Selection 4 if you want your Bionic Rooted.

2. If you have ever updated your Bionic to 5.9.901 then you MUST
   use this to restore it. This is almost identical to Selection 1 except
   that it loads the cdt.bin file from 5.9.901.
   Be sure to run Selection 4 if you want your Bionic Rooted.

   Once you have loaded the 5.9.901 CDT you cannot go back, what's a CDT?
   "Just like a desktop computer's hard disk, the Milestone's Flash RAM
    is divided in partitions called CG's (Code or Content Groups). The
    list of CG's in a system is called CDT (Code Description Table?),
    and it is analogous to the partition table on a PC.
    The CDT itself is stored in a CG.
    The CDT table determines which NAND parts have to be checked for signatures."

3. This restores only the /system partition, it's handy if
   you are already at 5.5.893 (OTA), and, want to return to
   the Stock ROM. (Great for bootlooping Bionics).
   Be sure to run Selection 4 if you want your Bionic Rooted.

4. Simply Roots and ForEverRoots a Bionic that hasn't been rooted. You WILL
   want to run this after running either 1, 2 or 3 above, assuming that you
   want to root your Bionic.

5. Copy the update file for 5.9.901 to your external sdcard
   Usually your Bionic will see this file and ask you if you would like
   to update it at this time. If not, it's possible to force an update, 
   sometimes via the 'Check for Update' screen, or, via running Stock
   Recovery (which is beyond this - google it).

Seriously, there isn't much more information that can be provided
here to help you.  Go to http://rootzwiki.com and get into the 
Motorola Droid Bionic Forums and read up, ask questions, and
get comforatble before you attempt this. While it's pretty hard
to completely 'brick' your Bionic to the point where someone
can't get it back, you can really mess it up by selecting the
wrong option.

_EOF

echo "$bold NOTICE!!! None of the restore selection root the Bionic!!! $nobold"
echo "$bold You MUST run Selection 4 to root it $nobold after you restore it."

read -n1 -p "Press enter to return to the main menu. "
