#!/bin/bash
# This file will get the missing ip in the WC from the repository
get_ip (){
    cd $VC_WORKSPACE/ip/
    cd $VC_WORKSPACE/ip/$1
   if [ $? -gt 0 ]; then
       echo "The Ip doesnt exist in the WS..OK"
   else
       echo "Error : The IP already exist in the WS"
       exit 1 
   fi 
    svn up --depth empty $1
   if [ $? -eq 0 ]; then
           echo OK
   else
           exit 1 
   fi
  # cd $1
  # svn up --depth empty rtl
  # svn up --depth empty sim
  svn ls http://svn.nordicsemi.no/seesaw/ip/$1/trunk
   if [ $? -eq 0 ]; then
           echo "OK --> trunk found "
   else
          echo "The trunk doesnt exist inside /ip/"
          echo "Tried--> svn ls http://svn.nordicsemi.no/seesaw/ip/$1/trunk"
          exit 1  
   fi
   svn switch http://svn.nordicsemi.no/seesaw/ip/$1/trunk $1 
   #svn switch http://svn.nordicsemi.no/seesaw/ip/$1/sim/trunk sim 

   cd $1
   if [ $? -eq 0 ]; then
           echo OK
   else
           exit 1
   
   fi 
   svn up --set-depth infinity
   #cd ..
   #cd sim
   # svn up --set-depth infinity

}

get_tb (){ 
    cd $VC_WORKSPACE/products/LodeRunner/common
    cd $VC_WORKSPACE/products/LodeRunner/common/$1
   if [ $? -gt 0 ]; then
       echo "The tb doesnt exist in the WS..OK"
   else
       echo "Error : The TB already exist in the WS"
       echo "Tried --> cd $VC_WORKSPACE/products/LodeRunner/common/$1"
       exit 1 
   fi  
    svn up --depth empty $1
   if [ $? -eq 0 ]; then
           echo OK
   else
           exit 1 
   fi  
  # cd $1
  # svn up --depth empty rtl
  # svn up --depth empty sim
  svn ls http://svn.nordicsemi.no/seesaw/products/LodeRunner/common/$1/trunk
   if [ $? -eq 0 ]; then
           echo "OK --> trunk found "
   else
          echo "The trunk doesnt exist inside /$1/"
          echo "Tried--> svn ls http://svn.nordicsemi.no/seesaw/products/LodeRunner/common/$1/trunk"
          exit 1   
   fi  
   svn switch http://svn.nordicsemi.no/seesaw/products/LodeRunner/common/$1/trunk $1  
   #svn switch http://svn.nordicsemi.no/seesaw/ip/$1/sim/trunk sim 

   cd $1
   if [ $? -eq 0 ]; then
           echo OK
   else
           exit 1
   
   fi  
   svn up --set-depth infinity
   #cd ..
   #cd sim
   # svn up --set-depth infinity

}

if [[ ${1:0:4} == "sim_" ]]; then
    echo "You are talking about top level tb arent you!"
    get_tb $1
else
    echo "I think you want an IP"
    get_ip $1
fi
