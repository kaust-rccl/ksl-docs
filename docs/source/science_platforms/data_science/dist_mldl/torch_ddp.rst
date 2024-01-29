.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: PyTorch distributed
    :keywords: pytorch

=====================================================
PyTorch Distributed Data Parallel (DDP)
=====================================================

Launching a distributed PyTorch training in a slurm jobscript require a few additional steps than using vanilla ``torchrun`` command line.

..
    PyTorch DDP on Shaheen 3 CPUs and GPUs
    =======================================



PyTorch DDP on Ibex GPUs
==========================

 The following jobscripts launch model training on multiple GPU on a single and multiple nodes of Ibex.  



The DDP training script used as an example here is an Image classifier training on TinyImagenet  dataset. You may access the training script here.

Single-Node Multi-GPU training job
-----------------------------------

In the jobscript below, we launch the training on 2 GPUs of type V100 all on the same node. We request 16 cpus in total on the CPU host to be used as Dataloader’s by PyTorch. 

.. code-block::

    #!/bin/bash

    #SBATCH --gpus=2
    #SBATCH --gpus-per-node=2
    #SBATCH --constraint=v100
    #SBATCH --ntasks=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=16
    #SBATCH --time=00:10:00

    scontrol show job $SLURM_JOBID 

    # Add path to your conda environment or load the modules from Ibex
    source /ibex/user/$USER/miniconda3/bin/activate dist-pytorch
    export NCCL_DEBUG=INFO
    export PYTHONFAULTHANDLER=1

    export DATA_DIR=/ibex/ai/reference/CV/tinyimagenet

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

    #if NVDASHBAORD is installed, uncomment the lines below:
    #nv_board=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    #nvdashboard ${nv_board} &
    #sleep 5
    #echo -e " 
    #To connect to the NVIDIA Dashboard and monitor your GPU utilzation do the following:
    #Copy the following command and paste in new terminal:
    #ssh -L localhost:${nv_board}:${HOSTNAME}.ibex.kaust.edu.sa:${nv_board} ${USER}@glogin.ibex.kaust.edu.sa 
    #"

    export OMP_NUM_THREADS=1
    for (( i=0; i< ${SLURM_NNODES}; i++ ))
    do
        srun -n 1 -N 1 -c ${SLURM_CPUS_PER_TASK} -w ${nodes_array[i]} --gpus=${SLURM_GPUS_PER_NODE}  \
        python -m torch.distributed.launch --use_env \
        --nproc_per_node=${SLURM_GPUS_PER_NODE} --nnodes=${SLURM_NNODES} --node_rank=${i} \
        --master_addr=${master_ip} --master_port=${master_port} \
        ddp.py --epochs=10 --lr=0.001 --num-workers=${SLURM_CPUS_PER_TASK} --batch-size=64 &
    done
    wait


Multi-Node Multi-GPU training job
-----------------------------------

As for single node, the jobscript pretty much remains identical except for the resource allocation section. In this job, we scale our problem  4 GPUs with 2 on each node. Each node has 16 CPUs to work as dataloaders. 

.. code-block::

    #!/bin/bash

    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=2
    #SBATCH --constraint=v100
    #SBATCH --ntasks=2
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=16
    #SBATCH --time=00:10:00

    scontrol show job $SLURM_JOBID 

    # Add path to your conda environment or load the modules from Ibex
    source /ibex/user/$USER/miniconda3/bin/activate dist-pytorch
    export NCCL_DEBUG=INFO
    export PYTHONFAULTHANDLER=1

    export DATA_DIR=/ibex/ai/reference/CV/tinyimagenet

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

    #if NVDASHBAORD is installed, uncomment the lines below:
    #nv_board=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    #nvdashboard ${nv_board} &
    #sleep 5
    #echo -e " 
    #To connect to the NVIDIA Dashboard and monitor your GPU utilzation do the following:
    #Copy the following command and paste in new terminal:
    #ssh -L localhost:${nv_board}:${HOSTNAME}.ibex.kaust.edu.sa:${nv_board} ${USER}@glogin.ibex.kaust.edu.sa 
    #"

    export OMP_NUM_THREADS=1
    for (( i=0; i< ${SLURM_NNODES}; i++ ))
    do
        srun -n 1 -N 1 -c ${SLURM_CPUS_PER_TASK} -w ${nodes_array[i]} --gpus=${SLURM_GPUS_PER_NODE}  \
        python -m torch.distributed.launch --use_env \
        --nproc_per_node=${SLURM_GPUS_PER_NODE} --nnodes=${SLURM_NNODES} --node_rank=${i} \
        --master_addr=${master_ip} --master_port=${master_port} \
        ddp.py --epochs=10 --lr=0.001 --num-workers=${SLURM_CPUS_PER_TASK} --batch-size=64 &
    done
    wait

``nvdashboard`` is a useful tool to understand the utilization pattern of your training jobs. It is important that your GPUs are very well utilized. Adding more GPUs when their utilization is low is going to adversely effect the training times.