PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:$PATH"
#which perl
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
       echo "Following options are available to fly like SUPERMAN : "
       echo "-ip    : Go to Ip folder Parent \"$VC_WORKSPACE/ip\""
       echo "-tb    : Go to Top level TB Parent \"$VC_WORKSPACE/product/LodeRunner/common\""
       echo "-prod  : Go to Product folder \"$VC_WORKSPACE/product/LodeRunner\""
       echo "-proj  : Go to Project folder \"$VC_WORKSPACE/projects//abc\""
       echo "-method: Go to Methodology folder \"$VC_WORKSPACE/methodology/DesignKit\""
       echo "-ext   : Go to externals folder \"$VC_WORKSPACE/externals/data\""
       echo "-h     : Display this SUPERMAN"
       echo "-------------------------------------------------------"
       ;;
    3)
       echo "Examples,"
       echo "\" $0 -ip Temp rtl\",\". $0 -ip Temp\""
       echo "\" $0 -tb Cheetah tb\" ; \". $0 -tb Cheetah run_ASIC\""
       echo "\" $0 -ext\""
       echo "Optionally, you could also specify DEPTH"
       echo "\"$0 -ext wire ANA 4\": The 4 is the number of levels to look below "
       echo "NOTE On Levels: It is always the fourth argument from the script name "
       echo "---------------------------------------------------------------------"
       ;;
  esac
}
check_VC_WORKSPACE () { 
_vc=`eval echo $VC_WORKSPACE`
  if [ ! -d "$_vc" -o "$_vc" == "" ]; then
    echo "ERROR - You have not set a correct VC_WORKSPACE"
    echo "        Please correct this before trying again"
    echo ""
    #exit 1
  fi
 unset _vc                 tb
 }

findInWs () {
    PATHTOSEARCH=$1
    NAME=$2
    INSIDENAME=$3 
    LEVELS=$4
    if ! [[ -z "$NAME" &&  -z "$INSIDENAME" ]]; then
        #echo "finding IP \"*$NAME*\" in $PATHTOSEARCH with LEVELS=$LEVELS" 
        perl ~/My-first-repo/scripts/findInWS.pl $PATHTOSEARCH $NAME $INSIDENAME $LEVELS
    else
        #echo "hmm.. So no arguments huh "; sleep 2; echo "Cool..."
        #echo "Switching to Parent directory \"$PATHTOSEARCH\""
        perl ~/My-first-repo/scripts/findInWS.pl $PATHTOSEARCH
    fi
}

# Main Routine

check_VC_WORKSPACE

if [[ ${1:0:3} == "-ip" ]]; then
    #go to ip folder
    PATHTOSEARCH="$VC_WORKSPACE/ip"
    #PATHTOSEARCH=$VC_WORKSPACE/ip
    findInWs $PATHTOSEARCH $2 $3 $4
elif [[ ${1:0:3} == "-tb" ]]; then
    #go to top level tb
    PATHTOSEARCH="$VC_WORKSPACE/products/LodeRunner/common"
    #PATHTOSEARCH=$HOME
    findInWs $PATHTOSEARCH $2 $3 $4    
elif [[ ${1:0:5} == "-prod" ]]; then
    #go to product folder
    PATHTOSEARCH="$VC_WORKSPACE/products/LodeRunner"
    #PATHTOSEARCH=$HOME
    findInWs $PATHTOSEARCH $2 $3 $4    
elif [[ ${1:0:5} == "-proj" ]]; then
    #go to projects folder
    PATHTOSEARCH="$VC_WORKSPACE/projects"
    #PATHTOSEARCH=$HOME
    findInWs $PATHTOSEARCH $2 "abc" $4 
elif [[ ${1:0:7} == "-method" ]]; then
    #go to methodology folder
    PATHTOSEARCH="$VC_WORKSPACE/methodology/DesignKit"
    #PATHTOSEARCH=$HOME
    findInWs $PATHTOSEARCH $2 $3 $4
elif [[ ${1:0:4} == "-ext" ]]; then
    #go to externals folder
    export LEVELS=3
    PATHTOSEARCH="$VC_WORKSPACE/externals/data"
    #PATHTOSEARCH=$HOME
    findInWs $PATHTOSEARCH $2 $3 $4
elif [[ ${1:0:2} == "-h" ]]; then
    # display usage of the script
    usage 1 
    usage 2
    usage 3
else
    usage 1
    usage 2
    usage 3
    #exit 1
fi

#cd $(perl findInWS.pl $1 $2)
