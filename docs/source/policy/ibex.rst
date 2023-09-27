.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Policies on Ibex
    :keywords: Policies, policy

.. _policies_ibex_storage:

==============
Ibex
==============

Access policies
================

* A user must have KAUST credentials to access Ibex cluster
* Access for external users (non-KAUST) is rigorously reviewed by RCAC. External users generally apply for access to Shaheen 3.
* To access Ibex cluster from outside KAUST, users will need a VPN connection. KAUST IT maintains a guide on `how to setup up a VPN <https://it.kaust.edu.sa/docs/default-source/services/network-connectivity/kaust-vpn/setup-kuast-vpn-and-duo.pdf?sfvrsn=8c0c88c7_4>`_ on your host machine

Job Scheduling policies
========================

.. note::
   A user on Ibex must be associated with a PI. An unassociated user will have sever restrictions in terms of how many compute resources they can request. `Check using your KAUST credentials to see if you are associated with a PI <https://my.ibex.kaust.edu.sa/teams>`_. 


* ``batch`` partition is the default partition/queue in SLURM on Ibex
* SLURM implements fair share allocation. This implies that a for frequent user the job priority will diminish progressively to promote jobs by a less frequent user  
* There is a maximum 14 days limit on wall time. Wall time must be specified in any type of job, interactive or batch.
* There is a limit of maximum of 2000 jobs running at a time. This also applies to jobarrays. 
* There is a limit of maximum of 1300 CPUs (cores) applied to running jobs at a time. 
* There is a maximum limit on allocating 24 GPUs in running jobs on Ibex. This limit applies to wether 1 job requesting 24 GPUs or 24 jobs requesting a single GPU.
* A maximum limit of 16TB memory applies to job running at a time.  

Limits on unassociated users
-----------------------------

Any user who is not associated with a PI will be have following restrictions on resources applied to their jobs:

*  a maximum request job time 2 days
*  a maximum request of 20 CPUs 
*  a maximum request of memory 256 GB
*  a maximum request of 1 GPU (only of types ``gtx1080ti`` or ``rtx2080ti``)

Once user has a PI, he can use Ibex normally.
    

Storage policies
=================

Home directory
--------------

* Each $HOME directory is subject to a hard quota limit of 200GB; if you hit your quota, then you must start either deleting files or move them to a different storage space
* ``/home`` filesystem is not a high performance filesystem. The directories and files are not intended to be written by compute jobs. Use of a ``/home`` directory during a high performance or parallel compute job may negatively impact its use for all users. System administrators will be quick to kill jobs that are running on /home.
* The NetApp storage system which stores the ``/home`` directories has been designed for redundancy and high availability. This guarantees data will be protected at all times. Home directories are also regularly backed up.
* Home directories are intended for the use of their owner only; *sharing the contents of home directories with other users is strongly discouraged*
* User home directories are provided by NFS and are not purged
* Home directories should be used to build/compile source code and store important files such as results

User HPC directory
-------------------

* ``/ibex/user/$USER`` is your HPC storage. Use this storage for saving the output of, and input to compute jobs. This is much faster than your home directory so your jobs will run quicker. 
* This directory has a limit of 1.5TB. If you need more storage contact the Ibex support team. 
* ``/tmp`` is for job specific temporary files specify this directory. Once your job finishes all files in this directory will be deleted. Placing job temporary data in this directory will result in higher performance than storing it in your scratch area; won't contribute towards your used quota; and will automatically be deleted when your job finishes.

