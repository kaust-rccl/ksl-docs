.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Accelerate lib by Hugging Face
    :keywords: accelerate

.. _accelerate:

==========================================
Accelerate API by Hugginface
==========================================



Accelerate provides an easy API to make your scripts run on any kind of distributed setting (multi-GPU on one node, multi-GPU on several nodes) while still letting you write your own training loop.


Accelerate on Ibex
==================

Installing Accelerate
-----------------------

You’ll need to install conda first, please check  

You can save the following as a file named env.yml

.. code-block::

    name: acc_env
    channels:
        - conda-forge
        - pytorch
        - nvidia
        - anaconda
        - defaults
    dependencies:
        - datasets=2.3.2
        - python=3.9
        - pip=23.2.1
        - accelerate=0.29
        - cudatoolkit=11.8
        - transformers=4.33.1
        - pytorch=2.0.1
        - torchvision=0.15.2
        - torchaudio=2.0.2
        - pytorch-cuda=11.8
        - scikit-learn=1.2.2
        - evaluate=0.4.0
        - pytest

Once you created the file, run the following command to create the conda environment:

.. code-block::
    
    conda env create -f env.yml

Running Accelerate
======================

You can find an example Python training file in: `complete_nlp_example.py <https://github.com/huggingface/accelerate/blob/main/examples/complete_nlp_example.py>`_

Launching accelerate in interactive session
----------------------------------------------

You can start by requesting an interactive session from slurm with the desired number of GPUs.
Ex:

.. code-block:: 
    
    $ srun -N 1 --gres=gpu:v100:8 --time=3:0:0 --pty bash

You’ll then need to activate the conda environment.

.. code-block::
    
    conda activate acc_env

Finally, you can start the training process by calling accelerator’s launcher.

.. code-block::
    
    accelerate launch --multi_gpu complete_nlp_example.py

Optionally you can add ``--checkpointing_steps epoch`` at the end to create checkpoints after each epoch.

The output should look like the following.

The following values were not passed to ``accelerate launch`` and had defaults used instead:

- ``--num_processes`` was set to a value of ``8``
- ``--num_machines`` was set to a value of ``1``
- ``--mixed_precision`` was set to a value of ``no``
- ``--dynamo_backend`` was set to a value of ``no``

To avoid this warning pass in values for each of the problematic parameters or run ``accelerate config``.

.. code-block::
    
    epoch 0: {'accuracy': 0.6862745098039216, 'f1': 0.8134110787172011}
    epoch 1: {'accuracy': 0.75, 'f1': 0.840625}
    epoch 2: {'accuracy': 0.8137254901960784, 'f1': 0.8671328671328671}

MultiGPU on single node as batch job
-------------------------------------

You can simply run accelerator through a slurm jobscript

Change <conda_installation_path> with the installation path for your conda.

.. code-block:: bash
    :caption: An example jobscript requesting 8 GPUs on a single node with 32 CPU worker processes ```accelerate``` will use to parallelize data-loading. Please replace the appropriate values in < ## > placeholders.  

    #!/bin/bash

    #SBATCH --job-name=multiGPU
    #SBATCH --tasks-per-node=1     
    #SBATCH --gpus=8
    #SBATCH --gpus-per-node=8
    #SBATCH --cpus-per-task=32         
    #SBATCH --time=00:10:00


    source <conda_installation_path>/bin/activate <acc_env>

    accelerate launch --multi_gpu complete_nlp_example.py --checkpointing_steps epoch


The output should be redirected to ``slurm-####.out`` file.



.. code-block:: bash 

    $ cat gpu210-10-27293860.out
    epoch 0: {'accuracy': 0.6862745098039216, 'f1': 0.8134110787172011}
    epoch 1: {'accuracy': 0.7352941176470589, 'f1': 0.8291139240506329}
    epoch 2: {'accuracy': 0.7647058823529411, 'f1': 0.8426229508196722}

MultiGPU on single node as batch job
-------------------------------------
To scale out and run on more GPUs, we will need to request multiple nodes with multiple GPUs on each node. 
The following example jobscirpt demonstrate how to scale to 16 V100 GPUs on 4 nodes such that each node has 4 GPUs.

.. code-block:: bash
    :caption: An example jobscript requesting 16 GPUs on a 4 nodes with 4 GPUs and 16 CPU worker processes each. Please replace the appropriate values in < ## > placeholders. 

    #!/bin/bash

    #SBATCH --job-name=multiGPU
    #SBATCH --tasks-per-node=1     
    #SBATCH --gpus=16
    #SBATCH --gpus-per-node=4
    #SBATCH --cpus-per-task=16         
    #SBATCH --time=00:10:00


    source <conda_installation_path>/bin/activate <acc_env>

    export master_ip=$(/bin/hostname -I | cut -d " " -f 2 )
    export master_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

    export HF_METRICS_CACHE=$PWD/cache
    mkdir -p $HF_METRICS_CACHE
    
    export TOKENIZERS_PARALLELISM=false

    srun -l ./wrapper.sh

Whereas the ```wrapper.sh```, as shown below, is an executable script that launches the processes on each node. It is important to relocate the cache directory to somewhere in ```/ibex/user/$USER``` directory where Hugginface ```evaluate``` library will maintain the metrics files. The library manages file locking to avoid race conditions. We have found that having this directory in default location on HOME filesystem has caused issues and the ```/ibex/user/$USER``` directory resolves this due to lower latency to fullfil frequent metadata queries. 

.. code-block:: bash
    :caption: A wrapper script to make use of SLURM's output environment variable which are only set when ```srun``` command executes. In this case ```SLURM_NODEID``` is the variable of interest.

    #!/bin/bash

    export LAUNCHER="accelerate launch \
          --num_processes  ${SLURM_GPUS}  \
          --num_machines ${SLURM_NNODES} \
          --rdzv_backend static \
          --machine_rank ${SLURM_NODEID} \
          --main_process_ip ${master_ip} \
          --main_process_port ${master_port} \
          --same_network \
          "
    export SCRIPT="../complete_nlp_example.py"

    export SCRIPT_ARGS=" \
          --mixed_precision no 
          "

    echo $LAUNCHER $SCRIPT $SCRIPT_ARGS
    $LAUNCHER $SCRIPT $SCRIPT_ARGS

