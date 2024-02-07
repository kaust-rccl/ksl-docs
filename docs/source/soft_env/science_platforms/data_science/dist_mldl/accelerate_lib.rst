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
        - pytorcj
        - nvidia
        - anaconda
        - defaults
    dependencies:
        - python=3.11.5
        - pip=23.2.1
        - accelerate=0.22.0
        - cudatoolkit=11.8
        - transformers=4.33.1
        - pytorch=2.0.1
        - torchvision=0.15.2
        - torchaudio=2.0.2
        - pytorch-cuda=11.8
        - scikit-learn=1.2.2
        - evaluate=0.4.0

Once you created the file, run the following command to create the conda environment:

.. code-block::
    
    conda env create -f env.yml

Running Accelerate
-------------------

You can find an example Python training file in: `complete_nlp_example.py <https://github.com/huggingface/accelerate/blob/main/examples/complete_nlp_example.py>`_

Launching accelerate in interactive session
********************************************

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

Launching accelerate in a jobscript
*************************************

You can simply run accelerator through a slurm jobscript

Change <conda_installation_path> with the installation path for your conda.

.. code-block:: 

    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH -J accelerate_test
    #SBATCH --gres=gpu:v100:8
    #SBATCH --time=01:00:00

    source <conda_installation_path>/etc/profile.d/conda.sh

    conda activate acc_env

    accelerate launch --multi_gpu complete_nlp_example.py --checkpointing_steps epoch


The output should be redirected to ``slurm-####.out`` file

.. code-block::
    
    $ cat gpu210-10-27293860.out
    epoch 0: {'accuracy': 0.6862745098039216, 'f1': 0.8134110787172011}
    epoch 1: {'accuracy': 0.7352941176470589, 'f1': 0.8291139240506329}
    epoch 2: {'accuracy': 0.7647058823529411, 'f1': 0.8426229508196722}