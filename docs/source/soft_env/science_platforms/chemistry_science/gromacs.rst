.. sectionauthor:: Mohamed Elgharawy <mohamed.elgharawy@kaust.edu.sa>
.. meta::
    :description: Using Gromacs on Ibex GPUs
    :keywords: Gromacs, Chemistry

====================================
Using Gromacs on Ibex GPUs
====================================

Getting Gromacs image from DockerHub
=======================================

The image is available on Krccl DockerHub, you can pull it on ibex with the commands:

.. note::

    This is only needed for first time, the image will be saved as a new file named gromacs_latest.sif

.. code-block:: bash

    module load singularity
    singularity pull gromacs_latest.sif docker://krccl/gromacs:latest


Single node example
=======================

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name="gromacs_gpu"
    #SBATCH --ntasks=2
    #SBATCH --ntasks-per-node=2
    #SBATCH --output=%J.out
    #SBATCH --error=%J.err
    #SBATCH --time=0:10:0
    #SBATCH --gpus=2
    #SBATCH --cpus-per-task=16
    #SBATCH --mem=80G
    #----------------------------------------------------------#
    module load singularity
    module load openmpi/4.1.4/gnu11.2.1-cuda11.8
    #----------------------------------------------------------#
    echo "The job "${SLURM_JOB_ID}" is running on "${SLURM_JOB_NODELIST}
    #----------------------------------------------------------#
    export GMX_ENABLE_DIRECT_GPU_COMM=1
    export GMX_GPU_PME_DECOMPOSITION=1
    #----------------------------------------------------------#

    mpirun -np 2 singularity run --nv -B /ibex/user/$USER gromacs_latest.sif gmx_mpi mdrun -deffnm topol -s topol.tpr -nb gpu -pme gpu -npme 1 -update gpu -bonded gpu -nsteps 100000 -resetstep 90000 -noconfout -dlb no -nstlist 300 -pin on


Multi node example
=====================

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name="gromacs_gpu"
    #SBATCH --ntasks=2
    #SBATCH --ntasks-per-node=1
    #SBATCH --output=%J.out
    #SBATCH --error=%J.err
    #SBATCH --time=0:10:0
    #SBATCH --gpus=2
    #SBATCH --cpus-per-task=16
    #SBATCH --mem=80G
    #----------------------------------------------------------#
    module load singularity
    module load openmpi/4.1.4/gnu11.2.1-cuda11.8
    #----------------------------------------------------------#
    echo "The job "${SLURM_JOB_ID}" is running on "${SLURM_JOB_NODELIST}
    #----------------------------------------------------------#
    export GMX_ENABLE_DIRECT_GPU_COMM=1
    export GMX_GPU_PME_DECOMPOSITION=1
    #----------------------------------------------------------#

    mpirun -np 2 singularity run --nv -B /ibex/user/$USER gromacs_latest.sif gmx_mpi mdrun -deffnm topol -s topol.tpr -nb gpu -pme gpu -npme 1 -update gpu -bonded gpu -nsteps 100000 -resetstep 90000 -noconfout -dlb no -nstlist 300 -pin on