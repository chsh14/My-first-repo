#!/bin/bash -e
usage() {
  case $1 in
    1)
       echo ""
       echo "This script jumps to different locations in yous WorkSpace(WS)"
       echo ""
       echo "-----------------------------------------------------"
       ;;
    2)
       echo "You must provide your new IP's name as a parameter."
       echo "The IP name is any name that describes your "
       echo ""
       echo "Examples:"
       echo "./create_ip.sh Radio, or ./create_ip.sh AnaDigTop, or  Usb, PathLogic, PowerManagement,"
       echo "  UTxRxChain, etc"
       echo ""
       echo "-------------------------------------------------------"
       ;;
    3)
       echo "After the IP has been added to your WS,"
       echo "You can either checkin to SVN  at the same time"
       echo "Or, you can add '-c' switch next time you run the script"
       echo "IMPORTANT : This will ONLY perform checkin and update XML operation"
       echo "            Assuming the IP has already been created first time without the switch"
       echo ""
       echo "Examples:"
       echo "./create_ip.sh SpreadLeLong -c, or ./create_ip.sh Usb -c"
       echo "NOTE : The Order is important and should be exactly like examples"
       echo "---------------------------------------------------------------------"
       ;;
  esac
}
_vc=`eval echo $HOME`
  if [ ! -d "$_vc" -o "$_vc" == "" ]; then
    echo "ERROR - You have not set a correct VC_WORKSPACE"
    echo "        Please correct this before trying again"
    echo ""
    #exit 1
  fi
 unset _vc 


if [[ ${1:0:3} == "-ip" ]]; then
    #go to ip folder
    if [ "$#" -eq 2 ]; then
        IPNAME=$2
        #$PATHTOSEARCH="$VC_WORKSPACE/ip"
        PATHTOSEARCH=$HOME
        echo "finding IP $IPNAME in $PATHTOSEARCH"
        cd $(perl findInWS.pl $PATHTOSEARCH $IPNAME) 
    elif [ "$#" -eq 3 ]; then 
        IPNAME=$2 
        INSIDEIP=$3
        echo "finding  $IPNAME/$INSIDEIP in $PATHTOSEARCH"
        cd $(perl findInWS.pl $PATHTOSEARCH $IPNAME $INSIDEIP)
    else
        echo "Need atleast one argument"
        usage 2
        #exit 1
    fi
elif [[ ${1:0:3} == "-tb" ]]; then
    #go to top level tb
    echo "Bla"
elif [[ ${1:0:3} == "-prod" ]]; then
    #go to product folder
    echo "Bla" 
elif [[ ${1:0:3} == "-proj" ]]; then
    #go to projects folder
    echo "Bla" 
elif [[ ${1:0:3} == "-method" ]]; then
    #go to methodology folder
    echo "Bla" 
elif [[ ${1:0:3} == "-ext" ]]; then
    #go to externals folder
    echo "Bla" 
else
    usage 1
    usage 2
    usage 3
    #exit 1
fi

#cd $(perl findInWS.pl $1 $2)
