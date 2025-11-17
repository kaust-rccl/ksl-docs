Fine Tuning with Fully-Sharded Data Parallel (FSDP)
===================================================

`FSDP <https://docs.pytorch.org/tutorials/intermediate/FSDP1_tutorial.html>`__
stands for Fully Sharded Data Parallel, a distributed training technique
used in PyTorch to efficiently train large deep learning models that
don’t fit into the memory of a single GPU.

Introduction
------------

Traditional Data Parallel (DP) training duplicates the entire model on
each GPU and synchronizes gradients after each backward pass. But when your model is huge (e.g. billions of parameters), this becomes
impossible; every GPU would need to hold the entire model copy in
memory.

FSDP solves this problem by sharding (splitting) the model’s parameters, gradients, and optimizer states across all GPUs, instead of replicating them.

Objective
------------

In this guide, you will go through a series of experiments designed to
illustrate how FSDP affects memory efficiency and scaling performance:

1. Baseline: Train using Hugging Face’s Trainer on a single GPU without any sharding. 
2. Single-GPU FSDP: Enable full parameter sharding to observe the immediate reduction in GPU memory usage. 
3. Sharding Strategies & Offloading: Compare the FULL_SHARD, SHARD_GRAD_OP, and HYBRID_SHARD modes, with optional CPU offloading, to evaluate different spee:memory trade-offs. 
4. Multi-GPU Scaling: Expand training to two and then eight GPUs on a single node, measuring both throughput and per-GPU memory utilization. 
5. Multi-Node Scaling: Run FSDP across multiple V100 and A100 nodes, beginning with an NCCL bandwidth self-test to confirm interconnect performance.

.. note::
   
   This guide focuses on running the experiments step by step. For
   deeper insights into the scripts, internal configurations, and
   implementation details, please see the accompanying repository
   `Dist-DL-training/FSDP <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp>`__

Initial Setup
-------------

This repository
`Dist-DL-training/FSDP <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp>`__
is organized into modular directories for code, configuration, and experiments.

Starting with cloning the repo:

.. code:: bash

   git clone https://github.com/kaust-rccl/Dist-DL-training.git
   cd Dist-DL-training/fsdp

Environment Setup
-----------------

To run the experiments, you’ll need a properly configured Conda
environment.

1. If you haven’t installed conda yet, please follow `using conda on Ibex
   guide <https://docs.hpc.kaust.edu.sa/soft_env/prog_env/python_package_management/conda/ibex.html#conda-ibex>`__
   to get started.

2. Build the conda environment required using the recommended yml file
   in the project directory, using command:
  
   .. code:: bash

      conda env create -f bloom_env.yml
      conda activate bloom_env

.. tip::

   The Conda environment should be built on an allocated GPU node.
   Please ensure you allocate a GPU node before starting the build.

Baseline: BLOOM Fine-tuning without FSDP
----------------------------------------

This experiment is subject running a baseline single-GPU fine tuning the
BLOOM-560M language model on the SQuAD v1.1 dataset without FSDP
enabled.

The setup contains of two main files: 

1. baseline.py: the training script. 
2. baseline.slurm: the one-GPU job launcher.

.. tip::

   For the full script for the , see the
   `fsdp/bloom/baseline.py <https://github.com/kaust-rccl/Dist-DL-training/blob/master/fsdp/bloom/baseline/baseline.py>`__,
   and
   `fsdp/bloom/baseline.slurm <https://github.com/kaust-rccl/Dist-DL-training/blob/master/fsdp/bloom/baseline/baseline.slurm>`__

   For more details on what happens behind the scenes in this script,
   and the training configuration, see the corresponding script and
   documentation in the `baseline: fine-tuning
   setup <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp#fine-tuning-setup>`__

Running the baseline
~~~~~~~~~~~~~~~~~~~~

Once all components are in place: model loading, dataset preprocessing,
training configuration, and training logic — you can execute the full
fine-tuning workflow with minimal manual steps.

1. Navigate to the baseline experiment directory

   .. code:: bash 
      
      cd bloom/baseline

2. Modify the ``env_vars.sh`` script to ensure the variables are
   correctly set:

   .. code:: bash

      # Conda setup
      export CONDA_ENV="bloom_env"
   
      # Wandb/online‐run settings
      export EXPERIMENT_NAME="BLOOM_Baseline"
      export LOG_DIR="$PWD/logs/"
      export WANDB_API_KEY="your_wandb_api_key"
   
      export MODEL_NAME="bigscience/bloom-560m"
      export OUTPUT_DIR="outputs/${EXPERIMENT_NAME}"
      export MAX_LENGTH=512
      export TRAIN_SIZE=250
      export EVAL_SIZE=100
      export NUM_EPOCHS=5
      export BATCH_SIZE=1
      export LEARNING_RATE=5e-5
      export WEIGHT_DECAY=0.01
      export GRAD_ACC=4
      export FP16=True
      export BF16=False

   - ``WANDB_API_KEY``: Replace with your personal WandB API key.
   - ``EXPERIMENT_NAME``: Set a descriptive name for the experiment.
   - ``LOG_DIR``: Confirm the path exists and is writable.

  
3. Submit the job with: 
   
   .. code:: bash  
   
      sbatch baseline.slurm

4. Monitor the job status: 
   
   .. code:: bash 
      
      squeue --me

Expected Output
~~~~~~~~~~~~~~~

Once the job completes, check the following in the output: 
- Model & Tokenizer: Located in ./bloom-qa-finetuned/. 
- Training Logs: Stored in the logs/ directory, named as \_.out. 
- Evaluation Metrics & Loss Curves: Accessible via WandB (if online mode is enabled) or in the log
files.

.. code:: bash

   cd logs
   cat BLOOM_Baseline_<job_id>.out

It should be similar to the following results:

.. code:: bash

   {'eval_loss': 9.937565803527832, 'eval_runtime': 3.7396, 'eval_samples_per_second': 26.741, 'eval_steps_per_second': 26.741, 'epoch': 1.0}
   {'eval_loss': 8.618648529052734, 'eval_runtime': 3.3804, 'eval_samples_per_second': 29.582, 'eval_steps_per_second': 29.582, 'epoch': 2.0}
   {'eval_loss': 9.792547225952148, 'eval_runtime': 3.3707, 'eval_samples_per_second': 29.668, 'eval_steps_per_second': 29.668, 'epoch': 3.0}
   {'loss': 4.895, 'grad_norm': 81.46920776367188, 'learning_rate': 1.08e-05, 'epoch': 4.0}
   {'eval_loss': 9.732966423034668, 'eval_runtime': 3.0577, 'eval_samples_per_second': 32.705, 'eval_steps_per_second': 32.705, 'epoch': 4.0}
   {'eval_loss': 11.040238380432129, 'eval_runtime': 3.0899, 'eval_samples_per_second': 32.363, 'eval_steps_per_second': 32.363, 'epoch': 5.0}
   {'train_runtime': 332.556, 'train_samples_per_second': 7.518, 'train_steps_per_second': 1.879, 'train_loss': 3.9868627746582033, 'epoch': 5.0}
   Evaluation Metrics: {'exact_match': 0.0, 'f1': 0.0184947800077543}

+-----------------------+------------------------------+-----------------------+
| **Metric**            | **Log Location &             | **Your Value**        |
|                       | Extraction**                 |                       |
+=======================+==============================+=======================+
| Train Loss (Final)    | Last ``train_loss`` in       | 11.0402               |
|                       | ``{'train_loss': ...}``      |                       |
+-----------------------+------------------------------+-----------------------+
| Eval Loss (Epoch 1)   | First ``eval_loss`` where    | 9.9375                |
|                       | ``'epoch': 1.0``             |                       |
+-----------------------+------------------------------+-----------------------+
| Eval Loss (Epoch 2)   | ``eval_loss`` where          | 8.6186                |
|                       | ``'epoch': 2.0``             |                       |
+-----------------------+------------------------------+-----------------------+
| Eval Loss (Epoch 3)   | Final ``eval_loss``          | 9.7925                |
|                       | (e.g. where                  |                       |
|                       | ``'epoch': 3.0``)            |                       |
+-----------------------+------------------------------+-----------------------+
| Training Speed        | ``train_samples_per_second`` | 7.518                 |
| (samples/sec)         | in the final summary         |                       |
+-----------------------+------------------------------+-----------------------+
| Evaluation Speed      | ``eval_samples_per_second``  | 26.741                |
| (samples/sec)         | in any eval line (e.g. epoch |                       |
|                       | 1)                           |                       |
+-----------------------+------------------------------+-----------------------+

.. note::

   This experiment was run on a V100 GPU.

.. tip::

   Access metrics via W&B dashboard by following the `Monitoring
   and Results
   Section <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp#-monitoring-and-results>`__
   to learn more about how.

Multi-GPU Fine-Tuning with FSDP
-------------------------------

This section demonstrates how to scale the fine-tuning of the BLOOM-560M
model on the SQuAD v1.1 dataset using PyTorch’s Fully Sharded Data
Parallel (FSDP) across multiple GPUs on a single node. By leveraging
FSDP, we can efficiently utilize GPU memory and accelerate training.

Directory Structure
~~~~~~~~~~~~~~~~~~~

Following the repo, the `project
directory <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp/bloom/multi_gpu>`__
is organized as follows:

.. code:: bash

   multi_gpu/
   ├── 2_gpus/
   │   ├── env_vars.sh
   │   ├── multi_gpu.py
   │   ├── multi_gpu.slurm
   ├── 4_gpus/
   │   ├── env_vars.sh
   │   ├── multi_gpu.py
   │   ├── multi_gpu.slurm
   ├── 8_gpus/
       ├── env_vars.sh
       ├── multi_gpu.py
       ├── multi_gpu.slurm

FSDP Configuration
~~~~~~~~~~~~~~~~~~

The training script
(`multi_gpu.py <https://github.com/kaust-rccl/Dist-DL-training/blob/master/fsdp/bloom/multi_gpu/2_gpus/multi_gpu.py>`__)
includes a preconfigured FSDP setup that defines how model layers are
wrapped and synchronized during distributed training. These settings
control when parameters are prefetched, synchronized, and sharded to
optimize both memory usage and training efficiency.

.. note::

   For reference: To review or modify the configuration, see the fsdp_cfg dictionary in
   `multi_gpu.py <https://github.com/kaust-rccl/Dist-DL-training/blob/master/fsdp/bloom/multi_gpu/2_gpus/multi_gpu.py>`__.
   The script also explains how each option (e.g.,
   transformer_layer_cls_to_wrap, backward_prefetch, forward_prefetch,
   sync_module_states) affects performance.

   For more details about explanation of parameters, refer to `FSDP
   configuration
   parameters <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp#%EF%B8%8F-fsdp-configuration-parameters>`__
   in the repo.

Distributed Training Environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The distributed training environment is initialized using PyTorch’s torch.distributed.launch utility.

This setup defines the **master node address**, **communication port**, and **total number of processes** required for multi-GPU execution.

In this guide, these environment variables are automatically set by the Slurm script.

If you’re running manually or adapting the job, ensure that: 

- ``MASTER_ADDR`` points to the hostname of the primary node,
- ``MASTER_PORT`` is an available communication port (e.g., 29500),
- ``WORLD_SIZE`` matches the total number of GPUs used in the run.

.. note:: 

   For more details about the distributed training
   environment configuration, refer to `Distributed Training
   Setup <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp#-distributed-training-setup-with-torchdistributedlaunch>`__
   in the repo.

Running 2 GPUs Experiment
~~~~~~~~~~~~~~~~~~~~~~~~~

In this experiment, the job will allocate 2 GPUs on a single node, set
up the necessary environment variables, and launch the training script
using ``torchrun`` for distributed training with FSDP.

1. Navigate to 2 GPU experiment directory:
   
   .. code:: bash  
      
      cd blomm/multi_gpu/2_gpus

2. Configure the environment variables by editing the ``env_vars.sh``
   files to set up the environment: 
   
   .. code:: bash 
      
      # Conda setup export
      CONDA_ENV=“bloom_env”

      # Wandb/online‐run settings export
      EXPERIMENT_NAME=“BLOOM_Multi_GPUS_2_GPUs” export LOG_DIR=“$PWD/logs”
      export WANDB_API_KEY=“your_wandb_api_key”

      export MODEL_NAME=“bigscience/bloom-560m” export
      OUTPUT_DIR=“outputs/${EXPERIMENT_NAME}” export MAX_LENGTH=512 export
      TRAIN_SIZE=250 export EVAL_SIZE=100 export NUM_EPOCHS=5 export
      BATCH_SIZE=1 export LEARNING_RATE=5e-5 export WEIGHT_DECAY=0.01
      export GRAD_ACC=4 export FP16=True export BF16=False \``\`

3. Submit the Slurm job: 
   
   .. code:: bash
      
      sbatch multi_gpu.slurm

Output
~~~~~~

Once the job completes, check the following in the output: - Model &
Tokenizer: Located in ./bloom-qa-finetuned/. - Training Logs: Stored in
the logs/ directory, named as \_.out. - Evaluation Metrics & Loss
Curves: Accessible via WandB (if online mode is enabled) or in the log
files.

.. code:: bash

   cd logs
   cat multi_gpu_2_<job_id>.out

Multi-Node Fine Tuning with FSDP
--------------------------------

This section demonstrates how to scale the fine-tuning of the BLOOM-560M
model on the SQuAD v1.1 dataset using PyTorch’s Fully Sharded Data
Parallel (FSDP) across multiple nodes. By leveraging FSDP, we can
efficiently utilize GPU memory and accelerate training across
distributed systems.

.. _directory-structure-1:

Directory Structure
~~~~~~~~~~~~~~~~~~~

Following the repo, the `project
directory <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp/bloom/multi_node>`__
is organized as follows:

.. code:: bash

   multi_node/
   ├── 2_nodes/
   │   ├── env_vars.sh
   │   ├── multi_node.py
   │   ├── multi_node.slurm
   ├── 4_nodes/
   │   ├── env_vars.sh
   │   ├── multi_node.py
   │   ├── multi_node.slurm
   ├── 8_nodes/
   │   ├── env_vars.sh
   │   ├── multi_node.py
   │   ├── multi_node.slurm

.. _fsdp-configuration-1:

FSDP Configuration
~~~~~~~~~~~~~~~~~~

The multi-node training script (multi_node.py) includes a predefined
FSDP configuration to control how model layers are wrapped, prefetched,
and synchronized during distributed training. These settings optimize
memory efficiency and communication overhead when scaling across
multiple nodes.

.. note::

   For the full configuration and in-code explanations, see the fsdp_cfg
   dictionary in
   `multi_node.py <https://github.com/kaust-rccl/Dist-DL-training/blob/master/fsdp/bloom/multi_node/2_nodes/multi_node.py>`__.

   For more details about explanation of parameters, refer to `FSDP
   configuration
   parameters <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp#%EF%B8%8F-fsdp-configuration-parameters-1>`__
   in the repo.

The key parameters are:

- ``transformer_layer_cls_to_wrap``: Identifies the model layers to wrap with FSDP. In this case, BloomBlock layers, which contain most of the model’s parameters. 
- ``backward_prefetch``: Controls when to load the next layer’s parameters during backpropagation; “backward_post” improves overlap between computation and communication. 
- ``forward_prefetch``: If enabled, preloads the next layer’s parameters during the forward pass for better throughput. 
- ``sync_module_states``: Ensures model parameters are synchronized across all ranks at startup.

Together, these configurations improve memory utilization and training
throughput across multiple nodes.

Distributed Environment Setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Before launching multi-node training, environment variables must be
defined to coordinate communication between nodes. The provided Slurm
script automates this setup by assigning the first node as the master
and dynamically selecting an available port.

.. tip:: 

   For more Details, Review the environment setup logic in
   `multi_node.slurm <https://github.com/kaust-rccl/Dist-DL-training/blob/master/fsdp/bloom/multi_node/2_nodes/multi_node.slurm>`__
   for details on how variables are exported and initialized.

   For more details about the distributed training environment
   configuration, refer to `Distributed Training
   Setup <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp#-distributed-training-launch>`__
   in the repo.

Key variables used: 

- ``MASTER_ADDR``: Hostname or IP of the master node coordinating all workers. 
- ``MASTER_PORT``: Communication port for process rendezvous, chosen dynamically to avoid conflicts. 
- ``WORLD_SIZE``: Total number of processes (number of nodes × processes per node). 
- ``OMP_NUM_THREADS``: Restricts CPU threads per process to prevent oversubscription.

These variables ensure consistent and stable initialization for
distributed training across all participating nodes.

Running the 2 Nodes Experiment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Navigate the desired node configuration directory:
  
   .. code:: bash
      
      cd bloom/multi_node/2_nodes

2. Configure the environment variables, by modifying the env_vars.sh file:
  
   .. code:: bash
      
      # Conda setup
      export CONDA_ENV="bloom_env"

      # Wandb/online‐run settings
      export EXPERIMENT_NAME="BLOOM_Multi_Nodes_2_NODES"
      export LOG_DIR="$PWD/logs"
      export WANDB_API_KEY="your_wandb_api_key"


      export MODEL_NAME="bigscience/bloom-560m"
      export OUTPUT_DIR="outputs/${EXPERIMENT_NAME}"
      export MAX_LENGTH=512
      export TRAIN_SIZE=250
      export EVAL_SIZE=100
      export NUM_EPOCHS=5
      export BATCH_SIZE=1
      export LEARNING_RATE=5e-5
      export WEIGHT_DECAY=0.01
      export GRAD_ACC=4
      export FP16=True
      export BF16=False

3. Submit the Slurm job:

   .. code:: bash

      sbatch multi_node.slurm


.. _output-1:

Output
~~~~~~

Once the job completes, check the following in the output: 
- Model & Tokenizer: Located in ./bloom-qa-finetuned/. 
- Training Logs: Stored in the logs/ directory, named as \_.out. 
- Evaluation Metrics & Loss Curves: Accessible via WandB (if online mode is enabled) or in the log
files.

.. code:: bash

   cd logs
   cat multi_gpu_2_<job_id>.out

Workshop Reference and Next Steps
---------------------------------

Please follow the workshop
`Dist-DL-Training/FSDP <https://github.com/kaust-rccl/Dist-DL-training/tree/master/fsdp>`__
GitHub repo.

You will fine-tune the BLOOM-560 M language model on a subset of SQuAD
v1.1 while gradually introducing Fully-Sharded Data Parallel (FSDP),
PyTorch’s native memory-saving and scaling engine.
