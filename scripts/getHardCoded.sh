#!/bin/bash -e

usageScript() {
 echo " How to use the script 
        --------------------------------------------------------------------------
        Example 1 : ./getHardCoded -a --> Will get all the /n/ paths from the VC_WORKSPACE
        Example 2 : ./getHardCoded -ip TempSense -->  Will get HardCoded Links from VC_WORKSPACE/ip/TempSense
        ------------------------------------------------------------------------------------------- "



}

usage(){
  echo "USAGE :--------------------------------------------"
  
  case $1 in
     0) echo "
              get_hardCoded_HighPriority : Gets HardCoded Paths from *.comp and *.fl files in $VC_WORKSPACE
                                          Outputs in $VC_WORKSPACE/reports/IP_formated_entered.rpt
              get_hardCodedLowPriority   : Gets HardCoded Paths from */syn/.*common_setup.tcl in $VC_WORKSPACE
                                          Outputs in $VC_WORKSPACE/reports/SYN_formated_entered.rpt";; 
     1) echo "
              get_hardCoded_HighPriority : Gets HardCoded Paths from *.comp and *.fl files in $VC_WORKSPACE/ip/
                                           Outputs in $VC_WORKSPACE/reports/IP_formated_entered.rpt
              get_hardCodedLowPriority   : Gets HardCoded Paths from */syn/.*common_setup.tcl in $VC_WORKSPACE/ip/
                                          Outputs in $VC_WORKSPACE/reports/SYN_formated_entered.rpt";;
   esac
              

  echo "-----------------------------------------------------"

                            
}




check_VC_WORKSPACE () {                                                                                                             
  echo "Checking your '\$VC_WORKSPACE' variable..."
  _vc=`eval echo $VC_WORKSPACE`
  if [ ! -d "$_vc" -o "$_vc" == "" ]; then
    echo "ERROR - You have not set a correct VC_WORKSPACE"
    echo "        Please correct this before trying again"
    echo ""
    exit 1
  fi  
 unset _vc 

}

printCustomize () {
 
 echo "----------------------------------------------------------"
 printf "%s\n" "$1"
 echo "----------------------------------------------------------"


}

get_hardCodedHighPriority () {

if [ -f $VC_WORKSPACE/reports/IP_formated_entered.rpt ]; then
    echo "Removing the old file "
    rm -rf $VC_WORKSPACE/reports/Complete_formated.rpt
    rm -rf $VC_WORKSPACE/Complete.rpt
    rm -rf $VC_WORKSPACE/reports/IP_formated_entered.rpt
fi
    printCustomize "Creating the output  file $VC_WORKSPACE/reports/IP_formated_entered.rpt"
if [ $# -eq 1 ]; then
    printCustomize "Getting paths starting from /n/ from .comp and .fl files in the $VC_WORKSPACE/ip/$1"
    cd $VC_WORKSPACE/ip/$1
else
    printCustomize "Getting paths starting from /n/ from .comp and .fl files in the $VC_WORKSPACE"
    cd $VC_WORKSPACE
fi
find `pwd` -type f \( -name '*.comp' -o -name '*.fl' \) -exec grep -iH '/n/' {} \; -print | tee $VC_WORKSPACE/Complete.rpt

if [ -s $VC_WORKSPACE/Complete.rpt ]; then
    while IFS='' read -r p || [[ -n "$p" ]]; do
        #Format1=`echo "$p" | grep -e ".*:\s*\/\/.*"`
        #echo "$Format1"
        #Format2=`echo "$Format1" | grep -e ".*YodaMP.*"`
        #echo "$Format2"
        #Format3=`echo "$Format2" | grep -e ".*QuarkFP1.*"`
        #echo "$Format3"
        if ! [[ "$p" =~ .*:\s*\/\/.* || "$p" =~ .*Yoda.* || "$p" =~ .*QuarkFP1.* ]]; then
            echo "Formating : $p"        
            echo "$p" >> $VC_WORKSPACE/reports/Complete_formated.rpt 
        fi  
      done <$VC_WORKSPACE/Complete.rpt
  else
      printCustomize "No paths found for HighPriority.. Yupeee"
  fi

  if [ -s $VC_WORKSPACE/reports/Complete_formated.rpt ]; then
    while read -r p2; do
        if [[ "$p2" =~ .*\.comp\s*$ ]]; then
            echo "Performing the substitution in $p2"
            echo "$p2" | sed "s;$p2;$p2\n-----------------;g"  >> $VC_WORKSPACE/reports/IP_formated_entered.rpt
        elif [[ "$p2" =~ .*\.fl$ ]]; then
            echo "Performing the substitution in $p2"
            echo "$p2" | sed "s;$p2;$p2\n-----------------;g"  >> $VC_WORKSPACE/reports/IP_formated_entered.rpt
        else
            echo "$p2" >> $VC_WORKSPACE/reports/IP_formated_entered.rpt
        fi
      done <$VC_WORKSPACE/reports/Complete_formated.rpt
  else
      printCustomize "No paths found for HighPriority... Yupeee"
  fi

  printCustomize "HighPriority PathFinding is complete. Pls look at the reports if any"

}

get_hardCodedLowPriority () {

if [ -f $VC_WORKSPACE/reports/SYN_formated_entered.rpt ]; then
    echo "Removing the old file "
    rm -rf $VC_WORKSPACE/reports/Syn_Complete_formated.rpt
    rm -rf $VC_WORKSPACE/Syn_Complete.rpt
    rm -rf $VC_WORKSPACE/reports/SYN_formated_entered.rpt
fi
    printCustomize "Creating the output  file $VC_WORKSPACE/reports/Syn_formated_entered.rpt"


if [ $# -eq 1 ]; then
    printCustomize "Getting paths starting from /n/ from /syn/ folders in the $VC_WORKSPACE/ip/$1"
    cd $VC_WORKSPACE/ip/$1
else
    printCustomize "Getting paths starting from /n/ from all the syn folders in you $VC_WORKSPACE"
    cd $VC_WORKSPACE
fi
    find . \( -type f -name 'common_setup.tcl' -and -path '*/syn/*' \) -exec grep -rH '/n/' {} \; -print | grep -v "\.svn" | tee $VC_WORKSPACE/Syn_Complete.rpt
    if [ -s $VC_WORKSPACE/Syn_Complete.rpt ]; then
        while IFS='' read -r p || [[ -n "$p" ]]; do
            if ! [[ "$p" =~ ".*:\s*\#+.*" || "$p" =~ .*Yoda.* || "$p" =~ .*QuarkFP1.* ]]; then
                echo "Formating : $p"        
                echo "$p" >> $VC_WORKSPACE/reports/Syn_Complete_formated.rpt 
            fi  
        done <$VC_WORKSPACE/Syn_Complete.rpt
    else
        printCustomize "No Paths found for LowPriority... Yupeee"
    fi

    if [ -s $VC_WORKSPACE/Syn_Complete_formated.rpt ]; then
        while read -r p2; do
            if [[ "$p2" =~ .*\.tcl\s*$ ]]; then
                echo "Performing the substitution in $p2"
                echo "$p2" | sed "s;$p2;$p2\n-----------------;g"  >> $VC_WORKSPACE/reports/SYN_formated_entered.rpt
            else
                echo "$p2" >> $VC_WORKSPACE/reports/SYN_formated_entered.rpt
            fi
        done <$VC_WORKSPACE/reports/Syn_Complete_formated.rpt
    else
        printCustomize "No Paths foundi for LowPriority.... Yupee"
    fi
    printCustomize "LowPriority PathFinding is complete. Pls look at the reports if any"

}


if [[ $# -eq 1 && "${1:0:3}" == "-ip"  ]]; then
    printCustomize "Finding HardCoded paths from $VC_WORKSPACE/ip/$1"
    check_VC_WORKSPACE
    usage 1
    echo "Yo $USER!. I would like you to select what you would like to run "
    select OP in "get_hardCodedLowPriority" "get_hardCodedHighPriority" "both" "I Quit" "Report a Bug"
    do 
        case $OP in
            get_hardCodedLowPriority) get_hardCodedLowPriority $1;;
            get_hardCodedHighPriority) get_hardCodedHighPriority $1;;
            both) get_hardCodedHighPriority $1;get_hardCodedLowPriority $1;;
            "I Quit") echo "Nice to hear that,Have a nice day !!"
                      exit 0;;
            "Report a Bug") echo "So you would like to report a bug to chsh? "; sleep 2 ; echo "I highly doubt your findings... "
                            echo "Anyways.. type in the error message"
                            read -p "Here :" message
                            echo "$message" | mail -s "Bug reporting for getHardcoded.sh script" chsh@nordicsemi.no 
                            printCustomize "Done..Thanks"; exit 0;;

            *) echo "Sorry buddy, better luck next time!"
               exit 0;;
            
        esac
    done
elif [[ "${1:0:2}" == "-a" ]]; then
    printCustomize "Finding ALL the HardCoded Paths from $VC_WORKSPACE"
    check_VC_WORKSPACE
    usage 0
    echo "Yo $USER!. I would like you to select what you would like to run "
    select OP in "get_hardCodedLowPriority" "get_hardCodedHighPriority" "both" "I Quit" "Report a Bug"
    do  
        case $OP in
            get_hardCodedLowPriority) get_hardCodedLowPriority;;
            get_hardCodedHighPriority) get_hardCodedHighPriority ;;
            both) get_hardCodedHighPriority ;get_hardCodedLowPriority ;;
            "I Quit") echo "Nice to hear that, Have a nice day !!"
                      exit 0;;
            "Report a Bug") echo "So you would like to report a bug to chsh? "; sleep 2 ; echo "I highly doubt your findings... "
                            echo "Anyways.. type in the error message"
                            read -p "Here :" message
                            echo "$message" | mail -s "Bug reporting for getHardcoded.sh script" chsh@nordicsemi.no 
                            printCustomize "Done..Thanks"; exit 0;;
            *) echo "Sorry buddy, better luck next time!"
              exit 0;;
        esac
    done
else
    printCustomize "Hi There \"$USER\", I can only work with  ONE argument"
    usageScript
fi






















  












  

  
















