.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Shared parallel filesystems on Ibex
    :keywords: WekaIO, home, parallel filesystem, Ibex
    
.. _ibex_filesystems:

==============
Filesystems
==============

As an integral subsystem of a HPC cluster, Ibex cluster provides shared storage as parallel filesystems (PFS) which were architected for specific purposes. These filesystems are mounted on each login and compute node of the cluster and the data created on these mountpoints is accessible for any compute resource. 
For each users, there are directories created on these filesystems which act as entrypoint for every user to store data. Users must keep in mind that this is a shared resource for files related to their computational work and is not a general purpose storage. Please refer to :ref:`policies_ibex_storage` for a commentary about what is permitted and what is not on these filesystems. 

The following filesystems mounted on Ibex cluster are:

* Home filesystem
* User's HPC filesystem
* Project HPC filesystem
* tmp filesystem

Home filesystem
----------------
`/home` filesystem is a place where users are expected to keep their configuration and installation scripts, the `rc` files required by some software. This filesystem has per user quota on both size and number of files. It can be access with the `/home/$USER` path. `/home` filesystem has limited performance. Users are expected **not to run their jobs and applications** from `/home` directory.

.. warning:: 
    Please refrain from installing your `conda` package manager, related cache, and environments in `/home/$USER` directory. Please use the `/ibex/user/$USER` filesystem for purpose.  

Upon login the current working directory of the session is the `$HOME` directory.
Home directories will be mounted automatically upon the first access to Ibex. Since each mount makes use of the compute node resources, automounting allows removal of unused mounts to free up those resources when the filesystems are no longer needed. This is particularly useful on compute nodes which over the course of time will mount many filesystems owned by many users and groups.

.. note:: 
    Due to the automounting of filesystems, you might not see one of your directories immediately. Your directories might take a second or two to show up because the automounting has not finished yet.

The physical system on which the `/home` directories are stored is a NetApp Cluster On Tap storage system and is mount on login and compute nodes as Network File System (NFS) mount point. `/home` filesystem is backed up therefore keeping your precious files like configuration and installation scripts in `/home/$USER` directory is a encouraged.

Users can check their quota on `/home` using the following command:

.. code-block:: bash
    :caption: Command to check the quota on `/home` filesystem

    $ quota -s

    Disk quotas for user ###### (uid ######): 
     Filesystem   space   quota   limit   grace   files   quota   limit   grace
    fs-nfs-60.admin.vis.kaust.edu.sa:/home/home
                   178G    180G    200G            853k   4295m   4295m  

In the case above, the maximum quota for capacity on `/home` filesystem is 200GB. 

Home directories are shared across all KSL systems so all your data stored on `/home` will be accessible from least the login nodes of any KSL system.

.. _ibex_user_hpc_fs:

User HPC filesystem
--------------------

`/ibex/user/$USER` is a high performance parallel filesystem which provides storage for running your jobs and read/write data. In contrast the `/home` filesystem, this filesystem has low latency, high bandwidth and is capable of high I/O operations per second (IOPS). This parallel storage runs :ref:`WekaIO Filesystem <ibex_wekaio>`, they are providers of modern parallel filesystems tailored for high IOPS workloads such as AI and Bioinformatics. 

User's HPC filesystem has a capacity of 1.5TB per users and remains for the lifetime of the user's account on Ibex. Users must manage their own files, which means if you run out of quota, there will be **no extensions to the quota** without exception. 

Users can check their quota on `/ibex/user/$USER` using the following command:

.. code-block:: bash
    :caption: Command to check the quota on `/home` filesystem

        $ df -h /ibex/user/$USER
        Filesystem      Size  Used Avail Use% Mounted on
        user            1.5T  1.3T  274G  83% /ibex/user         853k   4295m   4295m  



Example use cases
******************
Read/Write data during jobs
+++++++++++++++++++++++++++
For example, creating large input datasets in directories with root path `/ibex/user/$USER` for training Compute vision model is an appropriate usecase of this filesystem. Such dataset has large number of small files, needs to be read by a number of clients or compute nodes, and require both bandwidth and IOPS (open-read-close operations) on several files simultaneously. The impact of not using a high performance filesystem for such workload can be detrimental to the utilization of the precious GPUs the job is using because the data loading will suffer from stalls in the data ingest pipeline reading from a filesystem with suboptimal performance.

Additionally, if a deep learning model needs to write checkpoints, a directory in `/ibex/user/$USER/` is a good choice.  

In general, the IOPS and bandwidth performance of `/ibex/user/$USER` is at par with what one would expect from a local storage of a compute node (dedicated SSDs).
  
Installing self-maintained software
++++++++++++++++++++++++++++++++++++
Another interesting usecase is using `/ibex/user/$USER` as destination for installation of software. This is specially useful for those installing software via `conda` package manager. `Miniconda` installation somewhere with `/ibex/user/$USER` benefits from the high IOPS the WekaIO FS can provide.

.. _ibex_project_fs:

Project HPC filesystem
-----------------------
There are instances where your research team is collaborating on a common goal and is sharing or using the same input dataset. This is calls for a shared directory where a group of users can have access to files which can be managed by the one or more members of that group. 

`/ibex/project/c####` is root path to such a directory. This too is part of the same WekaIO filesystem as the User HPC filesystem above.

To get project allocation, users must :email:`email helpdesk <ibex@hpc.kaust.edu.sa>`. Users are required to add their respective Principal Investigator (PI) and they need to approve such request, before an allocation can be made. Up to 80TB of space can be requested through this process. For a larger request, please fill `this form <https://www.hpc.kaust.edu.sa/sites/default/files/files/public/documents/KSL_Project_Proposal.doc>`_, which will be presented in front of the RCAC committee, the awarding body for resources on KSL systems. After an approval is granted by RCAC, the applicant must :email:`email helpdesk <ibex@hpc.kaust.edu.sa>` to get the allocation on filesystem. 

.. _ibex_tmp_fs:

tmp filesystem
---------------
In case if users require a transient expansion of their :ref:`User HPC filesystem <ibex_user_hpc_fs>` or :ref:`project allocation <ibex_project_fs>` due to insufficient capacity, they may request it on `/ibex/tmp/$USER`. This is a space on the same WekaIO FS as above, and is temporary. The space is purged automatically after 60 days, with no exceptions. 

Local storage on compute node
------------------------------

There are some compute nodes with different capacities of NVMe local storage available. Users can create scratch directories in the root path `/local/` on a compute node within their application or Python script (if you are not prepending your workload with `srun` launcher, you can create the scratch directory in your jobscript.)

The motivation of using local storage on compute node can be:

* seeking isolation of I/O operations for your workload
* seeking maximum performance from your data ingest pipeline
* using GPD Direct storage use case

There are some limitations users must know before opting to run their workloads from `/local` directory:

* This mount point is only available on a compute node and cannot be accessed from a login node. 
* The user is responsible to stage in and stage out the data at the beginning and at the end of a job
* The mount points are node local, which means they are not shared between the compute nodes. If you job spans on two or more compute node, a process per node should copy the data into `/local`
* After the job is finished, SLURM cleans up the temporary directory and data will be lost
* Data movement has overhead and the job can be in a state of stall if the copy operation is moving large amount of data. This will be deducted from the job's allocated wall time

Given the above, a cost-benefit analysis should be done before using local storage. In any case, the performance on shared filesystem is at par with the local storage.

Reference datasets
--------------------

For common datasets used by a large group of users, Ibex cluster management team hosts such datasets as a service. The directory with root path `/ibex/ai/reference` is where users can access common large datasets. This again is on WekaIO FS, and is made readonly on all login and compute nodes. Jobs can therefore only read the input data and are expected to write output and checkpoints in :ref:`ibex_user_hpc_fs`.

A candidate dataset for this destination should fulfill the following requirements:

* The dataset must be public. No private datasets or encrypted datasets can be hosted in this directory
* The dataset must have been released under an opensource license (Ibex team will review the license)
* A user requesting for maintaining a dataset in reference dataset directory must justify that it will be used by a large number of users and research group. 
* A user requesting a dataset must also provide the relevant data processing scripts/workflow 

As an example, ImageNet 1K, or Bookcorpus are good examples of candidate datasets.

Users can :email:`email helpdesk <ibex@hpc.kaust.edu.sa>` to request curation of a dataset in the reference directory.
