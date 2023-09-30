.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Ibex GPU jobs examples
    :keywords: Ibex, grace, hopper, gpus, arm
.. _ibex_cpu_jobs:


=========
CPU jobs
=========

Single CPU job
---------------

A Simple jobscript running a compiled application on 1 CPU of Ibex cluster

.. code-block:: bash
    
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=1
    
    module load gcc
    ./a.out

It is important to note that there is no requriement of a specific type of CPU requested. In such case, SLURM will default to any available CPU to this job. By default, a CPU job get 2GB memory per CPU requested. In can you require more, please add ``--mem=##G`` directive with the desired number of Gigabytes necessary to run the target application. 

In case you are aware that your application requires a specific microarchitecture of CPUs, with e.g. vector intrinsics, known performance metrics, larger memory, larger core count per node etc, you must add an additional SLURM directive ``--constraint`` with the respective constrant name. Please refer to section :ref:`ibex_cpu_compute_nodes` for a full list of CPU constraints available on Ibex. The jobscript, after addition of a constraint and memory requirement may look as follows after this addition:

.. code-block:: bash
    
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=1
    #SBATCH --mem=16G
    #SBATCH --constraint=intel 

    module load gcc
    ./a.out

Multithreaded or OpenMP jobs on single node
--------------------------------------------
A jobscript running an OpenMP code on a Ibex with 4 OpenMP threads 

.. code-block:: bash
   
    
    #!/bin/bash
    #SBATCH --time=00:10:00 
    #SBATCH --ntasks=1 
    #SBATCH --cpus-per-task=4

    module load gcc
    
    export OMP_NUM_THREADS=4 
    export OMP_PLACES=cores 
    export OMP_PROC_BIND=close

    srun –c 4 ./my_omp_application


MPI jobs on single node
--------------------------------

A jobscript running MPI code on Ibex with 32 MPI tasks on same node


.. code-block:: bash
   
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --ntasks=32
    #SBATCH --tasks-per-node=32

    module load openmpi
    module load gcc

    srun -n 32 ./my_mpi_application


MPI jobs on multiple nodes
--------------------------------

A jobscript running MPI code on Ibex with 32 MPI tasks on 2 nodes, 16 MPI tasks on each node.


.. code-block:: bash
   
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --ntasks=32
    #SBATCH --ntasks-per-node=16

    module load openmpi
    module load gcc
    srun -n 32 -N 2 ./my_mpi_application


Jobs requesting Large Memory nodes
-------------------------------------

Normal compute nodes have memory up to approximately 360GB per node. Refer to the section :ref:`ibex_largemem_compute_nodes` for a list of relevant constrants.

* large memory job is a label that’s assigned to your job by SLURM if you ask for memory => 370G

* Use ``--mem=####G`` to request nodes with large memory.

* When you don't specify ``--mem``, the default memory allocation will be 2GB