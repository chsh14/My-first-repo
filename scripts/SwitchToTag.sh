#!/bin/bash -e
IPNAME=$1
SwitchToTag() {
 echo "Switching $1 to latest tag found in quark.xml... "
 cd $VC_WORKSPACE/ip                                                                                                             
 if [ $? -gt 0 ]; then
    echo "ERROR - Couldnt navigate to $VC_WORKSAPCE/ip directory"
    exit 1
 fi
 ENTRYINQUARK=$(grep -w "  $1  " $VC_WORKSPACE/projects/quark/abc/quark.xml )
 TAG=$(grep -w "  $1  " $VC_WORKSPACE/projects/quark/abc/quark.xml | awk '{ print $2}')

 echo "I have found this entry for you in quark.xml : $ENTRYINQUARK"
 read -p "Do you agree with me (y/n)?" answer
 if [[ ${answer:0:1} == "y" ]]; then
     echo "Cool...Switching to Tag : $TAG"
     svn switch http://svn.nordicsemi.no/seesaw/ip/$1/$TAG $1
 else
     echo "Oops Something you didnt like.. "
 fi


}


SwitchToTag_custom() {
    echo "Switching $1 to $2 Tag"
    cd $VC_WORKSPACE/ip
    if [ $? -gt 0 ]; then
       echo "ERROR - Couldnt navigate to $VC_WORKSAPCE/ip directory"
       exit 1
    fi
    svn switch http://svn.nordicsemi.no/seesaw/ip/$1/tags/$2 $1

}

SwitchToTag_any() {
    echo "Switching $1 to $2 Tag"
    cd $VC_WORKSPACE/
    if [ $? -gt 0 ]; then
       echo "ERROR - Couldnt navigate to $VC_WORKSAPCE/ip directory"
       exit 1
    fi  
    svn switch http://svn.nordicsemi.no/seesaw/ip/$1/tags/$2 $1

}







if [[ $# -eq 2  ]]; then
    TAGNAME=$2
    SwitchToTag_custom $IPNAME $TAGNAME 
else
    SwitchToTag $IPNAME
fi


