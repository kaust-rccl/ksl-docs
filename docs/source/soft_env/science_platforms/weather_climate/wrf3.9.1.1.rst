.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: WRF compilation steps on Shaheen III
    :keywords: WRF, WRF-Chem

====================================
Compiling WRF 3.9.1.1 on Shaheen III
====================================

The following steps demonstrate compilation of WRF version 3.9.1.1 on Shaheen III:

.. code-block:: bash

      wget https://www2.mmm.ucar.edu/wrf/src/WRFV3.9.1.1.TAR.gz
      tar xfz WRFV3.9.1.1.TAR.gz
      cd WRFV3
      export prgenv=gnu
      export jarg=1
      module switch PrgEnv-cray PrgEnv-gnu
      module load cray-hdf5
      module load cray-netcdf
      module load cray-parallel-netcdf
      module load craype-hugepages4M
      export HDF5=$HDF5_DIR
      export PHDF5=$HDF5_DIR
      export NETCDF=$NETCDF_DIR
      export PNETCDF=$PNETCDF_DIR
      export PNETCDF_QUILT=1
      export IBM_REDUCE_BUG_WORKAROUND=1
      export WRFIO_NCD_LARGE_FILE_SUPPORT=1
      export EM_CORE=1
      #export WRF_CHEM=1
      #export WRF_KPP=1
      export FLEX_LIB_DIR=/usr/lib64
      export JASPERLIB=/usr/lib64
      export JASPERINC=/usr/include
      export YACC="yacc -d"
      case $prgenv in
      gnu) conf=35;;
      esac
      ./configure << CONFEOF
      $conf
      1
      CONFEOF
      sed -ie  's/^FCNOOPT[[:blank:]]*=[[:blank:]]*/&  -fallow-argument-mismatch -fallow-invalid-boz /' configure.wrf
      sed -ie  's/^FCBASEOPTS_NO_G[[:blank:]]*=[[:blank:]]*/&  -fallow-argument-mismatch -fallow-invalid-boz /' configure.wrf
      sed -ie  's/^LIB[[:blank:]]*=[[:blank:]]*/&  -ltirpc /' configure.wrf
      time ./compile -j ${jarg} em_real > compile-$prgenv.log 2>&1
