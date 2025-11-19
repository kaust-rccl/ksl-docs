.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Updates after December 2025 Maintenance
    :keywords: modules, shaheen, maintenance


.. _2025-12-prgenv-modules:

===================================================================================================
Changes in the Programming Environment after December 2025 Maintenance - Recompile Your Applications
===================================================================================================

Recompile your applications!
============================


The recent operating system (OS) update (December 2025) applied to Shaheen includes changes to the modules with more recent versions of compilers and libraries. 
We recommend recompiling all your applications. 
All available libraries and software listed by the ``module avail`` are compiled and linked with the latest CPE 25.03.

Please note that the older CPE 24.07 and 24.11 are still available and will be deleted in the future. A newer CPE (25.09) is also available, though it has not been set as the default. 


..
   cat test.txt |sed '/^$/d' |awk '{print "   * - "$1;print "     - **"$2"**"}'

.. list-table:: **A partial list of updated modules for the programming environment**
   :widths: 10 10
   :header-rows: 1

   * - CPE 24.07 old default modules 
     - **New CPE 25.03 default modules**
   * - PrgEnv-amd/8.5.0
     - **PrgEnv-amd/8.6.0**
   * - PrgEnv-aocc/8.5.0
     - **PrgEnv-aocc/8.6.0**
   * - PrgEnv-cray/8.5.0
     - **PrgEnv-cray/8.6.0**
   * - PrgEnv-cray-amd/8.5.0
     - **PrgEnv-cray-amd/8.6.0**
   * - PrgEnv-gnu/8.5.0
     - **PrgEnv-gnu/8.6.0**
   * - PrgEnv-gnu-amd/8.5.0
     - **PrgEnv-gnu-amd/8.6.0**
   * - PrgEnv-intel/8.5.0
     - **PrgEnv-intel/8.6.0**
   * - atp/3.15.4
     - **atp/3.15.6**
   * - cce/18.0.0
     - **cce/19.0.0**
   * - cpe/24.07
     - **cpe/25.03**
   * - cray-R/4.4.0
     - **cray-R/4.4.0**
   * - cray-ccdb/5.0.4
     - **cray-ccdb/5.0.6**
   * - cray-cti/2.18.4
     - **cray-cti/2.19.1**
   * - cray-dsmml/0.3.0
     - **cray-dsmml/0.3.1**
   * - cray-dyninst/12.3.2
     - **cray-dyninst/12.3.5**
   * - cray-fftw/3.3.10.8
     - **cray-fftw/3.3.10.10**
   * - cray-hdf5/1.14.3.1
     - **cray-hdf5/1.14.3.5**
   * - cray-hdf5-parallel/1.14.3.1
     - **cray-hdf5-parallel/1.14.3.5**
   * - cray-libpals/1.2.12
     - **Not available any more**
   * - cray-libsci/24.07.0
     - **cray-libsci/25.03.0**
   * - cray-libsci_acc/24.07.0
     - **cray-libsci_acc/25.03.0**
   * - cray-mpich/8.1.30
     - **cray-mpich/8.1.32**
   * - cray-mpich-abi/8.1.30
     - **cray-mpich-abi/8.1.32**
   * - cray-mpich-abi-pre-intel-5.0/8.1.30
     - **cray-mpich-abi-pre-intel-5.0/8.1.32**
   * - cray-mpich-ucx/8.1.30
     - **cray-mpich-ucx/8.1.32**
   * - cray-mpixlate/1.0.5
     - **cray-mpixlate/1.0.7**
   * - cray-mrnet/5.1.3
     - **cray-mrnet/5.1.5**
   * - cray-netcdf/4.9.0.13
     - **cray-netcdf/4.9.0.17**
   * - cray-netcdf-hdf5parallel/4.9.0.13
     - **cray-netcdf-hdf5parallel/4.9.0.17**
   * - cray-openshmemx/11.7.2
     - **cray-openshmemx/11.7.4**
   * - cray-pals/1.2.12
     - **Not available any more**
   * - cray-parallel-netcdf/1.12.3.13
     - **cray-parallel-netcdf/1.12.3.17**
   * - cray-pmi/6.1.15
     - **cray-pmi/6.1.15**
   * - cray-python/3.11.7
     - **cray-python/3.11.7**
   * - cray-stat/4.12.3
     - **cray-stat/4.12.5**
   * - cray-ucx/1.14.0
     - **cray-ucx/1.14.0**
   * - cray-zmqnet/1.0.0
     - **cray-zmqnet/1.3.1**
   * - craype/2.7.32
     - **craype/2.7.34**
   * - craype-dl-plugin-ftr/22.06.1.2
     - **craype-dl-plugin-ftr/22.06.1.2**
   * - craype-dl-plugin-py3/24.03.1
     - **craype-dl-plugin-py3/24.03.1**
   * - craypkg-gen/1.3.33
     - **craypkg-gen/1.3.35**
   * - gcc/12.2.0
     - **Not available any more**
   * - gcc-native/13.2
     - **gcc-native/14.2**
   * - gdb4hpc/4.16.2
     - **gdb4hpc/4.16.4**
   * - iobuf/2.0.10
     - **iobuf/2.0.10**
   * - papi/7.1.0.2
     - **papi/7.2.0.1**
   * - perftools-base/24.07.0
     - **perftools-base/25.03.0**
   * - sanitizers4hpc/1.1.3
     - **sanitizers4hpc/1.1.5**
   * - valgrind4hpc/2.13.3
     - **valgrind4hpc/2.13.5**


