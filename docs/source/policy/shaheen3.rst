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

.. _shaheen_slurm_limits:
.. list-table:: **SLURM job limits**
   :widths: 30 30 20 20 20 20 20 
   :header-rows: 1

   * - Partition
     - Tenancy
     - Max CPUs/job
     - Max Nodes/job
     - Max Walltime/job (hrs)
     - Max jobs submitted
     - Max jobs running
   * - workq
     - exclusive
     - 196,608
     - 512
     - 24
     - ###
     - ###
   * - shared
     - shared
     - 64 (4/node)
     - 16
     - 24
     - ###
     - ###
   * - debug
     - exclusive
     - 1536
     - 4
     - 0.5(default)/4(max)
     - ###
     - ###
   * - dtn
     - exclusive
     - 192
     - 4
     - 1(default)/24(max)
     - ###
     - ###
   * - ppn
     - exclusive
     - 3840
     - 15
     - 1(default)/24(max)
     - ###
     - ###
   * - 72hours
     - exclusive
     - 49152
     - 128
     - 1(default)/72(max)
     - ###
     - ###


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

Users can check the usage of their quotas on scratch using the following commands:

For overall quota on scratch:

.. code-block:: bash

    lfs quota -uh <username> /scratch

For quota on capacity tier on scratch:

.. code-block:: bash

    lfs quota -uh <username> --pool capacity /scratch

For quota on bandwidth tier on scratch:

.. code-block:: bash

    lfs quota -uh <username> --pool bandwidth /scratch

For quota on IOPS tier on scratch:

.. code-block:: bash

    lfs quota -uh <username> --pool iops /scratch

``project`` filesystem
-------------------------
``project`` filesystem is a persistent storage for users who are members of a project owned by their respective Principal Investigators (PI). A user can be member of multiple projects on Shaheen III. The ID assigned to each project is also used with SLURM to charging to the account when a job is submitted.
Below are some important policies users must know of:

- A PI has a default allocation of 80TB on ``project`` filesystem. This is shared among the members of the project. A list of users and their usage can be queried using the following command:

.. code-block::

    sb_user <project-id>

- ``project`` is mounted as read-only on compute nodes of Shaheen III, except on data mover nodes in ``dtn`` partition of SLURM. Please create jobs for moving data between ``scratch`` and ``project`` to maximize the throughput. There are a number of utilities listed in :ref:`data_management` documentation. In short, try to use the data mover nodes for movement of data wherever possible.


``home`` filesystem
-------------------------
``home`` filesystem on Shaheen III is available only on login nodes. This is the same ``home`` filesystem you see on Ibex system if you have access to it. On compute nodes of Shaheen III, ``home`` filesystem is redirected to ``/scratch/<username>/`` directory. 

``home`` filesystem has per user quota of **200GB** enforced. To query the quota, the following command can be used:

.. code-block::

    quota -s

``home`` usually is default filesystem for temporary cache files e.g. when using conda package manager, or pulling images using singularity container platform. It is advisable to clear caches every now and then to free space.