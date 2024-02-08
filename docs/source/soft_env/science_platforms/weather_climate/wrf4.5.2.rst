=======
WRF
=======


.. code-block:: bash

    export prgenv=cray
    export jarg=32
    module load cray-hdf5
    module load cray-netcdf
    module load cray-parallel-netcdf
    module load craype-hugepages4M
    wget https://github.com/wrf-model/WRF/releases/download/v4.5.2/v4.5.2.tar.gz
    tar xvf v4.5.2.tar.gz
    cd WRFV4.5.2/
    export HDF5=$HDF5_DIR
    export PHDF5=$HDF5_DIR
    export NETCDF=$NETCDF_DIR
    export PNETCDF=$PNETCDF_DIR
    export PNETCDF_QUILT=1
    export IBM_REDUCE_BUG_WORKAROUND=1
    export WRFIO_NCD_LARGE_FILE_SUPPORT=1
    export EM_CORE=1
    export FLEX_LIB_DIR=/usr/lib64
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
