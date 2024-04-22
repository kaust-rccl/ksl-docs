.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Horovod
    :keywords: Horovod

.. _horovod:

================================================
Horovod for Distributed Data Parallel training
================================================

Horovod is a framework for distributed parallel training of deep learning models written in Python, Tensorflow, Keras and MxNet. 
It supports model training on both CPUs and GPUs. 

On KSL systems, Horovod is installed as managed modules with integration of PyTorch and/or Tensorflow's specific versions. 
In this documentation, distributed data parallel training is demonstrated for a compute vision task. 
The scope of this documentation is to demonstrate how to setup and run Horovod jobs on KSL systems with SLURM and scale from 1 to N CPUs and GPUs.

Running Horovod on Shaheen III
===============================

An example jobscript to run Horovod job on a single node of Shaheen III CPU partition. `train_resnet50.py <https://raw.githubusercontent.com/kaust-rccl/Dist-DL-training/master/horovod/shaheen3/train_resnet50.py>`_ trains a ResNet50 model on Tiny ImageNet dataset.

.. code-block:: bash

    #!/bin/bash 
    #SBATCH --job-name=single_node
    #SBATCH --time=05:00:00
    #SBATCH --ntasks=4
    #SBATCH --cpus-per-task=48
    #SBATCH --hint=nomultithread

    module swap PrgEnv-cray PrgEnv-gnu
    module load pytorch/2.2.1
    module load horovod/0.28.1-torch221
    module list

    echo "Hostnames: $SLURM_NODELIST"

    export DATA_DIR="/scratch/reference/ai/CV/tiny_imagenet"

    batch_size=256
    epochs=5
    workers=${SLURM_CPUS_PER_TASK}

    echo "Hostname: $(/bin/hostname)"
    echo "Data source: $DATA_DIR"
    echo "Using Batch size : $batch_size"
    echo "Epochs : $epochs"
    echo "CPU workers: $workers"

    main_exe="train_resnet50.py"
    cmd=""
    echo "time -p srun -u -n ${SLURM_NTASKS}  -c ${SLURM_CPUS_PER_TASK} ${cmd} --log-dir=log.${SLURM_JOBID} --warmup-epochs=0.0 --no-cuda"
    time -p srun -u -n ${SLURM_NTASKS} -N ${SLURM_NNODES} \
        -c ${SLURM_CPUS_PER_TASK} \
        --cpu-bind=verbose,cores \
        python3 train_resnet50.py --epochs ${epochs} \
         --batch-size ${batch_size} \
         --num_workers=$workers \
         --train-dir ${DATA_DIR}/train \
         --val-dir ${DATA_DIR}/val \
         --warmup-epochs=0.0 --no-cuda


Below is an example jobscript to scale the data parallel training on multiple compute nodes of Shaheen III. In this case, 4 nodes with 16 MPI processes in total and 48 OpenMP threads per MPI process are launched to train the model.

.. code-block:: bash

    #!/bin/bash 
    #SBATCH --job-name=single_node
    #SBATCH --time=05:00:00
    #SBATCH --ntasks=16
    #SBATCH --ntasks-per-node=4
    #SBATCH --cpus-per-task=48
    #SBATCH --hint=nomultithread

    module swap PrgEnv-cray PrgEnv-gnu
    module load pytorch/2.2.1
    module load horovod/0.28.1-torch221
    module list

    echo "Hostnames: $SLURM_NODELIST"

    export DATA_DIR="/scratch/reference/ai/CV/tiny_imagenet"

    batch_size=256
    epochs=5
    workers=${SLURM_CPUS_PER_TASK}

    echo "Hostname: $(/bin/hostname)"
    echo "Data source: $DATA_DIR"
    echo "Using Batch size : $batch_size"
    echo "Epochs : $epochs"
    echo "CPU workers: $workers"

    main_exe="train_resnet50.py"
    cmd=""
    echo "time -p srun -u -n ${SLURM_NTASKS}  -c ${SLURM_CPUS_PER_TASK} ${cmd} --log-dir=log.${SLURM_JOBID} --warmup-epochs=0.0 --no-cuda"
    time -p srun -u -n ${SLURM_NTASKS} -N ${SLURM_NNODES} \
        -c ${SLURM_CPUS_PER_TASK} \
        --cpu-bind=verbose,cores \
        python3 train_resnet50.py --epochs ${epochs} \
         --batch-size ${batch_size} \
         --num_workers=$workers \
         --train-dir ${DATA_DIR}/train \
         --val-dir ${DATA_DIR}/val \
         --warmup-epochs=0.0 --no-cuda


Running Horovod on Ibex
========================

An example jobscript to run Horovod job on a single node of Ibex GPUs. 

Below is an example jobscript demonstrating how to run Horovod model training on Ibex GPU nodes. `train_resnet50.py <https://raw.githubusercontent.com/kaust-rccl/Dist-DL-training/master/horovod/ibex/train_resnet50.py>`_ trains a ResNet50 model on Tiny ImageNet dataset.

.. code-block:: bash

    #!/bin/bash 
    #SBATCH --job-name=tinyImageNet
    #SBATCH --ntasks=4
    #SBATCH --cpus-per-task=5
    #SBATCH --output=rfm_job.out
    #SBATCH --error=rfm_job.err
    #SBATCH --time=3:0:0
    #SBATCH --partition=batch
    #SBATCH --constraint=a100,4gpus
    #SBATCH --mem=400G
    #SBATCH --gres=gpu:4


    module load dl
    module load  horovod/0.28.0

    export OMPI_MCA_btl_openib_warn_no_device_params_found=0
    export UCX_MEMTYPE_CACHE=n
    export UCX_TLS=tcp

    export DATA_DIR="/ibex/ai/reference/CV/ILSVR/classification-localization/data/jpeg/"

    
    batch_size=256
    epochs=5
    
    time -p srun -u -n ${SLURM_NTASKS} -N ${SLURM_NNODES} -c ${SLURM_CPUS_PER_TASK} \
        python3 train_resnet50.py --epochs ${epochs} \
        --batch-size ${batch_size} --num_workers=${SLURM_CPUS_PER_TASK} \
        --train-dir ${DATA_DIR}/train --val-dir ${DATA_DIR}/val
