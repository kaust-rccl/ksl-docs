.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: WRF compilation steps on Shaheen III
    :keywords: WRF, WRF-Chem

====================================
Compiling WRF 4.5.2 on Shaheen III
====================================

The following steps demonstrate compilation of WRF version 4.5.2 on Shaheen III:

.. code-block:: bash

    export prgenv=cray
    export jarg=32
    module load cray-hdf5
    module load cray-netcdf
    module load cray-parallel-netcdf
    module load craype-hugepages4M
    module load flex
    wget https://github.com/wrf-model/WRF/releases/download/v4.5.2/v4.5.2.tar.gz
    tar xvf v4.5.2.tar.gz
    # tar xvf /sw/sources/wrf/4.5.2/v4.5.2.tar.gz
    cd WRFV4.5.2/
    export HDF5=$HDF5_DIR
    export PHDF5=$HDF5_DIR
    export NETCDF=$NETCDF_DIR
    export PNETCDF=$PNETCDF_DIR
    export PNETCDF_QUILT=1
    export IBM_REDUCE_BUG_WORKAROUND=1
    export WRFIO_NCD_LARGE_FILE_SUPPORT=1
    export EM_CORE=1
    export FLEX_LIB_DIR=/sw/ex109genoa/flex/2.6.4/lib/
    export JASPERLIB=/usr/lib64
    export JASPERINC=/usr/include
    export YACC="yacc -d"
    case $prgenv in
    cray) conf=47;;
    esac
    ./configure << CONFEOF
    $conf
    1
    CONFEOF
    time ./compile -j ${jarg} em_real > compile-$prgenv.log 2>&1
