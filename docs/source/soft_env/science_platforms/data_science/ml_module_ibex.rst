.. sectionauthor:: Didier Barradas Bautista <didier.barradasbautista@kaust.edu.sa>
.. meta::
    :description: Machine Learning module
    :keywords: pytorch, lightning, machine learning, deep learning, dask, rapids

.. _ibex_ml_module:

=================================
Machine Learning module on Ibex
=================================

Overview
---------
This module provides a comprehensive environment for machine learning tasks on the Ibex HPC cluster. It includes a collection of popular libraries and frameworks. This module is intended to be the entry point to prototype your data science code. It contains several that make this module as robust as possible. 

Popular libraries included:

- **RAPIDS**     : GPU-accelerated data science and machine learning libraries for Python
- **WandB**      : Tool for tracking and visualizing machine learning experiments
- **TensorFlow** : Open-source machine learning framework for various tasks
- **PyTorch**    : Another open-source machine learning framework known for flexibility and ease of use

Loading the Module
------------------
To access the included libraries and tools, load the module using the following command:


.. code-block::
    
    module load machine_learning

We try to update the module every six months 

Running Code-Server
-------------------
The module supports running code-server, a web-based IDE, on the HPC cluster. This allows you to develop and execute code in a browser-based environment. Here's an example SLURM script for launching code-server:

.. code-block::

    #!/bin/bash --login
    #SBATCH ... (SLURM job parameters)

    # Setup environment
    export CODE_SERVER_CONFIG=~/.config/code-server/config.yaml
    export XDG_CONFIG_HOME=$HOME/tmpdir
    PROJECT_DIR="$PWD"
    ENV_PREFIX="$PROJECT_DIR"/env
    PATH="$HOME/.local/bin:$PATH"

    module purge
    module load machine_learning
    # conda activate "$ENV_PREFIX" (Optional for conda environments)

    # Setup SSH tunneling
    COMPUTE_NODE=$(hostname -s) 
    CODE_SERVER_PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

    # ... (Instructions for SSH tunneling)

    # Launch code-server
    code-server --auth none --bind-addr ${COMPUTE_NODE}:${CODE_SERVER_PORT} "$PROJECT_DIR"
 

Training Torch DDP Example
----------------------------

Here's an example SLURM script for training a PyTorch model using Distributed Data-Parallel (DDP) across multiple GPUs:

.. code-block:: 

    #!/bin/bash

    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=4
    #SBATCH --ntasks=1
    #SBATCH --nodes=1
    #SBATCH --cpus-per-task=16
    #SBATCH --time=00:30:00
    #SBATCH --mem=50G

    module load machine_learning
    export OMP_NUM_THREADS=1
    srun -n 1 -N 1 -c ${SLURM_CPUS_PER_TASK} python -m torch.distributed.launch --nproc_per_node=${SLURM_GPUS_PER_NODE}  train_ddp.py
 

This script allocates 4 GPUs, 1 node, and 16 CPUs per task. It sets the OpenMP threads to 1 for efficient GPU utilization and launches the train_ddp.py script using torch.distributed.launch with the appropriate number of processes per node.

Additional Information
----------------------

Available Versions: 

.. code-block::
    
    machine_learning/2023.01  machine_learning/2023.09  machine_learning/2024.01  machine_learning/2024.01.dev 

Full examples: `Data-Science onboarding repository <https://github.com/kaust-rccl/Data-science-onboarding.git>`_


.. list-table:: **Lastest version brief information**
   :widths: 40 40
   :header-rows: 0

   * - python                 
     - 3.10.13
   * - pytorch
     - 2.1.2
   * - tensorflow
     - 2.14.0
   * - pandas
     - 1.5.3
   * - keras
     - 2.14.0
   * - rapids
     - 23.10.00             
   * - jupyterlab
     - 3.6.6
   * - code-server
     - 4.16.1



                    
                   
              
         