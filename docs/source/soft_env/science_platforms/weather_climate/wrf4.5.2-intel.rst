.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: WRF compilation steps on Shaheen III
    :keywords: WRF, WRF-Chem

=====================================================
Compiling WRF 4.5.2 using PrgEnv-intel on Shaheen III
=====================================================

The following steps demonstrate compilation of WRF version 4.5.2 using PrgEnv-intel on Shaheen III:

.. code-block:: bash

    export prgenv=intel
    export jarg=32
    module swap PrgEnv-cray PrgEnv-intel/8.4.0
    module load cray-netcdf
    wget https://github.com/wrf-model/WRF/releases/download/v4.5.2/v4.5.2.tar.gz
    tar xvf v4.5.2.tar.gz
    cd WRFV4.5.2/
    export NETCDF=$NETCDF_DIR
    export NETCDF_classic=1
    source configure <<< "51"
    sed -i 's;/lib/cpp -P -nostdinc;/lib/cpp -P ;g' ./configure.wrf
    sed -i 's/-hnoomp//g' ./configure.wrf
    sed -i 's/# -DRSL0_ONLY/-DRSL0_ONLY/g' ./configure.wrf
    sed -i 's/nproc_x .LT. 10/nproc_x .LT. 1/' share/module_check_a_mundo.F
    sed -i 's/nproc_y .LT. 10/nproc_y .LT. 1/' share/module_check_a_mundo.F
    time ./compile -j ${jarg} wrf  > compile-wrf-$prgenv.log 2>&1
    time ./compile -j ${jarg} em_real  > compile-em_real-$prgenv.log 2>&1
