#!/bin/bash
#
# .command file for clicky Mac goodness
# 1.0 - 2011-Oct-10 - crpeck
# 1.1 - 2011-Oct-27 - fixed folder with a space in the name issue
#
macprogname=`basename $0`
realscript="BionicRestorer.sh"
macclickversion="1.1"

# parse the directory we're run from - this was the tricky part, without it clicky fails
mydir=`dirname "$BASH_SOURCE"`

# name of script to run
myscript="$mydir/$realscript"

# some extensive error checking and logging info
if [ ! -x $myscript ]; then
  echo ""
  echo "Error trying to run $myscript"
  echo ""
  echo "If you post online for help, please include everything printed out here."
  echo ""
  echo "Debugging Information from $0"
  echo " [ -x $myscript failed ] "
  echo ""
  echo "MacClick: $macprogname" 
  echo "Macscript Rev: $macclickversion"
  echo "BASH_SOURCE: $BASH_SOURCE"
  echo "mydir: $mydir"
  echo "myscript: $myscript"
  echo "Current Directory: $PWD"
  echo ""
  echo "Contents of directory $mydir:"
  ls -l "$mydir"
  echo ""
  echo "OS Information:"
  uname -a
  echo ""
  read -p "Press Enter to close his window, copy all that stuff down first."
  exit 1
fi

### Actually run the script to do our thing pass it the directory to run in

/bin/bash --norc --noprofile "$myscript" "$mydir"
if [ $? -ne 0 ]; then
  echo ""
  echo "Debugging Information from $0"
  echo "Error executing:"
  echo " $myscript $mydir"
  echo ""
  echo "BASH_SOURCE: $BASH_SOURCE"
  echo ""
  uname -a
  echo ""
  read -p " Press Enter to close this window."
  exit 1
fi

echo ""
echo ""
read -p "Finished - Press Enter to close this window."
exit 0

#eof
