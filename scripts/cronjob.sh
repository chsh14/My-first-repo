#!/bin/bash -e
cd /pro/quark4413/work/chsh/QuarkFP2_WS/products/LodeRunner/common/sim_InfoConfRippings/run_ASIC/rtl
#which perl
#echo $PATH
perl ParseFicrXML.pl 
if [ "$?" = "0" ]; then
        echo " Success"
else
        echo "Error message found (see above)" 1>&2
        exit 1
fi
