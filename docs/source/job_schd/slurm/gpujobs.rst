GPU Jobs 
-------------------


Single GPU jobs
=================

A Simple jobscript running a CUDA code on a single GPU on IBEX cluster

.. code-block:: bash
    
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --gpus=1
    module load cuda/11.2.2
    ./my_cuda_app

MultiGPU jobs
=================

A Simple jobscript running a CUDA code on 4 GPUs on single node on IBEX cluster

.. code-block:: bash
    
    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --cpus-per-task=4
    #SBATCH --mem=64G
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=4
    #SBATCH --constraint=v100
    source ~/miniconda3/bin/activate my_cuda_env
    srun –c 4 python train.py