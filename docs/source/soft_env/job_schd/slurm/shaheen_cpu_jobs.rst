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


.. important::
    Not all filesystems are available for access on all compute nodes. Additionally, internet access is available on a subset of compute nodes. Following is the list of notable differences:

     * On compute nodes in ``workq``, ``shared`` and ``72hours`` partition

       - ``scratch`` is accessible with read/write permission
       - ``project`` is accessible with **read only** permission. Jobs running on compute nodes of ``workq`` will not be able to write on project directory.
       - ``home`` is not mounted. Instead, the ``$HOME`` variable points to ``/scratch/$USER`` directory    
       - No internet access is available on these compute nodes
  
     * On compute nodes in ``ppn`` partition
  
       -  Both ``scratch`` and ``project`` are accessible with read/write permission
       -  ``home`` is not mounted. Instead, the ``$HOME`` variable points to ``/scratch/$USER`` directory
       -  Compute nodes can access internet
  
     * On compute nodes in ``dtn`` partition 
    
       - ``scratch``, ``project`` and ``home`` are all accessible with read/write permission
       - Compute nodes can access internet

.. note::
    Because compute nodes in ``workq`` partition don't have write permission on project directory and don't mount the home directory, the **users must submit their jobs from their scratch directory**.
Serial jobs
============
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
============================

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
==========

Compute nodes on Shaheen III have a substaintial number of cores. One of the many ways to use them is for MPI jobs. 
Message Passing Interface (MPI) is a library for exhibiting distributed memory parallelism in applications. 
MPI processes can communicate with eachother and enable moving data between processes by sending and receving in various patterns. 

Below are some example jobscripts demonstrating how can compute nodes of Shaheen III be used to run MPI jobs on single and multiple nodes.

Single node jobs
------------------

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


To have more fine grained control over the placement of processes to best match the memory access pattern of the application, the example jobscript below can be used as a template.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=8
    #SBATCH --cpus-per-task=24
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    export OMP_NUM_THREADS=1
    srun --hint=nomultithread -n ${SLURM_NTASKS} -c ${SLURM_CPUS_PER_TASK} \
        --cpu-bind=map_cpu:0,24,48,72,96,120,144,168 \
        ./a.out

.. note::
    Having less number of MPI processes on a node allows the more memory per MPI process and increases the chances for each process to get more memory bandwidth.


Multiple node jobs
---------------------
When the application is capable of scaling out on more MPI processes than on a single node, the following jobscript can be used as an example to run a multinode MPI job.
In the jobscript below, a total of 768 MPI processes are launched on 4 compute nodes. 

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=768
    #SBATCH --ntasks-per-node=192
    #SBATCH --cpus-per-task=1
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    export OMP_NUM_THREADS=1
    srun --hint=nomultithread -n ${SLURM_NTASKS} ./a.out


Hybrid jobs with MPI and OpenMP
================================
Jobs that exhibit both shared memory and distributed memory parallelism are characterized as hyprid jobs. 
Below is an example of how an MPI+OpenMP application could be launched on a compute nodes on Shaheen III.

Single node jobs
-----------------
The example jobscript below launches 8 MPI processes with 24 OpenMP threads on a single compute node of Shaheen III.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=8
    #SBATCH --cpus-per-task=24
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
    srun --hint=nomultithread -n ${SLURM_NTASKS} -c ${OMP_NUM_THREADS} --cpu-bind=cores ./a.out


Multinode jobs
---------------
The example jobscript below demonstrates launching 32 MPI process such that 8 processes are launched on one compute node (i.e. 4 nodes needed).
Each MPI process spawns 24 OpenMP threads. 

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=32
    #SBATCH --ntasks-per-node=8
    #SBATCH --cpus-per-task=24
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job ${SLURM_JOBID}

    # load your software environment here:

    export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
    srun --hint=nomultithread -n ${SLURM_NTASKS} -c ${OMP_NUM_THREADS} --cpu-bind=cores ./a.out

Depending on the domain decomposition characteristics of your application, you may want to experiment with the distribution and try to place MPI processes linearly instead of the round-robin which is default.

Jobs on shared nodes
=====================
Shaheen III has added a new SLURM partition called ``shared``. Multiple jobs from one or more users can run on the same compute node which maximizes the utilization of node. The billing of such job is based on the requested cores instead of the full node, as in ``workq``. By default, 2 cpus and 1GB memory is allocated for a job.

The main motivation of choosing to run a job in ``shared`` partition is if:
* a job requires single core/thread jobs with minimal memory requirement
* a jobarray is planned to run multiple thin components requiring few resources
* prototyping a python workflow in a Jupyter Lab session
* running distributed system with a server and multiple clients(workers), where workers are main workhorse. The server can be launched on ``shared`` partition and workers on ``workq`` partition

Single node jobs
-----------------
.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=shared
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job $SLURM_JOBID
    srun ./a.out

A maximum of 4 cpus and full node memory on a node can requested. Below the job requests approximately half of a nodes memory:

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=shared
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    #SBATCH –c 4
    #SBATCH --mem=150G
    scontrol show job $SLURM_JOBID
    srun ./a.out

Mulitnode jobs
-----------------
The example jobscript below requests two jobs with 4 processes on on two nodes.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=shared
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    #SBATCH --ntasks=4
    #SBATCH --ntasks-per-node=2
    
    scontrol show job $SLURM_JOBID
    srun ./a.out

72 hours Jobs
==============
At times, 24 hours are not enough for a job to finish and there is no reasonable way to circumvent this limitation. In such cases, a subset of ``workq`` nodes overlap with a partition called ``72hours``. This partition allows a job to request wall time of upto 3 days or 72 hours or (``72:00:00``). Access to this SLURM partition is privileged and users must send an :email:`<help@hpc.kaust.edu.sa>`with a compelling justification which will be technically reviewed by one of KSL's computational scientists.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --partition=72hours
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=192
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job $SLURM_JOBID
    srun ./a.out