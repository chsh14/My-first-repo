#!/bin/csh -f

#module load gnutools/grid-engine
#alias qrunSpecial /cad/gnu/sge_test/bin/lx-amd64/qsub -cwd -V -j y -o ..\/..\/..\/\${JOB_ID}.\${currentTest}-rtl.log -b y -S /bin/sh

if ( $#argv < 1 ) then
    echo Running with default list of tests:
    set TEST_LIST="sim_NfcModemDma sim_NfcModemDmaWhenCortexSleep sim_NfcModemCollRes sim_NfcModemSense sim_NfcModem sim_NfcPad sim_NfcTagAnalog1 sim_NfcTagAnalog2 sim_NfcTagDirectMode"
else
    echo Running tests:
    set TEST_LIST="$*"
endif

#echo args $*

echo ${TEST_LIST}

foreach currentTest (${TEST_LIST})
    echo running simulation ${currentTest}
    cd ${currentTest}/run_ASIC/rtl/
    #qrunSpecial RUN_ALL --product=${PRODUCT} --clean
    qsub -cwd -V -j y -o ..\/..\/..\/\$JOB_ID.${currentTest}-rtl.log -b y -S /bin/sh RUN_ALL --product=${PRODUCT} --clean
    cd ../../../
end

qstat -f
