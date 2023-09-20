.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Shared parallel filesystems on Ibex
    :keywords: WekaIO, home, parallel filesystem, Ibex
    
.. _ibex_filesystems:

==============
Filesystems
==============

Ibex mounts shared scratch and /home filesystems on which each user has corresponding account-specific directories. Each file system is available from all Ibex login nodes and compute nodes. Additionally, Ibex compute nodes mount local /scratch filesystems.

/home filesystem is currently accessed using NFS.

Please read carefully this section to know about the policy of usage of each of these filesystems.

If in doubt, please contact us.

.. toctree::
   :maxdepth: 1
   :titlesonly:
   
   home
   scratch_fscratch_projects
   wekaIO_FS
   storage_tour
   storage_transferring_and_managing_data
   compressing_data 



