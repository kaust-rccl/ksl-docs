.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Shaheen3 quickstart guide
    :keywords: shaheen3, quickstart

.. _quickstart_shaheen3:

==================================
Shaheen III
==================================

If you are familiar with HPC clusters and need a quick reference on the specifics of how to interact with KSL computational resources, you will find the relevant information here in a concise form. For details, please explore the other sections of the documentation starting from :ref:`available_systems`.

.. _quickstart_shaheen3_login:

Login
======
To login you need to ``ssh`` into the login node.
A ``ssh`` client should be installed on your workstation/laptop. 
For users with MacOS and Linux operating system, please open the ``Terminal`` application paste command below replacing your username for Shaheen III.
For Windows users, you will need a application with ``ssh`` client installed within it.

Logging into Shaheen III
------------------------

Shaheen III has a total of 5 login nodes. When logging into the machine using host `shaheen.hpc.kaust.edu.sa` the system will choose a login node to balance the node. All the login nodes are have same environment. Users, therefore, should always use `shaheen.hpc.kaust.edu.sa` host to login. 


The following is an example of logging in on Shaheen III:

.. code-block:: bash
    :caption: SSH command to login on Shaheen III

    ssh -X <username>@shaheen.hpc.kaust.edu.sa


.. _quickstart_shaheen3_jobscript:


Submitting your first Jobscripts
==================================

All KSL systems use SLURM for scheduling jobs for batch processing.

Shaheen III example jobscripts
------------------------------
On Shaheen III the example jobscripts below need to be submitted from ``/scratch/$USER`` directory.
This is imperative because ``/home`` directory is not mounted on compute nodes. Also ``/project`` directory is read-only on compute node.

.. note:: 
    Compute nodes in ``workq`` on Shaheen III are allocated in exclusive mode. For a detailed description of available partitions please refer to :ref:`shaheen3_policies`.

The following is a sample jobscript  ``cpu_shaheen3.slurm`` to print hostnames of one AMD Genoa compute nodes of Shaheen III in ``workq``.

.. code-block:: bash
    :caption: Change directory to ``/scratch``, copy the jobscript below and paste it in a file named e.g. ``cpu_shaheen3.slurm``

    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --partition=workq
    #SBATCH --nodes=1
    #SBATCH --ntasks=192
    #SBATCH --hint=nomultithread

    srun -n ${SLURM_NTASKS} --hint=nomultithread /bin/hostname

The above jobscript can now be submitted using the ``sbatch`` command.

 .. code-block:: bash
    
    sbatch cpu_shaheen3.slurm

.. To submit a GPU job on Shaheen III's Grace Hopper compute nodes, the following jobscript can be used:

.. .. code-block:: bash
..     :caption: Change directory to ``/scratch``, copy the jobscript below and paste it in a file named e.g. ``gpu_shaheen3.slurm``

..     #!/bin/bash
..     #SBATCH --time=00:10:00
..     #SBATCH --gpus=4
..     #SBATCH --gpus-per-node=4
..     #SBATCH --ntasks=4
..     #SBATCH --ntasks-per-socket=1
..     #SBATCH --cpus-per-task=64
..     #SBATCH --hint=nomultithread

..     srun -n ${SLURM_NTASKS} --hint=nomultithread nvidia-smi

.. The above jobscript can now be submitted using the ``sbatch`` command.

.. .. code-block:: bash
    
..     sbatch gpu_shaheen3.slurm


KSL has written a convenient utility called :ref:`Jobscript Generator <jobscript_generator>`. 
Use this template to create a jobscript and copy-paste it in a file in your SSH terminal on Shaheen III or Ibex login nodes.


If you get an error in regarding account specification, please  email :email:`helpdesk <help@hpc.kaust.edu.sa>` with the your username and error and the jobscript.


