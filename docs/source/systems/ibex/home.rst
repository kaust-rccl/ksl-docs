/home
----- 
**Available /home Storage**

**Introduction**

Upon login the current working directory of the session is the $HOME directory. The full path is /home/$USER, where $USER is your KAUST Portal Username (also known as login).

Home directories will be mounted automatically upon the first access to Ibex. Since each mount makes use of the compute node resources, automounting allows removal of unused mounts to free up those resources when the filesystems are no longer needed. This is particularly useful on compute nodes which over the course of time will mount many filesystems owned by many users and groups.

Due to the automounting of filesystems, you might not see one of your directories immediately. Your directories might take a second or two to show up because the automounting has not finished yet.

Home directories are shared with Shaheen II supercomputer so all your data stored on /home will be accessible from both Shaheen II and Ibex.

The physical system on which the /home directories are stored is a NetApp Cluster On Tap storage system.

**Policies**

**Each $HOME directory is subject to a hard quota limit of 200GB;** if you hit your quota, then you must start either deleting unrequired files or moving them to a different storage space

Home directories are not stored on a high-performance file-system and, as such, they are not intended to be written to by compute jobs. **Use of a home directory during a high-performance or parallel compute job may negatively affect the environment for all users. System administrators will be quick to kill jobs that are running on /home.**

The NetApp storage system which stores the /home directories has been designed for redundancy and high availability. This guarantees data will be protected at all times. Home directories are also regularly backed up.

Home directories are intended for the use of their owner only; **sharing the contents of home directories with other users is strongly discouraged.**

User home directories are provided by NFS and are not purged.

Home directories should be used to build/compile source code and store important files such as results.


