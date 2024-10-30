.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Policies on Ibex
    :keywords: Policies, policy, Shaheen III

.. _shaheen3_policies:

===============
Shaheen III 
===============

Shaheen III has a total of 4608 compute nodes, 4 login nodes, 4 datamover nodes and 15 pre-post processing nodes. SLURM scheduler is used to schedule different kinds of workloads as jobs submitted by users. Additionally, Shaheen III's large storage is also shared between compute nodes and is capable of serving multiple users simultaneously. Policies help streamline the user experience by enforcing quotas and limits on a user or project level. Users must understand these policies before planning their simulation campaigns.  


SLURM Policy
============
SLURM on Shaheen III has multiple partitions. These partitions exist so that jobs can be routed to different types of computational resources, according to the required of the scheduled workloads.

The table below show the job limits enforced on different partitions.

.. note::
  - The term **CPUs** refers to hyperthreads running on a physical core, i.e. 2 CPUs per physical core
  - Note that these are enforced on per-user basis
  - The usage is accounted on the basis of physical core, i.e. for each 2 CPUs allocated for an hour, 1 core hour is billed.
  - On workq, which is an exclusive allocation of node, full 192 core hours are charged, irrespective of the number of CPUs used. 
  - For access to 72hour partition, the users must send an email request with a justification.

.. _shaheen_slurm_limits:
.. list-table:: **SLURM job limits**
   :widths: 30 30 20 20 20 20 20 20 
   :header-rows: 1

   * - Partition
     - Tenancy
     - Total nodes
     - Max CPUs/job
     - Max Nodes/job
     - Max Walltime/job (hrs)
     - Max jobs per user submitted
     - Max jobs per user running
   * - workq
     - exclusive
     - 4608
     - 786432
     - 2048
     - 24
     - 1000
     - 200
   * - shared
     - shared
     - 16
     - 64 (4/node)
     - 16
     - 24
     - --
     - --
   * - debug
     - exclusive
     - 4
     - 384
     - 1
     - 0.5(default)/4(max)
     - 1
     - 1
   * - dtn
     - exclusive
     - 4
     - 1024
     - 4
     - 1(default)/24(max)
     - --
     - --
   * - ppn
     - exclusive
     - 15
     - 3840
     - 15
     - 1(default)/24(max)
     - --
     - --
   * - 72hours
     - exclusive
     - 128
     - 6144
     - 16
     - 1(default)/72(max)
     - 32
     - 3


Filesystem Policy
=========================
All filesystems on Shaheen III are shared among users. Policies help enable consistent user experiences. It is advised that users read technical documentation provided on this website, attend instructor-led and self-paced trainings by KSL staff, and email :email:`help@hpc.kaust.edu.sa` in case of any question or ambiguity.

``scratch`` filesystem
---------------------------

``scratch`` is a high performance filesystem on Shaheen III meant for temporary use during the lifetime of the job. For persistent storage, users must move their **unused** data to ``project`` filesystem.

``scratch`` has three tiers; please see documentation on :ref:`shaheen3_filesystem` for more details. There are two quotas enforced on ``scratch``, capacity and inodes. The table below lists quotas on three tiers:

.. _shaheen_scratch_quotas:

.. list-table:: **Scratch filesystem quotas**
   :widths: 30 20 20 30
   :header-rows: 1

   * - Tier
     - capacity
     - inodes
     - scope
   * - Capacity
     - 10TB
     - 1 million
     - per user
   * - Bandwidth
     - 1TB
     - 1 million
     - per user
   * - IOPS
     - 50GB
     - 1 million
     - per user

.. note:: 
    - The inode quota, which is synonymous to number of files per user, is a global policy that governs the files in all tiers of ``scratch``. A user can create and maintain no more than 1 million files on ``scratch`` cumulatively.
    - All files expect those in IOPS tier are subject to **60 day** purge policy.  

For checking personal filesystem quotas on both ``scratch`` and ``project``, KSL system administration maintains a convinient utility called ``kuq`` which is an ancronym of ``KSL User Quota``. It lists a users quota allocation and usage on all tiers of ``scratch`` and also shows the inodes or number of files with limits and used. An example use is shown below:

.. code-block:: bash
  
  > kuq 
  -------------------------------------------------------------------------------------------
  Filesystem quota limits for user <username>
  Tier             Filesystem    used   quota   limit   grace   files   quota   limit   grace
  scratch            /scratch      4k      0k      0k       -       1       0 1000000       -
  capacity           /scratch      4k      0k     10T       -       1       0       0       -
  bandwidth          /scratch      4k      0k      1T       -       1       0       0       -
  iops               /scratch      4k      0k     50G       -       1       0       0       -
  project            /project      0k      0k      0k       -       0       0       0       -
  -------------------------------------------------------------------------------------------

.. note:: 
  For reliable metrics related the project quota and its usage, please use :ref:`kpq` utility. 

The same can be achieved by a user with the Lustre filesystem utility ``lfs`` on ``capacity``, ``bandwidth`` and ``iops`` tiers of ``scratch`` and on ``project`` respectively .  

.. code-block:: bash

    > lfs quota -uh ${USER} /scratch
    > lfs quota -uh ${USER} --pool capacity /scratch
    > lfs quota -uh ${USER} --pool iops /scratch



``project`` filesystem
-------------------------
``project`` filesystem is a persistent storage for users who are members of a project owned by their respective Principal Investigators (PI). A user can be member of multiple projects on Shaheen III. The ID assigned to each project is also used with SLURM to charging to the account when a job is submitted.
Below are some important policies users must know of:

- A PI has a default allocation of 80TB on ``project`` filesystem. This is shared among the members of the project. The usage of ``project`` filesystem can be queried by using the ``kpq`` utility (shorthand for KSL PI Quota). An example output of ``kpq`` is shown below:

.. _kpq:

.. code-block:: bash
  
  > kpq <project-id>
  ---------------------------------
  PI quota for : <NAME of PI>
  ---------------------------------
  Filesystem  used   quota   limit   grace   files   quota   limit   grace
  /project  71.24T      0k     80T       - 1992919       0       0       -
  /scratch    936k      0k      0k       -      72       0       0       -

To list the users belonging to a project the utility ``groupies`` can be used:

.. code-block:: bash

  groupies <project-id>

- ``project`` is mounted as read-only on compute nodes of Shaheen III, except on data mover nodes in ``dtn`` partition of SLURM. Please create jobs for moving data between ``scratch`` and ``project`` to maximize the throughput. There are a number of utilities listed in :ref:`data_management` documentation. In short, try to use the data mover nodes for movement of data wherever possible.


``home`` filesystem
-------------------------
``home`` filesystem on Shaheen III is available only on login nodes. This is the same ``home`` filesystem you see on Ibex system if you have access to it. On compute nodes of Shaheen III, ``home`` filesystem is redirected to ``/scratch/<username>/`` directory. 

``home`` filesystem has per user quota of **200GB** enforced. To query the quota, the following command can be used:

.. code-block::

    quota -s

``home`` usually is default filesystem for temporary cache files e.g. when using conda package manager, or pulling images using singularity container platform. It is advisable to clear caches every now and then to free space.