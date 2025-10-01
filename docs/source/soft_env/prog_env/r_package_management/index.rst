.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Self managed Python packages
    :keywords: conda, Shaheen III, Ibex, pip, python

.. _r_package_management:


============================================
Self-Managed R packages  
============================================

R is a powerful language and is popular programming language for Bioinformatics, statistics and Data science. 

On Shaheen III we recommend using Cray’s R installation for interactively using via R CLI or preferably batch processing of R scripts.

Using R on Shaheen III
========================

.. _interactive_r_shaheen:

R interactive shell 
---------------------------------------
To run R interactively on a compute node of Shaheen III, first request a compute node with 192 dedicated threads. This will also give you access to ~384GB of memory:

.. code-block:: bash
    
    salloc -t 01:00:00 --hint=nomultithread -n 1 -c 192

Once allocated, you will still be on login node. Please do the following additional step to get onto the node:

.. code-block:: bash

    srun -c 192 --hint=nomultithread --pty bash

You can now load the module and run R:

.. code-block:: bash

    module load cray-R

Now we are ready to fire up an interactive R session.

.. code-block:: bash

    > R

    R version 4.2.1 (2022-06-23) -- "Funny-Looking Kid"
    Copyright (C) 2022 The R Foundation for Statistical Computing
    Platform: x86_64-suse-linux-gnu (64-bit)

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    Natural language support but running in an English locale

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

    > installed.packages()    
            Package      LibPath                                  Version  
    base       "base"       "/opt/cray/pe/R/4.2.1.2/lib64/R/library" "4.2.1"  
    boot       "boot"       "/opt/cray/pe/R/4.2.1.2/lib64/R/library" "1.3-28" 
    ....
    grid       "grid"       "/opt/cray/pe/R/4.2.1.2/lib64/R/library" "4.2.1"  
    KernSmooth "KernSmooth" "/opt/cray/pe/R/4.2.1.2/lib64/R/library" "2.23-20"
    lattice    "lattice"    "/opt/cray/pe/R/4.2.1.2/lib64/R/library" "0.20-45"
    MASS       "MASS"       "/opt/cray/pe/R/4.2.1.2/lib64/R/library" "7.3-57" 
    Matrix     "Matrix"     "/opt/cray/pe/R/4.2.1.2/lib64/R/library" "1.4-1"  
    methods    "methods"    "/opt/cray/pe/R/4.2.1.2/lib64/R/library" "4.2.1"  
    ....

Installing new packages
---------------------------------------

For installing new packages, we recommend you install them in your own directory accessible via the environment variable ``${MY_SW}``. For this you will need to set an environment variable ``R_LIBS_USER=${MY_SW}/rlibs``.

.. code-block:: bash

    export R_LIBS_USER=${MY_SW}/rlibs
    mkdir -p ${R_LIBS_USER}


Then start the interactive session:

.. code-block:: bash

    > R

    R version 4.2.1 (2022-06-23) -- "Funny-Looking Kid"
    Copyright (C) 2022 The R Foundation for Statistical Computing
    Platform: x86_64-suse-linux-gnu (64-bit)

    R is free software and comes with ABSOLUTELY NO WARRANTY.
    You are welcome to redistribute it under certain conditions.
    Type 'license()' or 'licence()' for distribution details.

    Natural language support but running in an English locale

    R is a collaborative project with many contributors.
    Type 'contributors()' for more information and
    'citation()' on how to cite R or R packages in publications.

    Type 'demo()' for some demos, 'help()' for on-line help, or
    'help.start()' for an HTML browser interface to help.
    Type 'q()' to quit R.

And install the package:

.. code-block:: bash

    > install.packages('readxl')

Here, as an example, I install ``readxl`` package. Please note that this will ultimately be installed in the directory pointed to by ``R_LIBS_USER`` variable set earlier. If you don’t set the variable, R will try to install it in the root directory of R and it will fail due to permissions issue. 

Passing compiler configuration FLAGs
--------------------------------------

Sometime R requires extra help to get directions where include headers and dynamic libraries are located. This is usually needed in the configure step of C , C++, or Fortran codes. For example, the following is a package that depends on NetCDF and requires headers information where they are. These flags can be listed in a file ``${SCRATCH}/.R/Makevars`` and R will honour them when compiling the package.

The following steps are executed in an interactive session on a Shaheen III compute node. Note that internet access is only on nodes in SLURM partition ``ppn``. Please allocate a compute node for an interactive R session in this partition:

.. code-block:: bash

    srun -n 1 -c 192 -t 0:30:0 -p ppn --pty bash
    module swap PrgEnv-cray PrgEnv-gnu
    module swap craype-x86-genoa craype-x86-milan
    module load cray-netcdf
    module load cray-R

Create the ``Makevars`` if it doesn’t already exist:

.. code-block:: bash
    
    mkdir -p ${SCRATCH}/.R
    touch ${SCRATCH}/.R/Makevars

The contents of ``Makevars`` can be:

.. code-block:: bash

    CC=cc
    CXX=CC
    FC=ftn
    CFLAGS=-I/opt/cray/pe/netcdf/4.9.0.7/GNU/9.1/include
    LDFLAGS=-L/opt/cray/pe/netcdf/4.9.0.7/GNU/9.1/lib

Now we can call the package installer either in a ''R''' interactive session or with ''R CMD INSTALL'' command line interface.

.. code-block:: bash 

    > R
    R version 4.2.1 (2022-06-23) -- "Funny-Looking Kid"
    Copyright (C) 2022 The R Foundation for Statistical Computing
    Platform: x86_64-suse-linux-gnu (64-bit)
    .....
    > install.packages('ncdf4')
    Installing package into '/lustre/scratch/project/k01/exclude/shaima0d/tickets/48534/libs'
    (as 'lib' is unspecified)
    --- Please select a CRAN mirror for use in this session ---
    Secure CRAN mirrors 
    1: 0-Cloud [https]
    2: Australia (Canberra) [https]
    ....

    **********************  Results of ncdf4 package configure *******************
    
    netCDF v4 CPP flags      = -DpgiFortran
    netCDF v4 LD flags       =    
    netCDF v4 runtime path   =  
    
    netCDF C compiler used   = cc
    R      C compiler used   = cc -I/opt/cray/pe/netcdf/4.9.0.7/GNU/9.1/include
    
    ******************************************************************************

    .....

Running R jobs
-----------------
For using the installed package, please set the ``R_LIBS_USER`` variable before you call the ``R`` package:

Interactive session
********************

Please refer to section :ref:`interactive_r_shaheen`.

R batch job
************************
To run a batch job using ``R script``, simply prepare the script are use ``Rscript`` in your SLURM jobscript to launch it. The following jobscript demonstrates a hello world example run as a batch job:

This is an example R script called ``pi.R``

.. code-block:: bash

    simulation = function(long){
    c = rep(0,long)
    numberIn = 0
    for(i in 1:long){
        x = runif(2,-1,1)
        if(sqrt(x[1]*x[1] + x[2]*x[2]) <= 1){
        numberIn = numberIn + 1
        }
        prop = numberIn / i
        piHat = prop *4
        c[i] = piHat
    }
    return(c)
    }
    size = 1000
    res = simulation(size)
    sprintf('calculated Pi value= %f',res[size])

The SLURM jobscript to execute the above script will look as follows:

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=192
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    module load cray-R
    export R_LIBS_USER=${MY_SW}/rlibs
    export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
    srun --hint=nomultithread -n ${SLURM_NTASKS} -c ${OMP_NUM_THREADS} --cpu-bind=cores Rscript ./pi.R


