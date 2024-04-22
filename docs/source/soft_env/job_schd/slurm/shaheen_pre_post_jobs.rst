.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Shaheen III Pre/Post processing Jobs 
    :keywords: Shaheen III, l40, gpus, large memory, dtn, ppn, copy

.. _shaheen_pre_post_jobs:

=========================
Pre/Post processing jobs
=========================

There are steps in workflows whose requirement do not essentially fit to the compute nodes in ``workq`` or ``shared`` partition can cater. Such steps may involve moving data, preprocessing steps like mesh generation requiring larger memory than 375GB, or postprocessing step requiring access to graphics GPU. In such case, ShaheenIII maintains compute nodes accessible through different partitions to submit these steps as batch jobs.

Copy jobs
==========
Copy jobs are best run on dedicated data transfer node or ``dtn`` nodes. 
Jobs that require moving data e.g. 
* between tiers of scratch  ``/scratch/$USER/`` to ``/scratch/$USER/bandwidth`` and back
* between ShaheenIII project and scratch
* between Ibex and ShaheenIII filesystem
* downloading data from internet in project or scratch

.. note:: 

    On compute nodes in ``dtn`` partition, all the filesystems, ``scratch``, ``project`` and ``home`` are mounted and accessible with read/write permissions. 

The following example jobscript demonstrates moving big data between project and scratch. ``dcp`` is a parallel utilize which, in the jobscript below, runs on 8 processes and moves a large number of files from <source> to <destination> directory. Other utilities such as ``scp`` and ``rsync`` can also be used in the same way. For details on use of these utilities, check the documentation on :ref:`data_management` 

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=dtn
    #SBATCH --ntasks=8
    #SBATCH --account=k#####

    module swap PrgEnv-cray PrgEnv-gnu
    module load mpifileutils
    module list
    time -p srun -n ${SLURM_NTASKS} dcp --verbose --progress 60 --preserve <source_dir> <dest_dir>



Requesting a GPU with graphics support
=======================================
Shaheen III has nodes with GPUs with graphics support for post processing and visualization functionalities. These nodes can be accessed by submitting jobs with specific SLURM directives in ``ppn`` partition. 

Below is an example jobscript on how to run a batch job on these node:


.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=ppn
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=128
    #SBATCH --gres=gpu:1
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    srun -n 1 ./a.out


Jobs on Large memory nodes
============================

Some steps of workflow may require more memory on a node than that available on the compute nodes in ``workq`` partition. The ``ppn`` partition has a few compute nodes with large memory. Please refer to the :ref:`shaheen3_compute_nodes` for details on the available nodes. The following jobscript demonstrates submitting a batch job with a request of 2TB memory and 256 CPUs to run multiple OpenMP threads.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=ppn
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=256
    #SBATCH --mem=2T
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    
    export OMP_NUM_THREADS=256
    srun -c $OMP_NUM_THREADS ./a.out