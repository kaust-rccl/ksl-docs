.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Ibex login quickstart
    :keywords: ibex, login

.. _quickstart_ibex_login:

==========================
Ibex
==========================
To login you need to ``ssh`` into the login node.
A ``ssh`` client should be installed on your workstation/laptop. 
For users with MacOS and Linux operating system, please open the ``Terminal`` application paste command below replacing your username for Shaheen 3.
For Windows users, you will need a application with ``ssh`` client installed within it. Please follow instruction in `this video tutorial <https://www.youtube.com/watch?v=xfAydE_0iQo&list=PLaUmtPLggqqm4tFTwhCB48gUAhI5ei2cx&index=20>`_ . When logging in to Shaheen 3, please replace the hostname with `shaheen.hpc.kaust.edu.sa` when following the steps prescribed in the tutorial.

Logging into Ibex
===================
.. code-block:: bash
    :caption: SSH command to login to Ibex CPU login node

    ssh -X username@ilogin.ibex.kaust.edu.sa

.. code-block:: bash
    :caption: SSH command to login to Ibex GPU login node

    ssh -X username@glogin.ibex.kaust.edu.sa

.. _quickstart_ibex_jobscript:

Submitting your first Jobscripts
================================
All KSL systems use SLURM for scheduling jobs for batch processing.
Ibex example jobscripts
---------------------------
The jobscript below submits a job to SLURM for running an example workload on Ibex CPU compute nodes. Note that Ibex nodes are shared and you must specify the resources you require in terms of cores or CPUs and/or memory, and wall time. 


.. code-block:: bash
    :caption: Copy the jobscript below and paste it in a file named e.g. ``cpu_ibex.slurm`` in your ``home`` directory.

    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=4

    srun -n ${SLURM_NTASKS}  /bin/hostname

The above jobscript can now be submitted using the ``sbatch`` command.

.. code-block:: bash
    
    sbatch cpu_ibex.slurm

For submitting a job with GPUs, the jobscript must define the number of GPUs required and on how many nodes. The example below requests two NVIDIA V100 GPUs on a single node with a total of 8 CPUs and a total of 100GB of memory.

.. code-block:: bash
    :caption: Copy the jobscript below and paste it in a file named e.g. ``gpu_ibex.slurm`` in your ``home`` directory.

    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --gpus=2
    #SBATCH --gpus-per-node=2
    #SBATCH --cpus-per-task=8
    #SBATCH --ntasks=1
    #SBATCH --memory=100G

    module load cuda

    srun -n ${SLURM_NTASKS} -c ${SLURM_CPUS_PER_TASK} nvidia-smi

The above jobscript can now be submitted using the ``sbatch`` command.

.. code-block:: bash
    
    sbatch gpu_ibex.slurm





KSL has written a convenient utility called :ref:`Jobscript Generator <jobscript_generator>`. 
Use this template to create a jobscript and copy-paste it in a file in your SSH terminal on Shaheen 3 or Ibex login nodes.


If you get an error in regarding account specification, please  :email:`helpdesk <ibex@hpc.kaust.edu.sa>` with the your username and error and the jobscript.


