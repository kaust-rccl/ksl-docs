.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: SLURM commands
    :keywords: SLURM,job scheduling

**************** 
Common commands
****************
Slurm provides different commands are utilities to interact with a cluster. 
We start with listing some basic commands every user of KSL computational platforms should be aware of. 

Slurm utilities
===============
SLURM provides utilites for:

#. querying resources and their status
#. specifying and submiting resource requests
#. monitoring and managing the submitted resources
#. reporting for usage

Querying system resource
-------------------------

sinfo
^^^^^^

``sinfo`` command gives an overview of the resources offered by the cluster, while the squeue command shows to which jobs those resources are currently allocated.
By default, sinfo lists the partitions that are available. A partition is a set of compute nodes (computers dedicated to ... computing,) grouped logically. Typical examples include partitions dedicated to batch processing, debugging, post processing, or visualization.

.. code-block:: bash
    :caption: an example output of ``sinfo`` on Shaheen 2

    cdl4:~> sinfo

    PARTITION   AVAIL JOB_SIZE  TIMELIMIT   CPUS  S:C:T NODES STATE     
    workq*      up    1-6158   1-00:00:00     64 2:16:2     3 down*     
    workq*      up    1-6158   1-00:00:00     64 2:16:2     4 drained   
    workq*      up    1-6158   1-00:00:00     64 2:16:2  2289 allocated 
    workq*      up    1-6158   1-00:00:00     64 2:16:2  3862 idle      
    72hours     up    1-512    3-00:00:00     64 2:16:2     3 down*     
    72hours     up    1-512    3-00:00:00     64 2:16:2     4 drained   
    72hours     up    1-512    3-00:00:00     64 2:16:2  2289 allocated 
    72hours     up    1-512    3-00:00:00     64 2:16:2  3858 idle      
    debug       up    1-4           30:00     64 2:16:2    16 idle  

The output of ``sinfo`` is a snapshot of the total resources, those in use, and avialable in different partitions in SLURM on the target KSL platform.
This command accepts a number of filters to modify the default output based on the information needed. 
For more information please try ``man sinfo`` for a detailed guide for using ``sinfo``.


squeue
^^^^^^
``squeue`` is a convinient SLURM command to query status of jobs on the target KSL platforms. 
The default output of this command is a list of all the jobs submitted by users, their state, and either forecasted start time or elapsed time for pending and running jobs respectively.

.. code-block:: bash
    :caption: an example output of ``squeue`` on Shaheen 2
    
    cdl4:~> squeue
    JOBID       USER     ACCOUNT           NAME  ST REASON    START_TIME                TIME  TIME_LEFT NODES
    32794944    villenm   k1527         PAR_BN   R  None      2023-07-31T14:45:31   23:57:52       2:08     1
    32803782    raboudn   k1478       A_120714   R  None      2023-08-01T14:37:01       6:22       3:38     1
    32794946    villenm   k1527       PAR_ring   R  None      2023-07-31T14:48:02   23:55:21       4:39     1
    32754321    aljuhas   k1333      threenode  PD AssocMaxJ  N/A                       0:00 3-00:00:00     3
    32798918    raboudn   k1478      AGRA12_13  PD Dependenc  N/A                       0:00 1-00:00:00     1
    32803362    wangy0m   k1504         run_63  PD Dependenc  N/A                       0:00   23:59:00    52

It is common to limit the default output to a user's own jobs. For this, ``squeue`` conviniently provide filter by:

* username
* jobname
* jobid

For example

.. code-block:: bash
    :caption: filtering the ``squeue`` output by username

    cdl2:~> squeue -u $USER
    JOBID       USER ACCOUNT           NAME  ST REASON    START_TIME                TIME  TIME_LEFT NODES
    32803928   shaima0d     k01   jupyter-dask   R None      2023-08-01T14:57:02       1:13      58:47     1
    32803927   shaima0d     k01     task.slurm   R None      2023-08-01T14:56:20       1:55    1:58:05     5


.. code-block:: bash
    :caption: filtering the ``squeue`` output by jobname
    
    cdl2:~> squeue -u jupyter-dask
    JOBID       USER ACCOUNT           NAME  ST REASON    START_TIME                TIME  TIME_LEFT NODES
    32803928   shaima0d     k01   jupyter-dask   R None      2023-08-01T14:57:02       1:13      58:47     1

.. code-block:: bash
    :caption: filtering the ``squeue`` output by jobid
    
    cdl2:~> squeue -j 32803928
    JOBID       USER ACCOUNT           NAME  ST REASON    START_TIME                TIME  TIME_LEFT NODES
    32803927   shaima0d     k01     task.slurm   R None      2023-08-01T14:56:20       1:55    1:58:05     5


Specifying resources
--------------------

sbatch
^^^^^^

salloc
^^^^^^

srun
^^^^^

Monitoring and managing jobs
-----------------------------

scancel
^^^^^^^


scontrol
^^^^^^^^

Reporting usage 
----------------

sacct
^^^^^^

