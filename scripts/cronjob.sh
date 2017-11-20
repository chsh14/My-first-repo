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




#Sample crontab -e file content
#SHELL=/bin/sh
#PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#00 02 * * * /pri/chsh/My-first-repo/scripts/monitor_price.sh | mail -s "[chsh] Cronjob service" chirayu.shah14@gmail.com
