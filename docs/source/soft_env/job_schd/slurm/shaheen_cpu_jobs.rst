.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Shaheen III CPU jobs examples
    :keywords: Shaheen III, MPI, OpenMP 
.. _shaheen_cpu_jobs:

=========
CPU jobs
=========
Shaheen III compute nodes in ``workq`` are of AMD Genoa microarchitecture (AMD EPYC 9654).
Each compute node has 2 sockets (i.e. 2 AMD Genoa), each with 96 physical cores, making a total of 192 cores.
Each physical core is presented as 2 logical CPUs (formally known as hyperthreads), thus making a total of 384 useable threads on each compute node.

For details on the design of Genoa processors please refer to the section :ref:`shaheen3_compute_nodes`. 
The locality of these cores with respect their proximity to main memory is important from application performance point of view. 
It ensures your application gets the best possible memory bandwidth from each memory channel.
In short, the compute node has 8 NUMA nodes in total, i.e. 4 on each socket.    
The jobscripts below examplify how the MPI and OpenMP processes are mapped by default and can that behavior be modified.


Serial jobs
------------
A serial job is characterized as when the application is capable of running on 1 thread. Although this is an overkill and your account will be charged at the full 192 core hours, it is sometimes justified to run on an exclusive node. 
These job may require the whole memory available on these compute nodes.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=1
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    #SBATCH --mem=376G

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    srun --hint=nomultithread ./a.out


If your application does not require a lot memory, it is recommended that you run on ``shared`` partition which allows sharing of compute nodes between different jobs and charges the same core hours as the requested number of cores.
With the following example jobscript, your job will get 2 CPUs (1 physical core) and 1 GB memory.  

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=shared
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    
    scontrol show job ${SLURM_JOBID}
    
    # load your software environment here:

    srun ./a.out


Multithreaded (OpenMP) jobs
----------------------------
The following jobscript demonstrates an OpenMP job launched on compute nodes of Shaheen III.
Here half of the on a socket are used for the OpenMP threads.  


.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=96
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
    srun --hint=nomultithread -n ${SLURM_NTASKS} -c ${SLURM_CPUS_PER_TASK} --cpu-bind=threads ./a.out

.. note::
    - Performance of an OpenMP application is sensitive to multiple factors. One very important feature the OpenMP code adheres to the ``first touch`` data placement policy. It ensures that each OpenMP thread allocates memory after getting created which implies that the memory will be allocated in it local NUMA domain. 
    - OpenMP implements shared memory model. Please benchmark your OpenMP application to identify the optimum number of cores without loss of computational performance.   
    
MPI jobs
----------
Below is an example jobscript launching 192 MPI processes on a single compute node of Shaheen III. 
Note that the MPI process will be placed in round-robin fashion by default. This means that ``rank 0`` will be pinned to ``core 0`` on ``socket 0`` and ``rank 1`` on ``core 96`` of ``socket 1``.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=192
    #SBATCH --cpus-per-task=1
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    export OMP_NUM_THREADS=1
    srun --hint=nomultithread -n ${SLURM_NTASKS} -c ${SLURM_CPUS_PER_TASK} --cpu-bind=cores ./a.out


The jobscript below is an example for placing the MPI processes in a linear fashion, such that ``rank 0`` to ``rank 95`` are pinned on ``core 0`` to ``core 95`` respectively on ``socket 0`` and ``rank 96`` to ``rank 191`` on  ``core 96`` to ``core 191`` of ``socket 1``.


.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=192
    #SBATCH --cpus-per-task=1
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    export OMP_NUM_THREADS=1
    srun --hint=nomultithread -n ${SLURM_NTASKS} -c ${SLURM_CPUS_PER_TASK} -m block:block ./a.out

Hybrid jobs with MPI and OpenMP
---------------------------------


Requesting Large memory nodes
------------------------------