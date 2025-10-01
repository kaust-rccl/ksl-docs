.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: mpi4py
    :keywords: mpi4py

.. _mpi4py:

==========================================
mpi4py
==========================================

``mpi4py`` is a Python package that provides binding to functions in Message Passing Interface (MPI) library written in C language. It allows distributed memory applications to communicate between Linux processes either on the same or remote machine. 

There are more than one ways to use ``mpi4py`` on KSL systems. You can either use the preinstalled package with a managed Python, or install your own in a conda or virtual environment. Either way, ``mpi4py`` links to a preinstalled MPI library to, may it be OpenMPI or MPICH to fulfill the calls for interprocessor communications.  

``mpi4py`` on Shaheen III
===========================

Shaheen III uses Cray MPICH library which is based on MPICH distribution of MPI library.

To use the ``mpi4py`` package maintained by the KSL applications team, simply load the module and run your parallel job. Below is an example jobscript demonstrating the same:

.. code-block:: bash

    #!/bin/bash
    
    #SBATCH -n 4 
    #SBATCH -N 4
    #SBATCH --hint=nomultithread
    
    module load python
    
    srun -n ${SLURM_NTASKS} -N ${SLURM_NNODES} --hint=nomultithread python myMPIscript.py


For using ``mpi4py`` in a self-managed Python, in a conda environment, first the package needs to be installed correctly. Assuming you have created a conda environment using the instructions provided in :ref:`conda_shaheen3` ``mpi4py`` can be compiled as show below. Here the example assumes the name of the conda environment ``myenv`` and the desired version of ``mpi4py`` is 3.1.4.

.. code-block:: bash

    conda activate myenv
    env MPICC=cc pip install mpi4py==3.1.4

To use the installed package the jobscript can be modified as follows:

.. code-block:: bash

    #!/bin/bash
    
    #SBATCH -n 4 
    #SBATCH -N 4
    #SBATCH --hint=nomultithread
    
    source $MY_SW/miniconda3-amd64/bin/activate myenv
    
    srun -n ${SLURM_NTASKS} -N ${SLURM_NNODES} --hint=nomultithread python myMPIscript.py



