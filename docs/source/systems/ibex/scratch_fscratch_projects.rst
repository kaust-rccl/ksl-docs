scratch, fscratch and projects
------------------------------

**scratch, fscratch and projects**

Cluster wide /ibex/scratch storage
==================================

Ibex cluster has cluster wide /ibex/scratch filesystem which is accessible from all login nodes and compute nodes.

Under This path, you will find a directory with your login name, which will correspond to your own personal scratch space. For example:

    * /ibex/scratch/grimanre/

/ibex/scratch is based on beegfs file system and consists of 3.6 PB of storage distributed over 12 storage servers.

This scratch storage should be used when running jobs on compute nodes

Policies

    * Each user directory under /ibex/scratch is subject to a hard quota limit of 1.5TB
    * No purge policy is applied

To check your current usage on /ibex/scratch file system you can use bquota command

Cluster wide /ibex/fscratch storage
===================================

Another cluster wide filesystem is /ibex/fscratch. It is accessible from all login nodes and compute nodes.

It's based on BeeGFS filesystem with 116 TB of NVMe disks.

This storage should only be used by applications or code that requires little amount of space, but very high IOPs.

To apply for fscratch directory, please follow the procedure in projects section below.

Cluster wide Projects storage
=============================
It's based on BeeGFS filesystem. project directories are located under /ibex/scratch/projects.

To apply for a projects (or fscratch) directory please send an e-mail to ibex@hpc.kaust.edu.sa providing approval from your PI and containing the following details:

    * Project title
    * brief project description (one line is ok)
    * storage required
    * The name of the PI
    * The names of any collaborators.

Local Compute Node scratch storage
==================================
There is a another scratch filesystem which is local to each compute node. This scratch filesystem is based on each individual compute node’s local hard disk drive (whether it’s HDD, SSD or NVMe), thus it might vary in size and speed from one compute node to another. Nevertheless, you can access this storage locally by following the path: /local/scratch.

Files on local scratch will be automatically deleted after job finishes. So it's users responsibility to move any important files to their home or cluster wide scratch directories before their jobs are terminated.

 

We appreciate if users delete unnecessary files once their jobs have finished in order to avoid filling up the scratch filesystems. You can handle cleaning up your temp files in the job script.

 

**Scratch filesystems are not backed up, recoverable nor checkpointed. These filesystems are not appropriate for long-term storage nor for storing important files. If you accidentally delete a file, or the filesystem crashes, they cannot be restored.**
