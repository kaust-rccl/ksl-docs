.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Available systems at KSL -- Filesystems
    :keywords: lustre, scratch, project, iops, bandwidth, tier
    
.. _shaheen3_filesystem:

==============
Filesystems
==============

Shaheen III has 3 filesystems accessible to users:

Home directories
-------------------
Users' home directories are independent of local disk storage and are NFS auto-mounted, served from a NetApp storage system. Each home directory is subject to a hard quota limit of 200GB with the soft limit at 180GB; if you hit your quota, then you must start either deleting unnecessary files or moving them to a different storage space.

This storage systems is referred to as ``$HOME`` or ``/home`` and is mounted ONLY on Shaheen III login nodes and DTNs (Data Transfer Nodes). Compute nodes do NOT mount this storage, so any data you have on ``$HOME`` will not be visible to the compute nodes and thus, to the job that is running. This also means that jobs submitted from ``/home`` will fail.
This storage system provides snapshots of your home directory which are taken at regular intervals, so you can recover files back to a previous state by copying them from ``$HOME/``.snapshot to their original location. This is NOT an alternative to version control so we strongly encourage any users who make frequent changes to their code to use versioning software such as Git. It is important to understand that snapshots are NOT backups and should not be treated as such.

Scratch storage
----------------


A shared Lustre parallel filesystem is connected to the same network fabric with multiple tiers. The high performance SSD-based tier delivers a stunning IO bandwidth of over 3.7TB/s in read and 2.5TB/s of write using the IOR benchmark.


The ``/scratch`` directory should only be used for temporary data for running jobs, as it is subject to a rigorous purge policy described below. Any files that you need to keep for longer-term use should reside in the ``/project`` directory. Please note that as ``/scratch`` is designated as temporary storage, the data is NOT backed up.

The ``/scratch`` filesystem is a Lustre parallel filesystem with ~30 PB of total available shared disk space. Underpinning the filesystem is an HPE E1000 Storage System connected to the rest of the Shaheen III supercomputer via Slingshot 11 network with the adequate number of links to fully utilize its capabilities.


This storage is a tiered storage providing 3 levels of performance:

Capacity
*********
This is the default tier and is based on spinning disks (HDD) with a maximum bandwidth of around 250GB/s. It is recommended for working with large files that do not require many IO operations (IOPs).

Total usable space is 25.27 PB and the default quota is 10 TB
This tier is available via: ``/scratch/<username>``

Bandwidth
**********

This tier is based on SSD NVMe drives with significant bandwidth up to 2.5TB/s. It is recommended for working with medium to large files and jobs that require a high IO bandwidth.
Total usable space is 6 PB and the default quota is 1 TB
This tier is available via: ``/scratch/<username>/bandwidth/``

IOPs
******

This tier is also based on SSD NVMe drives. Its main characteristics is its ability to perform more than 12 Million IO operation per second (IOPs). It recommended for working with large number of small files and jobs that perform a very large amount of IOPs.
Total usable space is 300TB and the default quota is 50 GB
This tier is available via: ``/scratch/<username>/iops/``


Project storage
----------------

The project storage system should be used to store long term important data. This /project storage filesystem is a Lustre parallel filesystem with 37 PB of total available disk space. Underpinning the filesystem is an HPE E1000 Storage System connected to the rest of the Shaheen III supercomputer via Slingshot 11.

This storage is available:

* READ-WRITE on all Shaheen III login nodes via the path ``/lustre2/project``
* READ-WRITE on all Shaheen III Data Transfer Nodes (DTNs) via the path ``/lustre2/project``
* READ-ONLY on all Shaheen III compute nodes via the path ``/lustre2/project``


In this case there is only 1 tier based on spinning disks (HDDs) since the target of this storage is NOT to run jobs but to store data long term. Any files created in /project directory will have a copy made to tape within 8 hours of creation by an automatic process utilizing HPE DMF.

This storage is NOT purged automatically but does have strict quotas. The default quotas are:

* 80 TB per PI, independent of the number of projects the PI might have.
* 1 million files per user.

In order to check the user's quota on the project filesystem, you can use the following command:

.. code-block:: bash
    
    lfs quota -uh <user> /lustre2
