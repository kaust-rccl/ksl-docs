.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Shaheen III  jobs examples
    :keywords: Shaheen III, grace, hopper, arm
.. _shaheen3_examples:


=========================
Pre/Post processing jobs
=========================

.. note::

    Temporary page

Example jobscripts
-------------------

.. code-block:: bash


    #!/bin/bash

    #SBATCH --account=k01
    #SBATCH --job-name=myfirstjob
    #SBATCH --time=01:00:00
    #SBATCH --partition=workq
    #SBATCH --ntasks=192
    #SBATCH --hint=nomultithread

    module load my-package

    srun --hint=nomultithread –n ${SLURM_NTASKS} myapp

.. code-block:: bash


    #!/bin/bash
    #SBATCH --account=k##
    #SBATCH --time=01:00:00
    #SBATCH --partition=workq
    #SBATCH --ntasks=8
    #SBATCH --cpus-per-task=4
    #SBATCH --hint=nomultithread

    # sequential step
    srun –n 1 ./serial_step
    # parallel step           
    srun –n 8 –c 4 ./parallel_step   

.. code-block:: bash


    #!/bin/bash
    #SBATCH --account=k##
    #SBATCH --time=01:00:00
    #SBATCH --partition=workq
    #SBATCH --ntasks=32
    #SBATCH --cpus-per-task=1
    #SBATCH --hint=nomultithread

    for (( i=0; i< ${SLURM_NTASKS}; i++))
    do 
    srun –n 1 -c 1 ./a.out task_index &
    done
    wait

Serial jobs
-----------

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

OpenMP jobs
------------

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=48
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
    scontrol show job ${SLURM_JOBID}
    # load your software environment here:
    srun --hint=nomultithread –c ${OMP_NUM_THREADS} \
    --cpu-bind=verbose,cores ./a.out

MPI jobs
---------

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=192
    #SBATCH --ntasks-per-node=192
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    export OMP_NUM_THREADS=1
    scontrol show job ${SLURM_JOBID}
    # load your software environment here:
    srun --hint=nomultithread –n ${SLURM_NTASKS} –N ${SLURM_NNODES} \
    --cpu-bind=verbose,cores ./a.out

MPI and OpenMP jobs
--------------------

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=4
    #SBATCH --ntasks-per-node=4
    #SBATCH --cpus-per-task=48
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
    scontrol show job ${SLURM_JOBID}
    # load your software environment here:
    srun --hint=nomultithread –n ${SLURM_NTASKS} –N ${SLURM_NNODES} \
    -c ${OMP_NUM_THREADS} --cpu-bind=verbose,cores ./a.out


Pre-post processing jobs (large memory node)
---------------------------------------------

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=ppn
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=256
    #SBATCH --mem=2T
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    #SBATCH --nodelist=ppn9
    srun lsmem


Pre-post processing jobs (GPU node)
------------------------------------

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=ppn
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=128
    #SBATCH --gres=gpu:1
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    nvidia-smi


72 hour queue
--------------

User needs to be added to 72 hour QoS before the job can run

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=72hours
    #SBATCH --ntasks=4
    #SBATCH --cpus-per-task=192
    #SBATCH --hint=nomultithread
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    srun ........


Shared queue
-------------

By default, 2 cpus and 1GB mem is allocated

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=shared
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00

    scontrol show job $SLURM_JOBID
    srun ....

A maximum of 4 cpus and full node memory can requested

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=shared
    #SBATCH --account=k#####
    #SBATCH --time=01:00:00
    #SBATCH –c 4
    #SBATCH --mem=370G
    scontrol show job $SLURM_JOBID
    srun ....


Data mover jobs
----------------

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=dtn
    #SBATCH --ntasks=8
    #SBATCH --account=k#####

    module swap PrgEnv-cray PrgEnv-gnu
    module load mpifileutils
    module list
    time -p srun -n ${SLURM_NTASKS} dcp --verbose --progress 60 --preserve <source_dir> <dest_dir>


Job arrays
-----------

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --array=0-10
    #SBATCH --ntasks=4
    #SBATCH --cpus-per-task=48
    #SBATCH --account=k01
    #SBATCH --time=00:10:00

    echo "ARRAY_ID: ${SLURM_ARRAY_JOB_ID}  TASK_ID: ${SLURM_ARRAY_TASK_ID}"
    sleep 20


Job dependencies
-----------------

Job A

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=dtn
    #SBATCH --ntasks=8
    #SBATCH --cpus-per-task=1
    #SBATCH --account=k01
    #SBATCH --time=00:10:00
    echo "Hi, I will move some data from project to scratch"
    sleep 60
    echo "Job A is finished successfully"



Job B

.. code-block:: bash


    #!/bin/bash
    #SBATCH --partition=workq
    #SBATCH --ntasks=4
    #SBATCH --cpus-per-task=48
    #SBATCH --account=k01
    #SBATCH --time=00:10:00
    echo "Hi, I launch a solver that required data from jobA moved in scratch"
    sleep 60
    echo "Job B is finished successfully"






