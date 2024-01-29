.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>, Moamen Mohamed <moamen.mohamed@kaust.edu.sa>
.. meta::
    :description: Applications catalogue on Ibex
    :keywords: Ibex

=============================
Ibex
=============================

Compilers
---------

==============  =======  =========  ========================
System Build    App      Version    Compiler
==============  =======  =========  ========================
rl9c            R        4.0.0      rl9_gnu12.2.0
rl9c            R        4.2.2      rl9_gnu12.2.0
rl9g            cmake    3.24.2     rl9_gnu-11.2.1
rl9g            cmake    3.24.2     rl9_intel22
rl9g            cuda     11.7.1     rl9_binary
rl9g            cuda     11.8       rl9_binary
rl9g            cuda     12.2       rl9_binary
rl9g            gcc      11.1.0     rl9_binary
rl9g            gcc      11.2.0     rl9_binary
rl9g            gcc      11.3.0     rl9_binary
rl9g            gcc      12.2.0     rl9_binary
rl9g            intel    2022       rl9_binary
rl9g            java     19.0.1     rl9_binary
rl9c            java     8u162      rl9_binary
rl9c            mpich    4.0.3      rl9_gnu11.2.1
rl9g            mpich    4.0.3      rl9_gnu11.2.1_cuda11.8
rl9c            mpich    4.0.3      rl9_intel2022.3
rl9c            openmpi  4.1.4      rl9_gnu11.2.1
rl9g            openmpi  4.1.4      rl9_gnu11.2.1_cuda11.8
rl9c            openmpi  4.1.4      rl9_intel2022.3
rl9g            openmpi  4.1.4      rl9_intel2022.3_cuda11.8
rl9g            perl     5.36.0     rl9_gnu12.2.0
rl9c            perl     5.38.0     rl9_intel2022.3
rl9c            python   2.7.18     linux-rocky9-zen2
rl9c            python   2.7.18     rl9_gnu12.2.0
rl9g            python   3.11.0     rl9_gnu12.2.0
rl9g            python   3.12.1     rl9_gnu11.3.0
rl9c            python   3.9.16     rl9_gnu11.3.1
==============  =======  =========  ========================

Optimized Librarires
--------------------

==============  ==============  ===========  =============================
System Build    App             Version      Compiler
==============  ==============  ===========  =============================
rl9g            eigen           3.4.0        rl9_gnu12.2.0
rl9g            elpa            2022.11.001  openmpi4.1.4-cuda11.8
rl9c            gmp             6.2.1        rl9_gnu12.2.0
rl9c            hypre           2.27.0       rl9_gnu12.2.0
rl9c            mpi4py          3.1.4        rl9_gnu12.2.0
rl9c            mpi4py          3.1.4        rl9_openmpi4.1.4_python3.11.0
rl9g            nccl            2.17.1       cuda11.7
rl9g            nccl            2.17.1       cuda11.8
rl9g            netcdf-c        4.9.0        rl9_gnu12.2.0
rl9c            netcdf-c        4.9.0        rl9_intel2022.3
rl9g            netcdf-fortran  4.6.0        rl9_gnu12.2.0
rl9c            netcdf-fortran  4.6.0        rl9_intel2022.3
rl9c            netcdf-python   1.6.1        rl9_mpich4.0.3_netcdf
rl9c            netcdf          4.9.1        ompi414_intel22
rl9g            netcdf          4.9.1        rl9_openmpi4.1.4_intel22
rl9c            openblas        0.3.21       rl9_gnu12.2.2
rl9g            pnetcdf         1.12.3       rl9_openmpi4.1.4
rl9c            proj            9.1.1        rl9_anaconda3env
rl9c            proj            9.1.1        rl9_gnu12.2.0
rl9c            wannier90       3.1.0        rl9_intel2022.3
rl9c            wannier90       3.1.0        rl9_intel2022.3_openmpi4.1.4
==============  ==============  ===========  =============================

Computational Chemistry
-----------------------



==============  ===============  =========  ===================================
System Build    App              Version    Compiler
==============  ===============  =========  ===================================
rl9c            ambertools       22         rl9_openmpi4.1.4
rl9g            ambertools       22         rl9_openmpi4.1.4_cuda11.8
rl9c            amset            0.4.18     rl9_miniconda3
rl9c            cantera          2.6.0      rl9_anaconda3env
rl9c            cp2k             2022.2     rl9_gnu12.2.0
rl9g            greasy           2.2.3      openmpi4.1.4_gnu11.2.1_cuda11.8
rl9c            greasy           2.2.3      rl9_openmpi4.1.4
rl9c            gromacs          2022.4     rl9_openmpi4.1.4-sp
rl9c            gromacs          2023.1     rl9_openmpi4.1.4-sp
rl9g            gromacs          2023.2     rl9_openmpi4.1.4_cuda11.8
rl9g            gromacs          2023.2     rl9_openmpi4.1.4_cuda
rl9g            gromacs          2023.3     rl9_intelmpi_cuda11.8
rl9g            gromacs          2023.3     rl9_openmpi4.1.4_cuda
rl9c            gromacs          2023       rl9_openmpi4.1.4-sp
rl9g            gromacs          2023       rl9_openmpi4.1.4_cuda
rl9c            lammps           15sep2022  openmpi-4.1.4_intel2022.3
rl9c            lammps           21Nov2023  openmpi-4.1.4_gnu12.2.0
rl9c            lammps           21Nov2023  openmpi-4.1.4_intel2022.3
rl9c            lammps           2Aug2023   openmpi-4.1.4_intel2022.3
rl9c            materialstudio   2023       rl9_binary
rl9c            metis            5.1.0      rl9_gnu12.2.0
rl9c            molden           6.9        rl9_gnu12.2.0
rl9c            molpro           2012.1p16  ompi414_intel22
rl9c            molpro           2012.1p16  rl9_binary
rl9g            namd             2.14       rl9_intel2022.3
rl9c            octopus          12.0       ompi414_intel22
rl9g            octopus          12.0       rl9_openmpi4.1.4-intel2022-cuda11.8
rl9c            p4vasp           0.3.30     rl9_singularity
rl9c            packmol          20.11.1    rl9_gnu12.2.0
rl9c            parmetis         4.0.3      ompi414_intel22
rl9c            parmetis         4.0.3      rl9_gnu12.2.0
rl9g            parmetis         4.0.3      rl9_openmpi4.1.4_intel22
rl9c            phonopy          2.17.0     rl9_miniconda3
rl9c            polyrate         17-C       ompi414_intel22
rl9c            quantumespresso  7.0        rl9_openmpi4.1.4_intel2022.3
rl9g            quantumespresso  7.1        rl9_nvhpc23.1
rl9c            quantumespresso  7.2        rl9_openmpi4.1.4_intel2022.3
rl9c            shengbte         1.2.0      rl9_openmpi4.1.4-intel2022.3
rl9c            siesta           4.1.5      ompi414_intel22
rl9c            siesta           psml204    ompi414_intel22
rl9c            thirdorder       1.1.1      rl9_miniconda3_python2.7.18
rl9c            uspex            10.5       rl9_binary
rl9c            vasp             5.4.4      ompi414_intel22
rl9g            vasp             5.4.4      v100-cuda11.8
rl9c            vasp             6.3.1      ompi414_intel22
rl9c            vasp             6.4.2      ompi414_intel22
rl9g            vasp             6.4.2      v100-nvhpc23.1
rl9g            xcrysden         1.6.2      rl9_binary
rl9c            zeo++            0.3        rl9_gnu11.2.1
==============  ===============  =========  ===================================

Bioscience
----------

Computational Fluid Dynamics
----------------------------

==============  ===========  ===========  ================
System Build    App          Version      Compiler
==============  ===========  ===========  ================
rl9c            ansys        22R1-fluids  rl9_binary
rl9c            ansys        22R2-fluids  rl9_binary
rl9c            ansys        23R1-fluids  rl9_binary
rl9c            geochemfoam  4.8          rl9_gnu12.2.0
rl9c            geochemfoam  5.0          rl9_gnu12.2.0
rl9c            geochemfoam  5.0          rl9_singularity
rl9c            gerris       131206       rl9_openmpi4.1.4
rl9c            openfoam     10.0         rl9_gnu12.2.0
rl9c            openfoam     2206         rl9_gnu12.2.0
rl9c            openfoam     2212         rl9_gnu12.2.0
rl9c            openfoam     4.x          el7.9_gnu6.4.0
rl9c            openfoam     9.0          rl9_gnu12.2.0
rl9g            paraview     5.11.0       gnu11.2.1-egl
rl9g            paraview     5.11.0       gnu11.2.1-mesa
==============  ===========  ===========  ================

Data Science
------------

==============  ================  =========  ==============================
System Build    App                 Version  Compiler
==============  ================  =========  ==============================
rl9g            machine_learning    2023.01  rl9_cudnn8_cuda11.8_py3.9_env
rl9g            machine_learning    2023.09  rl9_cudnn8_cuda11.8_py3.9_env
rl9g            machine_learning    2024.01  rl9_cudnn8_cuda11.8_py3.10_env
rl9g            machine_learning    2024.01  rl9_cudnn8_cuda11.8_py3.9_env
==============  ================  =========  ==============================

Others
------

==============  ================  ==========  =============================
System Build    App               Version     Compiler
==============  ================  ==========  =============================
rl9c            adf               2019.301    rl9_binary
rl9c            aescrypt          3.16        rl9_gnu12.2.0
rl9c            ams               2022.103    rl9_binary
rl9c            ams               2023.103    rl9_binary
rl9c            atk               2019.03sp1  rl9_binary
rl9c            bionano           solve3.4    rl9_binary
rl9g            blas              3.11.0      rl9_gnu12.2.0
rl9c            blas              3.11.0      rl9_intel2022.3
rl9g            boost             1.80.0      rl9_gnu12.2.0_openmpi4.1.4
rl9g            boost             1.83.0      boost-1.83.0
rl9g            boost             1.83.0      openmpi-4.1.4-gcc-11.3.0
rl9g            boost             1.83.0      rl9_gnu12.2.0_openmpi4.1.4
rl9g            boost             1.84.0      rl9_gnu11.3.0_openmpi4.1.4
rl9g            bzip2             1.0.8       rl9_gnu12.2.0
rl9c            cgal              4.13        rl9_gnu12.2.0
rl9c            cgal              4.14.2      rl9_gnu12.2.0
rl9c            cgal              5.5.1       rl9_gnu12.2.0
rl9c            cgal              5.5.2       rl9_gnu12.2.0
rl9c            curl              7.86.0      rl9_gnu12.2.0
rl9c            curl              7.86.0      rl9_intel2022.3
rl9g            dualsphysics      5.2.269     rl9_gnu11.3.0_cuda11.7
rl9c            dualsphysics      5.2.269     rl9_gnu12.2.0
rl9c            etsf_io           1.0.4       intel22
rl9g            etsf_io           1.0.4       rl9_intel22
rl9g            fftw              3.3.10      fftw-3.3.10
rl9g            fftw              3.3.10      rl9_gnu11.3_ompi4.1.4_dp
rl9g            fftw              3.3.10      rl9_gnu11.3_ompi4.1.4_sp
rl9c            fftw              3.3.10      rl9_gnu12.2.0_ompi4.1.4-dp
rl9c            fftw              3.3.10      rl9_gnu12.2.0_ompi4.1.4-ldp
rl9c            fftw              3.3.10      rl9_gnu12.2.0_ompi4.1.4-sp
rl9c            fftw              3.3.10      rl9_intel2022.3_ompi4.1.4-dp
rl9c            fftw              3.3.10      rl9_intel2022.3_ompi4.1.4-ldp
rl9c            fftw              3.3.10      rl9_intel2022.3_ompi4.1.4-sp
rl9c            fhiaims           210716_2    ompi414_intel22
rl9c            foamextend        4.0         el7_gnu6.4.0
rl9c            foamextend        4.0         rl9_gnu12.2.0
rl9c            gaussian09        d.01        rl9_binary
rl9g            gaussian16        c.02        rl9_binary
rl9c            gdal              3.5.1       rl9_anaconda3env
rl9c            gdal              3.6.2       rl9_gnu12.2.0
rl9g            gdrcopy           2.3         rl9_cuda11.8.0
rl9c            geos              3.12.1      rl9_gnu11.3.1
rl9c            gifsicle          1.94        rl9_gnu12.2.0
rl9g            go                1.19.4      rl9_binary
rl9c            gsl               2.4         rl9_gnu12.2.0
rl9g            gsl               2.7.1       rl9_gnu12.2.0
rl9g            gsl               2.7.1       rl9_intel2022.3
rl9g            hdf5              1.12.2      rl9_gnu12.2.0_ompi4.1.4
rl9c            hdf5              1.12.2      rl9_intel2022.3_ompi4.1.4
rl9g            hdf5              1.14.3      gnu11.3.0-openmpi4.1.4
rl9g            imagemagick       7.1.1       rl9_gnu12.2.0
rl9g            lapack            3.11.0      rl9_gnu11.3.0
rl9g            lapack            3.11.0      rl9_gnu12.2.0
rl9c            lapack            3.11.0      rl9_intel2022.3
rl9c            libgd             2.2.5       intel22
rl9c            libgd             2.2.5       rl9_gnu12.2.0
rl9g            libgd             2.2.5       rl9_intel22
rl9g            libpng            1.6.38      rl9_gnu12.2.0
rl9g            libpng            1.6.38      rl9_intel2022.3
rl9c            libtogl           2.0         rl9_binary
rl9c            libxc             4.3.4       intel22
rl9c            libxc             4.3.4       rl9_gnu12.2.0
rl9g            libxc             4.3.4       rl9_intel22
rl9c            mesagl            17.3.9      linux-x86_64_gcc-8.2
rl9c            mopac             22.1.0      rl9_gcc11.3.1
rl9c            mpfr              4.1.1       rl9_gnu12.2.0
rl9c            mrcc              2017-09-25  ompi414_intel22
rl9c            mstor             2022        rl9_intel2022.3
rl9g            nvidia_sdk_nvhpc  22.11       rl9_binary
rl9g            nvidia_sdk_nvhpc  23.1        rl9_binary
rl9c            pcre2             10.40       rl9_gnu12.2.0
rl9c            perturbo          2.2.0       rl9_intel2022.3
rl9c            pfft              20230206    ompi414_intel22
rl9c            psolver           1.9.3       ompi414_intel22
rl9c            pstoedit          4.0         rl9_gnu12.2.0
rl9c            pyprocar          5.6.6       rl9_binary
rl9c            qt                5.15.5      rl9_gnu12.2.0
rl9c            readline          6.3         rl9_gnu12.2.0
rl9g            readline          7.0         rl9_gnu12.2.0
rl9c            readline          8.2         rl9_gnu12.2.0
rl9c            reframe           4.1.1       rl9_binary
rl9c            reframe           4.4.1       rl9_binary
rl9c            sparskit2         20190610    intel22
rl9g            sparskit2         20190610    rl9_intel22
rl9c            spglib            1.16.2      rl9_gnu12.2.0
rl9g            sqlite            3.40.1      rl9_gnu12.2.0
rl9c            stringtie         1.3.5       rl9_gnu12.2.0
rl9c            tcl               8.6.13      rl9_intel2022.3
rl9g            tcltk             8.6.7       rl9_binary
rl9c            texinfo           7.0         rl9_gnu12.2.0
rl9c            turbomole         6.6         rl9_binary
rl9c            turbomole         7.1         rl9_binary
rl9g            ucx               1.13.1      rl9_gnu11.2.1
rl9c            vaspkit           1.4.1       rl9_binary
rl9c            vaspkit           anaconda3   x86_64-conda-linux-gnu
rl9c            vaspkit           anaconda3   x86_64-conda_cos7-linux-gnu
rl9c            xsorb             1.0         rl9_gnu12.2.0
rl9g            zlib              1.2.13      rl9_gnu12.2.0
rl9g            zlib              1.2.13      rl9_intel2022.3
rl9g            zlib              1.3         rl9_gnu11.3.0
==============  ================  ==========  =============================
