For Mac and Linux people - it's BionicRestorer v1.0
A way to flashboot restore your Bionic to 5.5.893

Note - This does NOT contain the actual files needed for flashing,
just the brains to flash them. You will need to download the zipfile
VRZ_XT875_5.5.893.XT875.Verizon.en.US_CFC_01.xml.zip from
http://rootzwiki.com/topic/13700-fastboot-files-55893-fxz-leaked/
then unzip it into the same BionicRestorer directory.
Once it is extracted there should be a directory named:
VRZ_XT875_5.5.893.XT875.Verizon.en.US_CFC_01.xml
which contains all the files needed to do a flash restore.

I simply extracted them, then used the xml file as a guideline 
to put this all together.

This is the Menu you will see when you run BionicRestorer.sh (Linux) or
Mac-BionicRestorer.command (which runs BionicRestorer.sh after
changing into the correct directory):

       BionicRestorer.sh (1.0) by crpeck 

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

 By Your Command (1-6,q):  


Select '1' if you are on a Bionic and have NEVER installed 5.9.901,
it will completely restore your Bionic to 5.5.893. It does NOT root
your phone.

Select '2' if you have ever installed 5.9.901, it will completely
restore your Bionic to 5.5.893 (except for cdt.bin, which is ok).
It does NOT root your phone.

After running 1 or 2, you will need to run selection 4 if you want
to root and ForEverRoot your Bionic - 
SELECTIONS 1 and 2 DO NOT ROOT YOUR BIONIC!

Optionally, you can select '5' and have the 5.9.901 update file copied
to your external sdcard. I've found that once you do that your Bionic
will tell you it found an update, and, ask you if you want to apply it.

Here are the commands that get run, they're identical to 
what the xml file does, except I commented out the 2 lines
that erase 'emstorage' (aka internal 'sdcard').

moto-fastboot reboot-bootloader
moto-fastboot flash  mbm allow-mbmloader-flashing-mbm.bin
moto-fastboot reboot-bootloader
moto-fastboot flash mbmloader mbmloader.bin
moto-fastboot flash mbm mbm.bin
moto-fastboot reboot-bootloader
moto-fastboot flash cdt.bin cdt.bin
moto-fastboot erase cache
moto-fastboot erase userdata
#moto-fastboot erase emstorage NOT DONE - would erase 'sdcard'
moto-fastboot flash lbl lbl
moto-fastboot flash logo.bin logo.bin
moto-fastboot flash ebr ebr
moto-fastboot flash mbr mbr
moto-fastboot flash devtree device_tree.bin
moto-fastboot flash system system.img
moto-fastboot flash boot boot.img
moto-fastboot flash recovery recovery.img
moto-fastboot flash cdrom cdrom
moto-fastboot flash preinstall preinstall.img
#moto-fastboot flash emstorage emstorage.img NOT DONE - would erase 'sdcard'
moto-fastboot flash webtop grfs.img
moto-fastboot flash radio radio.img

There is extensive error checking done throughout the whole process,
but, there is always a chance that I missed something. If you run across
an error, please post to rootzwiki.com, and, cut & paste as much as you can 
into the message.

This uses a different fastboot binary than the one distributed with the Android
SDK, it uses moto-fastboot (of which there are 4 different binaries included
in the bin directory, both a 32-bit & 64-bit version for both Mac & Linux
systems). That was the key, as it's impossible to fastboot flash the webtop
with the SDK version, it's simply too large.

It goes without saying, if you totally bork your phone with this, if it bursts
into flame and your house burns down, well, let me know, but, that's life - 
you're responsible for your own actions, not me.

Enjoy,
crpeck
