.. sectionauthor:: Kadir Akbudak  <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Quick start for using singularity container on Shaheen III
    :keywords: container, singularity, shaheen3

.. _use_singularity_images:

================================================
Quick Start for Using Singularity on Shaheen III
================================================

A singularity image can be pulled as follows:

.. code-block:: bash

    module load singularity
    cd $HOME && mkdir -p tmpdir
    export SINGULARITY_TMPDIR=$HOME/tmpdir
    singularity pull docker://krccl/cdo_gnu:1.9.10
    mkdir -p $MY_SINGULARITY_IMAGES
    cp ~/cdo_gnu_1.9.10.sif $MY_SINGULARITY_IMAGES
    cd $MY_SINGULARITY_IMAGES
    singularity run cdo_gnu_1.9.10.sif cdo --version

The following SLURM job script runs the container:

.. code-block:: bash

   #!/bin/bash
   #SBATCH --nodes=1
   #SBATCH --hint=nomultithread
   #SBATCH --time=00:10:00

   module load singularity
   singularity run cdo_gnu_1.9.10.sif cdo --version
