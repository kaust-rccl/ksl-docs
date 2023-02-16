==================
Quick Start Guide
==================

If you are familiar with HPC clusters and need a quick reference on the specifics of how to intereact with KSL computational resources, you will find all the relevant inforamtion here.

Shaheen 2
=========
Login
-----
To login you need to ``ssh`` into the login node.

.. code-block:: bash
    :caption: SSH command to login to Shaheen 2

    ssh -X username@shaheen.hpc.kaust.edu.sa


SLURM Jobscript
---------------
The following jobscript needs to be submitted from ``/scratch/$USER`` directory.
This is imaprative because ``/home`` directory is not mounted on compute nodes. Also ``/project`` directory is read-only on compute node.

.. code-block:: bash
    :caption: Change directory to ``/scratch``, copy the jobscript below and paste it in a file named e.g. ``jobscript.slurm``

    #!/bin/bash
    #SBATCH --time=00:10:00
    #SBATCH --nodes=1
    #SBATCH --ntasks=32
    #SBATCH --hint=nomultithread

    srun -n ${SLURM_NTASKS} --hint=nomultithread /bin/hostname

The above jobscript can now be submitted using the ``sbatch`` command.

.. code-block:: bash
    
    sbatch jobscript.slurm

If you get an error in regarding account specifcation, please  `email helpdesk <help@hpc.kaust.edu.sa>`_ with the your username and error and the jobscript.