.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: SLURM jobscript
    :keywords: SLURM,job scheduling

.. _slurm_jobscript:

===========================
SLURM jobscript explained
===========================

Batch jobs can be submitted to SLURM scheduler so they can run when the requested resources are available for use. 
This section introduces what a jobscript is and how to configure it to request different allocatable resources.

Basic jobscript
================

A typical jobscript has two major sections:

* SLURM Directives
* The commands to run on allocated computational resource

Below is an example jobscript which request **32 cores** of a CPU on a KSL system, all collocated on the **1 compute node**, with a wall time/duration of **1 hour**. It also mentions which **SLURM account** should the usage be charged to what **name** should SLURM label it as to make querying it convenient for the user. 

.. _slurm_basic_jobscript:

.. code-block:: bash
    :caption: a basic jobscript

    #!/bin/bash

    #SBATCH --job-name=my-first-job
    #SBATCH --ntasks=32
    #SBATCH --ntasks-per-node=32
    #SBATCH --partition=workq
    #SBATCH --account=<project_id>
    #SBATCH --time=01:00:00

    srun -n 32 ./helloworld
    

The very first line in the :ref:`example above <slurm_basic_jobscript>` activates a new ``bash shell``. This will ensure the environment from the place the job was submitted does not forward to the job. You may append ``#!/bin/bash --login`` to this line to allow activating the environment in the file ``~/.bashrc`` in home directory. 

.. note:: 
    The user must ensure that nothing unwanted is loaded in ``~/.bashrc`` or else the job can have unintended behavior. 

The lines starting with the clause **#SBATCH** are directives to SLURM. For any other program, these are treated as comments since they all start with ``#`` symbol. As explained above, the job requests 32 cores one node for 1 hour and the usage be charged to k1001 account. The jobscript also prescribes that the job be queued in the SLURM partition ``workq``. Users should check which partitions exist on the KSL system they want to submit their jobs on. 

.. note:: 
    Some SLURM directives have default values. If a jobscript doesn't have it set, the default values will be assumed. It is always a good practice to set the SLURM directives explicitly for better readability. 

To submit the :ref:`jobscript <slurm_basic_jobscript>`, ``sbatch`` command is used.

.. code-block:: bash
    :caption: submitting the basic jobscript

    sbatch jobscript.slurm