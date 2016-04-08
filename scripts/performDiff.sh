#!/bin/bash -e
TMPDIR=/work/$USER/TEMP-create_ip 
IPNAME=$1 


modifyTemplate(){
    printCust "Modifying template files..."
    rm create_ip.sh* > /dev/null
    FILELIST=$(find . -type f \( ! -regex '.*/\.svn/.*' \))
    IPNAMEL=$(echo $IPNAME | tr '[:upper:]' '[:lower:]' )
    #echo "Lower case is $IPNAMEL"
    IPNAMEU=$(echo $IPNAME | tr '[:lower:]' '[:upper:]' ) 
    DATE=$(date +%m-%d-%y)
    #OLDIFS=$IFS
    #echo "OldIFS is $OLDIFS"
    #IFS="$(echo -e "\n\r")"
    #echo "IFS is $IFS"
    for F in $FILELIST; do
      echo "Modifying $F... "
      if [ `cat "$F" | grep -c [Ee][xX][aA][mM][pP][Ll][eE]` -ge 1 ]; then 
        echo "in if 1"  
        sed "s/Example/$IPNAME/g" "$F" > tmpdir
        mv tmpdir $F >/dev/null
      fi
      if [ `cat "$F" | grep -c [Ee][xX][aA][mM][pP][Ll][eE]` -ge 1 ]; then
        sed "s/example/$IPNAMEL/g" "$F" > tmpdir
        mv tmpdir $F >/dev/null
      fi
      if [ `cat "$F" | grep -c [Ee][xX][aA][mM][pP][Ll][eE]` -ge 1 ]; then
         sed "s/EXAMPLE/$IPNAMEU/g" "$F" > tmpdir
         mv tmpdir $F >/dev/null
      fi
      sed "s/7637f79f4791fefbf8b5a36fdd1a8508/$USER at $DATE/g" "$F" > tmpdir
      mv tmpdir $F > /dev/null
      if [ `echo "$F" | grep -c Example` -eq 1 ]; then
        NEWNAME=$(echo "$F" | sed "s/Example/$IPNAME/g")
        echo "Renaming $F -> $NEWNAME..."
        mv "$F" "$NEWNAME" > /dev/null
      fi
    done
    #chmod u+x $VC_WORKSPACE/ip/$IPNAME/sim/run/rtl/*
    #IFS=$OLDIFS
    echo "Removing old svn files..."
    find . -type d \( -regex '.*/\.svn' \) -print0 | xargs -0 /bin/rm -rf; # see https://www.gnu.org/software/findutils/manual/html_node/find_html/Deleting-Files.html for xargs -0
} 



performDiff() {
    printCust "NOTE: No commit would be done after adding files.. "
    printCust "If something goes wrong there will be a BACKUP file with \'\~\'"
    sleep 2
    rm -rf $TMPDIR
    rsync -a $VC_WORKSPACE/ip/Example $TMPDIR/ 
    cd $TMPDIR/Example
    find . -iname '*\.un*' -or -name '*\.sw[po]*' | xargs /bin/rm -rf
    if [ $? -gt 0 ]; then
        echo "ERROR - couldnt got to $TMPDIR"
        echo "        Something went wrong while creating TMPDIR contact CHSH"
        exit 1
    fi
    modifyTemplate
    cd ..         
    printCust "Looking for missing files/folders in your IP $1..."
    diff -rq $TMPDIR/Example/ $VC_WORKSPACE/ip/$1 -x 'externals' -x '*.sv' -x '.svn' -x 'tb' | grep -ie 'Only' | grep -ie 'Example' | tee $TMPDIR/diff_Files.txt
    diff -rq -E -B $TMPDIR/Example/ $VC_WORKSPACE/ip/$1 -x 'externals' -x '*.sv' -x '.svn' -x '*.xml' -x '*.fl' | grep -ie 'Files' > $TMPDIR/change_Files.txt
    if [ -s $TMPDIR/diff_Files.txt ]; then
        echo "-----------------------------------------------------------------"
        read -p "Do you want to make all these changes at once-->[yes] OR go through one by one-->[no] [y/n]/?" changes
        echo "-----------------------------------------------------------------"
        if [[ ${changes:0:1} == "y" ]]; then
            echo "Very Well then"
            rsync -ravbz Example/ $VC_WORKSPACE/ip/$1/ --exclude 'externals' --exclude '*.sv' --exclude '*.fl' --exclude 'sim/tb' --exclude '.svn' --ignore-existing 
        else
            echo "Very Well then... Looping through all the files/folders"
            while read -u 3 -r p1; do
                cut1=$(echo "$p1" | cut -d ' ' -f 3 | sed -e 's/://')
                echo "$cut1"
                cut2=$(echo "$p1" | cut -d ' ' -f 4)
                #echo "$cut2"
                destination=$(echo "$cut1" | sed -e "s/Example/$1/" -e 's/://')            
                #echo "$destination"
                read -p "Do you want $destination:$cut2 [y/n]?" answerforDiff
                if [[ ${answerforDiff:0:1} == "y" ]]; then
                    echo "Copying $cut2 --> $destination"
                    rsync -av $cut1/$cut2 $VC_WORKSPACE/ip/$destination --exclude '.svn' 
                #else    
                #    echo "You are on yr own now.. "
                fi          
            done 3<$TMPDIR/diff_Files.txt
        fi
    else
       printCust "Cool.. You have no files/folders missing"
    fi
    printCust "Following are the diffs in the EXISTING files "
    cat $TMPDIR/change_Files.txt
    if [[ -s $TMPDIR/change_Files.txt ]]; then
        echo "-----------------------------------------------------------------"
        read -p "Do you want to OVERWRITE  all these files at once-->[yes] OR go through one by one-->[no] [y/n]/?" changes
        echo "-----------------------------------------------------------------"
        if [[ ${changes:0:1} == "y" ]]; then
            echo "Are you sure you want to OVERWRITE all these files..Dont worry there will be a BACKUP file"; sleep 3
            rsync -ravbz Example/ $VC_WORKSPACE/ip/$1/ --exclude '*.xml' --exclude 'externals' --exclude '*.sv' --exclude '*.fl' --exclude 'sim/tb' --exclude '.svn' 
            printCust "OverWritting finished..."
        else
            echo "Thats what I expected $USER... "
            echo "Showing you the vimdiff of all the files"
            printCust "IMPORTANT : Press \':q\' TWICE once you have reviewed the diffs"; sleep 3
            while read -u 4 -r p3; do
                cutFirst=$(echo "$p3" | cut -d ' ' -f 2)
                cutSecond=$(echo "$p3" | cut -d ' ' -f 4 )
                printCust "Showing vimdiff between $cutFirst and $cutSecond "; sleep 2
                vimdiff $cutFirst $cutSecond
                read -p "So, Do you want OVERWRITE $cutSecond [y/n]?" answerforDiff 
                if [[ ${answerforDiff:0:1} == "y" ]]; then
                    printCust "Overwriting $cutFirst --> $cutSecond..."
                    /bin/cp -f $cutFirst $cutSecond  
                fi
            done 4<$TMPDIR/change_Files.txt
        fi
            
    else
        printCust "Cool.. You have no diffs at all.. highly surprising"
    fi
    #rm -rf $TMPDIR/Example
    printCust "It was a pleasure working with you $USER.. See you next time"
    echo "Have a nice day!"
} 


printCust () {
 
 echo "----------------------------------------------------------"
 printf "%s\n" "$1"
 echo "----------------------------------------------------------"


} 

performDiff $1

