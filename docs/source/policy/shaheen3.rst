.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Policies on Ibex
    :keywords: Policies, policy, Shaheen 3


==========
Shaheen 3
==========

SLURM Polciy
============

General compute nodes
---------------------
Partition, wallclock
Warning about large jobs ( maintenance) to avoid draining in production.


PPN nodes
---------


Scratch Filesystem Policy
=========================
 

The ``/scratch`` filesystem is a `Luster <https://www.lustre.org/>`_ v2.12 parallel filesystem with 17.6 PB of total available disk space. Underpinning the filesystem is a Cray Sonexion 2000 Storage System consisting of 12 cabinets containing a total of 5988 x 4 TB SAS disk drives. The cabinets are interconnected by an FDR InfiniBand Fabric with Fine Grained Routing, where optimal pathways are used to transport data between compute nodes and OSSes (see below).

There are 73 LNET router nodes providing connectivity from the compute nodes to the storage over an InfiniBand Fabric, with a performance capability of over 500 GB/sec.

Each cabinet can contain up to 6 Scalable Storage Units (SSU); Shaheen II has a total of 72 SSUs. Each SSU contains 82 disks configured as two GridRAID [41(8+2)+2] arrays. GridRAID is Sonexion's implementation of a Parity Declustered RAID. An SSU also contains 2 embedded SBB form factor servers, configured as Lustre Object Storage Servers (OSS). The OSSes are configured with FDR InfiniBand for communicating with the LNET routers. An Object Storage Target (OST) is an ext4 filesystem that is managed by an OSS. These OST ext4 filesystems are effectively aggregated to form the Lustre filesystem. In the case of Shaheen II, there is a one-to-one relationship between OSSes and OSTs. As there are 2 OSS/OSTs for each SSU, this means that there are 144 OSTs in total (use the command ``lfs osts`` to list the OSTs).

 .. image:: static/lustre_layout.png

Lustre Stripe Count
********************
Striping a file across multiple OSTs can significantly improve performance, because the I/O bandwidth will be spread over the OSTs (round robin method). The ``/scratch`` filesystem default stripe size is set at 1MB and, following analysis of typical Shaheen file sizes, the default stripe count is set to 1, i.e. individual files will reside on one OST only, by default. The stripe count however can be increased by users to any number up to the maximum number of OSTs available (144 for Shaheen II). This can be done at the directory or file level. When the size of the file is greater than the stripe size (1MB), the file will be broken down into 1MB chunks and spread across the specified (stripe count) number of OSTs.

.. code-block:: default
    :caption: Example - Viewing the stripe information for a file

    $ lfs getstripe file1
    file1
    lmm_stripe_count:  8
    lmm_stripe_size:   1048576
    lmm_pattern:       raid0
    lmm_layout_gen:    0
    lmm_stripe_offset: 130
        obdidx         objid         objid         group
           130         408781270       0x185d81d6                 0
           104         419106989       0x18fb10ad                 0
           102         411979658       0x188e4f8a                 0
            36         403139579       0x18076bfb                 0
           112         409913235       0x186ec793                 0
            27         408240053       0x18553fb5                 0
            72         407370211       0x1847f9e3                 0
            97         403688203       0x180fcb0b                 0

In this example, the file is striped across 8 OSTs with a stripe size of 1 MB. The obdidx numbers listed are the indices of the OSTs used in the striping of this file.

.. code-block:: default
    :caption: Example - Viewing the stripe information for a directory

    $ lfs getstripe -d dir1
    dir1
    stripe_count:   1 stripe_size:    1048576 stripe_offset:  -1    


|

.. code-block:: default
    :caption: Example - Creating a new file with a stripe count of 10

    $ lfs setstripe -c 10 file2

|

.. code-block:: default
    :caption: Example - Setting the default stripe count of a directory to 4

    $ lfs setstripe -c 4 dir1

|

.. code-block:: default
    :caption: Example - Creating a new file with a stripe size of 4MB (stripe size value must be a multiple of 64KB)

    $ lfs setstripe -s 4M filename2

.. note::
    Once a file has been written to Lustre with a particular stripe configuration, you cannot simply use lfs setstripe to change it. The file must be re-written with a new configuration. Generally, if you need to change the striping of a file, you can do one of two things:

    * using lfs setstripe, create a new, empty file with the desired stripe settings and then copy the old file to the new file, or
    * setup a directory with the desired configuration and cp (not mv) the file into the directory

General Considerations
+++++++++++++++++++++++

Large files benefit from higher stripe counts. By striping a large file over many OSTs, you increase bandwidth for accessing the file and can benefit from having many processes operating on a single file concurrently. Conversely, a very large file that is only striped across one or two OSTs can degrade the performance of the entire Lustre system by filling up OSTs unnecessarily. A good practice is to have dedicated directories with high stripe counts for writing very large files into.

Another scenario to avoid is having small files with large stripe counts. This can be detrimental to performance due to the unnecessary communication overhead to multiple OSTs. A good practice is to make sure small files are written to a directory with a stripe count of 1—effectively, no striping.

More detailed information about efficient use of Lustre and stripes can be found in our `Training <https://www.hpc.kaust.edu.sa/training>`_ slides.


Filesystem Layout
*****************

The ``/scratch`` directory should only be used for temporary data utilised by running jobs, as it is subject to a rigorous purge policy described below. Any files that you need to keep for longer-term use should reside in the ``/project directory``.

Any files created in /project directory will have a copy made to tape within 8 hours of creation by an automatic process utilising HPE DMF.

Please note that as ``/scratch`` is designated as temporary storage, the data is **NOT** copied to tape.


Purge Policies
--------------
   * /scratch/<username> and /scratch/project/<projectname>: files not modified AND not accessed in the last 60 days will be deleted.
   * /scratch/tmp: temporary folder - files not modified AND not accessed in the last 3 days will be deleted.
   * /project/<projectname>: default limit of 80 TB limit per PI, across all of their projects.
   * /scratch/project/<projectname>: default limit of 80 TB limit per PI, across all of their projects.
   * all data in /project/<projectname> and /scratch/project/<projectname> will be deleted permanently 1 month after core hour allocations for the project have expired unless a further application has been submitted for RCAC consideration.

Removing multiple files efficiently

Using the standard Linux command ``rm`` to delete multiple files on a Lustre filesystem is not recommended. Huge numbers of files deleted with the ``rm`` command will be very slow since it will provoke an increased load on the metadata server, resulting in instabilities with the filesystem, and therefore affecting all users.

.. code-block:: default
    :caption: It is recommended to use munlink, an optimised Lustre-specific command, as in the following example:

    find ./my_testrun1 -type f -print0 | xargs -0 munlink
    find ./my_testrun1 -type l -print0 | xargs -0 munlink

* find ./ my_testrun1 -type f: will search files (-type f) in the directory my_testrun1 and all its subdirectories
* | xargs -0 munlink: xargs will then convert the list of files, line by line, into an argument for munlink. The -0 flag is related to the format of the listed files; if you use -print0 with the find command, you must use -0 in the xargs command.

.. code-block:: default
    :caption: Once all of the files are deleted, the directory and its subdirectories can be deleted as follows:

    find ./my_testrun1 -type d -empty -delete
    
|

Quotas
-------
Quota can be monitored with:

.. code-block:: default
    :caption: **User quotas**

    $ kuq
    Disk quotas for user <user> (uid <UID_Number>):
         Filesystem    used   quota   limit   grace   files   quota   limit   grace
            /lustre  14.46M      0k      0k       -     127       0 1000000       -
           /lustre2   8.77M      0k      0k       -     166       0 1000000       -

|

.. code-block:: default
    :caption: **User scratch quota**

    $ ksq
    Scratch disk quotas for <name> (pid <UID_Number>):
    Directory                   used   quota   limit   grace   files   quota   limit   grace
    /scratch/<user>           976k      0k      0k       -      77       0       0       -

|

.. code-block:: default
    :caption: **PI Quota**
    
    $ kpq <PI UID name>|<PI email>|<Project ID>|<PI Number>
    Disk quotas for <PI UID Name> (pid <PI Number>):
         Filesystem    used   quota   limit   grace   files   quota   limit   grace
            /lustre  3.598M      0k     80T       -     558       0       0       -
           /lustre2  2.037T      0k     80T       -   19621       0       0       -

|

.. _accounting_shaheen3:

Job Scheduling
---------------
Queues
********

**workq**: This is the default queue, the maximum wall clock time for jobs is 24 hours. There is also a limit of 800 jobs per user.

**72hours**: There are 512 nodes available in this queue with the maximum wall clock of 72 hours. There is also a limit of 80 jobs per user in this queue. Use of the 72hours queue is restricted to projects that have applied and been approved by the RCAC. To use 72hours queue the following two lines need to be added to the job submission file:

.. code-block:: bash
    
    #SBATCH --partition=72hours
    #SBATCH --qos=72hours

|


**debug**: There are 16 nodes available in this queue with a maximum wall clock of 30 minutes and a maximum job size of 4 nodes. 

.. code-block:: bash 

    #SBATCH --partition=debug

|

Large Memory Nodes
*******************

We have 4 nodes (nid000[32-35]) available with 256 GB of memory, jobs can be queued to these nodes by specifying a larger memory requirement for the job:

.. code-block:: bash 

    #SBATCH --mem=262144

Theses nodes are not available in the 72hours queue.
