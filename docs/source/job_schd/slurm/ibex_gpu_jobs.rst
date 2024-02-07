.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Ibex GPU jobs examples
    :keywords: Ibex, grace, hopper, gpus, arm

.. _ibex_gpu_jobs:


=========
GPU jobs
=========

Single GPU job
---------------

A Simple jobscript running a CUDA code on a single GPU on IBEX cluster

.. code-block:: bash
    
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --gpus=1
    module load cuda/11.2.2
    ./my_cuda_app

It is important to note that there is no requriement of a specific type of GPU requested. In such case, SLURM will default to oldest available GPU to this job. 

In case you are aware that your application requires a specific microarchitecture of GPUs, with e.g. large GPU memory, or tensor cores, or transformer engine etc, you must add an additional SLURM directive ``--constraint`` with the respective constrant name. The jobscript may look as follows after this addition:

.. code-block:: bash
    
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --gpus=1
    #SBATCH --constraint=v100
    module load cuda/11.2.2
    ./my_cuda_app


Multiple GPUs on a single node
--------------------------------

A Simple jobscript running a CUDA code on 4 GPUs on single node on IBEX cluster

.. code-block:: bash
    
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --cpus-per-task=4
    #SBATCH --mem=64G
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=4
    #SBATCH --constraint=v100&gpu_ai
    source /ibex/user/$USER/miniconda3/bin/activate my_cuda_env
    srun –c 4 python train.py


Multiple GPUs on Multiple nodes
--------------------------------

A Simple jobscript running a CUDA code on 2 nodes, with 4 V100 GPUs on each node and 8 cpus per gpus dedicated to feed data to each GPU. Note that the jobscript requests resources namely  ``ntasks`` and ``ntasks-per-node`` which refer to the number of processes required on each node. ``cpus-per-node`` are the CPU cores requested to launch multiple threads on each node.


.. code-block:: bash
    
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --ntasks=2
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=32
    #SBATCH --mem=64G
    #SBATCH --gpus=8
    #SBATCH --gpus-per-node=4
    #SBATCH --constraint=v100
    source /ibex/user/$USER/miniconda3/bin/activate my_cuda_env
    srun -n 2 -N 2 -c 32 python train.py