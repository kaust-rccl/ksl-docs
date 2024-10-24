.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: MS DeepSpeed
    :keywords: deepspeed

.. _deepspeed:

================================================
Microsoft DeepSpeed
================================================

Microsoft DeepSpeed is a library to enable efficient distributed training, fine-tuning and inference on CPUs and GPUs in a high configurable manner. The library is enabled on KSL systems as a module or can be installed in a personal ```conda``` environment. This documentation shows how to install DeepSpeed and launch mutliGPU/multicore jobs on KSL systems. 

DeepSpeed on Shaheen III
==========================

.. note::
    section under construction

DeepSpeed on Ibex
==================
DeepSpeed integrates well with SLURM on Ibex. It can either be used by loading the managed software modules or in a ``conda`` environment managed by the users in their own directories. 

For a ``conda`` environment, you can activate one with Python, Pytorch with CUDA and MPI library installed, and then install DeepSpeed using ``pip`` package manager.

.. code-block:: bash
    
    pip install deepspeed

In case you don't have a ``conda`` package manager, please refer to :ref:`conda_ibex_`.

.. important:: 
    It is important to make a change in the installed deepspeed package when the mulitnode jobs are intended to be run. It is specially important when requesting GPUs on shared Ibex nodes.

    In your shell, run the following to get the path to DeepSpeed installation:
    
    .. code-block:: bash

        python
        Python 3.12.3 | packaged by conda-forge | (main, Apr 15 2024, 18:38:13) [GCC 12.3.0] on linux
        Type "help", "copyright", "credits" or "license" for more information.
        >>> import deepspeed as ds
        [2024-05-14 11:54:06,648] [WARNING] [real_accelerator.py:162:get_accelerator] Setting accelerator to CPU. If you have GPU or other accelerator, we were unable to detect it.
        [2024-05-14 11:54:06,651] [INFO] [real_accelerator.py:203:get_accelerator] Setting ds_accelerator to cpu (auto detect)
        >>> ds.__file__
        '/ibex/user/$USER/conda-environments/cifar/lib/python3.12/site-packages/deepspeed/__init__.py'
        >>> exit()

    Change directory to ```/ibex/user/$USER/conda-environments/cifar/lib/python3.12/site-packages/deepspeed``` and edit the file ```constants.py``` to make necessary changes to port selection:

    .. code-block:: bash
        
        # Copyright (c) Microsoft Corporation.
        # SPDX-License-Identifier: Apache-2.0

        # DeepSpeed Team

        import os
        from datetime import timedelta

        #############################################
        # Torch distributed constants
        #############################################
        import socket
        s=socket.socket()
        s.bind(("", 0))
        port = s.getsockname()[1]
        s.close()
        TORCH_DISTRIBUTED_DEFAULT_PORT = port

        # Default process group wide timeout, if applicable.
        # This only applies to the gloo and nccl backends
        # (only if NCCL_BLOCKING_WAIT or NCCL_ASYNC_ERROR_HANDLING is set to 1).
        # To make an attempt at backwards compatibility with THD, we use an
        # extraordinarily high default timeout, given that THD did not have timeouts.
        default_pg_timeout = timedelta(minutes=int(os.getenv("DEEPSPEED_TIMEOUT", default=30)))
        INFERENCE_GENERIC_MODE = 'generic'
        INFERENCE_SPECIALIZED_MODE = 'specialized'



Running DeepSpeed on single node with multiGPUs
-------------------------------------------------
Below is an example of a DeepSpeed job using 4 GPUs on a single node. The type of requested GPUs is ```v100``` with 32GB of GPU memory. 

The example python script ``cifar10_deepspeed.py`` can be cloned from the `GitHub repository <https://github.com/microsoft/DeepSpeedExamples.git>


.. code-block:: bash
    
    #!/bin/bash 
    #SBATCH --job-name=CIFAR_DS
    #SBATCH --time=00:01:00
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=4
    #SBATCH --constraint=v100
    #SBATCH --ntasks=4
    #SBATCH --ntasks-per-node=4
    #SBATCH --cpus-per-task=8
    #SBATCH --mem=100G

    # Using pre-installed modules on Ibex
    module load dl 
    module load pytorch
    module load deepspeed
    
    # Can use a conda environment by sourcing it as below. In this case, please comment the "module load" commands above. 
    #source /ibex/user/$USER/mambaforge/bin/activate ds_env
 

    echo "Hostnames: $SLURM_NODELIST"
    scontrol show job $SLURM_JOBID
    
    
    export RUNDIR=${PWD}/result_${SLURM_JOB_NAME}
    mkdir -p $RUNDIR
    export OUTPUT=${SLURM_JOBID}
    # Getting the node names
    nodes=$(scontrol show hostnames "$SLURM_JOB_NODELIST")
    nodes_array=($nodes)
    echo "Node IDs of participating nodes ${nodes_array[*]}"


    # Get the IP address and set port for MASTER node
    head_node="${nodes_array[0]}"
    echo "Getting the IP address of the head node ${head_node}"
    master_ip=$(srun -n 1 -N 1 --gpus=1 -w ${head_node} /bin/hostname -I | cut -d " " -f 2)
    master_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    echo "head node is ${master_ip}:${master_port}"

    workers=${SLURM_CPUS_PER_TASK}

    echo "Hostname: $(/bin/hostname)"
    echo "CPU workers: $workers"

    for (( i=0; i< ${SLURM_NNODES}; i++ ))
    do
        srun --cpu-bind=cores -n 1 -N 1 -c ${SLURM_CPUS_PER_TASK} -w ${nodes_array[i]} --gpus=${SLURM_GPUS_PER_NODE}  \
        python -m torch.distributed.launch --use_env --nproc_per_node=${SLURM_GPUS_PER_NODE} --nnodes=${SLURM_NNODES} --node_rank=${i} \ 
        --master_addr=${master_ip} --master_port=${master_port}  cifar10_deepspeed.py --deepspeed $@ &> $RUNDIR/$SLURM_JOBID.txt
    done
    wait

Running DeepSpeed on multiple node with multiGPUs
-------------------------------------------------
Below is an example of a DeepSpeed job using 4 GPUs on 2 nodes with 2 GPUs on each. The type of requested GPUs again ``v100`` with 32GB. The node also has GPUDirect RDMA connectivity enabled which moves data from GPU memory to the another GPU's memory on a remote node, bypassing the CPUs. This is a very important feature to keep up the ``allreduce`` communication throughput in the distributed training process. 

.. code-block:: bash
    
    #!/bin/bash 
    #SBATCH --job-name=CIFAR_DS
    #SBATCH --time=00:01:00
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=2
    #SBATCH --constraint=v100,gpu_ai
    #SBATCH --ntasks=4
    #SBATCH --ntasks-per-node=2
    #SBATCH --cpus-per-task=8
    #SBATCH --mem=100G

    # Using pre-installed modules on Ibex
    module load dl 
    module load pytorch
    module load deepspeed
    
    # Can use a conda environment by sourcing it as below. In this case, please comment the "module load" commands above. 
    #source /ibex/user/$USER/mambaforge/bin/activate ds_env
 

    echo "Hostnames: $SLURM_NODELIST"
    scontrol show job $SLURM_JOBID
    
    
    export RUNDIR=${PWD}/result_${SLURM_JOB_NAME}
    mkdir -p $RUNDIR
    export OUTPUT=${SLURM_JOBID}
    # Getting the node names
    nodes=$(scontrol show hostnames "$SLURM_JOB_NODELIST")
    nodes_array=($nodes)
    echo "Node IDs of participating nodes ${nodes_array[*]}"


    # Get the IP address and set port for MASTER node
    head_node="${nodes_array[0]}"
    echo "Getting the IP address of the head node ${head_node}"
    master_ip=$(srun -n 1 -N 1 --gpus=1 -w ${head_node} /bin/hostname -I | cut -d " " -f 2)
    master_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    echo "head node is ${master_ip}:${master_port}"

    workers=${SLURM_CPUS_PER_TASK}

    echo "Hostname: $(/bin/hostname)"
    echo "CPU workers: $workers"

    for (( i=0; i< ${SLURM_NNODES}; i++ ))
    do
        srun --cpu-bind=cores -n 1 -N 1 -c ${SLURM_CPUS_PER_TASK} -w ${nodes_array[i]} --gpus=${SLURM_GPUS_PER_NODE}  \
        python -m torch.distributed.launch --use_env --nproc_per_node=${SLURM_GPUS_PER_NODE} --nnodes=${SLURM_NNODES} --node_rank=${i} \ 
        --master_addr=${master_ip} --master_port=${master_port}  cifar10_deepspeed.py --deepspeed $@ &> $RUNDIR/$SLURM_JOBID.txt
    done
    wait


