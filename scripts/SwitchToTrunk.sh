#!/bin/bash
IPNAME=$1


SwitchToTrunk() {                                                                                  
    echo "Switching $1 to trunk... "
    cd $VC_WORKSPACE/ip
    if [ $? -gt 0 ]; then
        echo "ERROR - Couldnt navigate to $VC_WORKSAPCE/ip directory"
        exit 1
    fi  
    svn switch http://svn.nordicsemi.no/seesaw/ip/$1/trunk $1 
    if [ $? -gt 0 ]; then
        echo "ERROR - couldnt switch $1 to trunk"
        echo "        Something went wrong while creating an IP- contact CHSH"
        exit 1
    fi  
    cd $VC_WORKSPACE/ip/$1/trunk &> /dev/null
    if [ $? -eq 0 ]; then
        echo "ERROR- The trunk folder still exists" 
        echo "        Couldnt switch to trunk"
        exit 1
    fi  
}



SwitchToTrunk $IPNAME
