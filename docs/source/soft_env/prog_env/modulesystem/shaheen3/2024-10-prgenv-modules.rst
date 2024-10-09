.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Updates after October 2024 Maintenance
    :keywords: modules, shaheen, maintenance


.. _2024-10-prgenv-modules:

===================================================================================================
Changes in the Programming Environment after October 2024 Maintenance - Recompile Your Applications
===================================================================================================

Recompile your applications!
============================


The recent operating system (OS) update applied to Shaheen included changes to the modules with more recent versions of compilers and libraries. We recommend recompiling all your applications. All default libraries and software listed by the ``module avail`` command are compiled and linked with the latest CPE 24.07.

Please note that the old CPE 23.09 and 23.12 are still available and will be deleted in the future.

Two new PrgEnv's have been added:

* PrgEnv-gnu-amd: This environment is useful when you want to utilize GCC for Fortran code but need AMD's Clang C/C++ compiler for better optimization of C and C++ code. It is particularly helpful in situations where specific C/C++ code optimization is crucial.

* PrgEnv-cray-amd: This is used when you prefer using the Cray Compiling Environment for its advanced optimization capabilities for Fortran code, but also want to leverage the AMD Clang compiler for C/C++ code. It is beneficial when working with mixed-language applications that need specific optimizations provided by both Cray and AMD.

..
   cat test.txt |awk '{print "   * - "$1;print "     - **"$2"**"}'

.. list-table:: **A partial list of updated modules for the programming environment**
   :widths: 10 10
   :header-rows: 1

   * - CPE23.09 old default modules
     - New CPE 24.07 default modules
   * - cce/16.0.1
     - **cce/18.0.0**
   * - gcc-native/12.3
     - **gcc-native/13.2**
   * - cpe/23.09
     - **cpe/24.07**
   * - cray-mpich/8.1.27
     - **cray-mpich/8.1.30**
   * - cray-libsci/23.09.1.1
     - **cray-libsci/24.07.0**
   * - cray-fftw/3.3.10.5
     - **cray-fftw/3.3.10.8**
   * - cray-hdf5/1.12.2.7
     - **cray-hdf5/1.14.3.1**
   * - cray-hdf5-parallel/1.12.2.7
     - **cray-hdf5-parallel/1.14.3.1**
   * - cray-netcdf/4.9.0.7
     - **cray-netcdf/4.9.0.13**
   * - cray-parallel-netcdf/1.12.3.7
     - **cray-parallel-netcdf/1.12.3.13**
   * - cray-netcdf-hdf5parallel/4.9.0.7
     - **cray-netcdf-hdf5parallel/4.9.0.13**
   * - cray-mpich-abi/8.1.27
     - **cray-mpich-abi/8.1.30**
   * - cray-mpich-abi-pre-intel-5.0/8.1.27
     - **cray-mpich-abi-pre-intel-5.0/8.1.30**
   * - cray-mpich-ucx/8.1.27
     - **cray-mpich-ucx/8.1.30**
   * - cray-mpixlate/1.0.2
     - **cray-mpixlate/1.0.5**
   * - cray-mrnet/5.1.1
     - **cray-mrnet/5.1.3**
   * - cray-openshmemx/11.6.1
     - **cray-openshmemx/11.7.2**
   * - cray-pmi/6.1.12
     - **cray-pmi/6.1.15**
   * - cray-python/3.10.10
     - **cray-python/3.11.7**
   * - cray-stat/4.12.1
     - **cray-stat/4.12.3**
   * - cray-R/4.2.1.2
     - **cray-R/4.4.0**
   * - craype/2.7.30
     - **craype/2.7.32**
   * - craype-dl-plugin-ftr/22.06.1.2
     - **craype-dl-plugin-ftr/22.06.1.2**
   * - craype-dl-plugin-py3/22.12.1
     - **craype-dl-plugin-py3/24.03.1**
   * - craypkg-gen/1.3.30
     - **craypkg-gen/1.3.33**
   * - atp/3.15.1
     - **atp/3.15.4**
   * - gdb4hpc/4.15.1
     - **gdb4hpc/4.16.2**
   * - iobuf/2.0.10
     - **iobuf/2.0.10**
   * - papi/7.0.1.1
     - **papi/7.1.0.2**
   * - perftools-base/23.09.0
     - **perftools-base/24.07.0**
   * - sanitizers4hpc/1.1.1
     - **sanitizers4hpc/1.1.3**
   * - valgrind4hpc/2.13.1
     - **valgrind4hpc/2.13.3**
   * - PrgEnv-aocc/8.4.0
     - **PrgEnv-aocc/8.5.0**
   * - PrgEnv-cray/8.4.0
     - **PrgEnv-cray/8.5.0**
   * - PrgEnv-gnu/8.4.0
     - **PrgEnv-gnu/8.5.0**
   * - PrgEnv-intel/8.4.0
     - **PrgEnv-intel/8.5.0**
   * - cray-ccdb/5.0.1
     - **cray-ccdb/5.0.4**
   * - cray-cti/2.18.1
     - **cray-cti/2.18.4**
   * - cray-dsmml/0.2.2
     - **cray-dsmml/0.3.0**
   * - cray-dyninst/12.3.0
     - **cray-dyninst/12.3.2**
