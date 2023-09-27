
==========================
Data transfer utilities
==========================

On this page, you will find a collection of tools which can be used to effectively move data:

* between filesystems of a KSL system
* between filesystems of two different KSL systems
* between KSL system and outside world (including your workstation)


Command Line Tools for Transferring Data
=========================================

There are several ways to move data into and out of the storage resources. The following table lists the different commands and methods, how well each can be expected to perform and what type of transfer problem they are appropriate for.

.. list-table:: 
   :widths: 20 50 50
   :header-rows: 1

   * - Command
     - Performance notes
     - Transfer type
   * - ``scp``
     - Performs very well, up to the line speed of the network if the underlying storage is fast enough
     - single files, small directories, anything under 10GB
   * - ``sftp``
     - Performs very well, up to the line speed of the network if the underlying storage is fast enough
     - single files, small directories, anything under 10GB
   * - ``rsync``
     - Performs very well, can take long time to start with a lot of files. Can be parallelized by partitioning data to be transferred to speed up on high latency networks. 
     - Any size transfer, but especially useful for large files (``--partial``) and resuming failed transfers of any size for many files
   * - ``lftp``
     - Performs well, has builtin parallel transfers to help speed up on high latency networks.
     - any size transfer, but must be run from login nodes as the compute nodes have no ftp server installed

Examples 
========
.. code-block:: default
    :caption: **scp examples**

    # Single File.
    [username@myclient ~]$scp Downloads/VirtualGL-2.5.tar.gz username@ilogin.ibex.kaust.edu.sa:/ibex/scratch/username/
    username@ilogin.ibex.kaust.edu.sa's password: 
    VirtualGL-2.5.tar.gz                                                                              100% 1168KB   1.1MB/s   00:00    

    # Directory of files.
    [username@myclient ~]$scp -r CopyMeDir username@ilogin.ibex.kaust.edu.sa:/ibex/scratch/username/
    username@ilogin.ibex.kaust.edu.sa's password: 
    myfile_j.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_m.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_c.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_d.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_x.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_v.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_q.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_p.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_w.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_y.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_e.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_b.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_l.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_k.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_t.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_s.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_z.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_a.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_f.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_h.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_o.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_n.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_i.bin                                                                                      100% 8192KB   8.0MB/s   00:01    
    myfile_g.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_r.bin                                                                                      100% 8192KB   8.0MB/s   00:00    
    myfile_u.bin                                                                                      100% 8192KB   8.0MB/s   00:00 
    
|

.. code-block:: default
    :caption: **sftp examples**

    [username@myclient ~]$sftp username@ilogin.ibex.kaust.edu.sa
    Connected to ilogin.ibex.kaust.edu.sa.

    # List remote files:
    sftp> ls
    Applications      Data_Dragon       Data_SnapDragon   Desktop           Documents         Downloads         Music             
    Pictures          Projects          Public            Templates         Videos            Working           bin               
    rpmbuild          

    # List local files:
    sftp> lls
    Applications  Desktop	 Downloads  MachineImages  matlab  Music  Pictures  Public    Templates  Working
    CopyMeDir     Documents  Go	    Manuals	   Media   perl5  Projects  rpmbuild  Videos

    # List remote directory:
    sftp> ls bin
    bin/mkmodule.sh   bin/sutilization  

    # Get file from remote directory:
    sftp> get bin/sutilization
    Fetching /home/username/bin/sutilization to sutilization
    /home/username/bin/sutilization                                                                     100% 1065     1.0KB/s   00:00    

    # Put file back in different location:
    sftp> put sutilization 
    Uploading sutilization to /home/username/sutilization
    sutilization                                                                                      100% 1065     1.0KB/s   00:00    
    sftp> ls
    Applications      Data_Dragon       Data_SnapDragon   Desktop           Documents         Downloads         Music             
    Pictures          Projects          Public            Templates         Videos            Working           bin               
    rpmbuild          sutilization      # See help:
    sftp> help
    Available commands:
    bye                                Quit sftp
    cd path                            Change remote directory to 'path'
    chgrp grp path                     Change group of file 'path' to 'grp'
    chmod mode path                    Change permissions of file 'path' to 'mode'
    ...

|

.. code-block:: bash
    :caption: **rsync examples**

    # Copy a file to a remote host:
    rsync localfile USER@HOSTNAME:/path/to/destination

    # Copy a directory, including the directory name, to a remote host,
    # this will create the remote directory /path/to/destination/localdir 
    # and place a copy of it's contents there.
    rsync -a /path/to/localdir USER@HOSTNAME:/path/to/destination

    # Copy only the contents of a directory. Note the trailing / in the source 
    # path. Everything under /path/to/localdir/ will be copied to 
    # /path/to/destination on the remote host.
    rsync -a /path/to/localdir/ USER@HOSTNAME:/path/to/destination

    # See progress:
    rsync -av --progress /path/to/localdir/ USER@HOSTNAME:/path/to/destination

    # Keep partial transfers, useful for very large files over poor connections.
    rsync -av --progress --partial verylargefile USER@HOSTNAME:/path/to/destination

    # Make or update a remote location to be an exact copy of the source:
    rsync -av --progress --delete /path/to/localdir/ USER@HOSTNAME:/path/to/destination

    # Same as above, but just tell me what rsync will do so I can see what 
    # will be deleted:
    rsync -anv --progress --delete /path/to/localdir/ USER@HOSTNAME:/path/to/destination


If a transfer fails, simply restarting it will have rsync check what has already been copied, refresh anything that is newer on the source and then finish transferring any remaining files.

Distributed Copy
=================

Sometimes it is needed to copy large number of files from ``/scratch`` to ``/project`` or vice versa. Both ``cp`` and ``rsync`` are convenient but sometimes you need speed to do such task and move large amount of data.

``dcp`` or distributed copy is a MPI-based copy tool developed by Lawrance Livermore National Lab (LLNL) as part of their ``mpifileutils`` suite. We have installed it on Shaheen. Here is an example jobscript to launch a data moving job with ``dcp``:

.. code-block:: bash

     #!/bin/bash

     #SBATCH --ntasks=4
     #SBATCH --time=01:00:00
     #SBATCH --hint=nomultithread
     
     module load mpifileutils
     time srun -n ${SLURM_NTASKS} dcp --verbose --progress 60 --preserve /path/to/source/directory /path/to/destination/directory

The above script launches ``dcp`` in parallel on with 4 MPI processes. ``--progress 60`` implies that the progress of the operation will be reported every 60 seconds.  ``--preserve`` implies that the ACL permissions, group ownership, timestamps and extended attributes will be preserved on the files the destination directory as were in parent/source directory.

The following is an example output:

.. code-block:: 

    [2021-01-21T16:01:51] Preserving file attributes.
    [2021-01-21T16:01:51] Walking /project/##/########/PinatuboInitialStage
    [2021-01-21T16:01:51] Walking /project/##/########/README.txt
    [2021-01-21T16:01:51] Walking /project/##/########/build_alex.slurm
    [2021-01-21T16:01:51] Walking /project/##/########/build_alex2.slurm
    [2021-01-21T16:01:51] Walking /project/##/########/build_own.slurm
    [2021-01-21T16:01:51] Walking /project/##/########/kuwait_heavy.slurm
    [2021-01-21T16:01:51] Walking /project/##/########/minmax.ncl
    [2021-01-21T16:01:51] Walking /project/##/########/nasaballon.slurm
    [2021-01-21T16:01:51] Walking /project/##/########/run_wrf_371_kuwait_heavy.sh
    [2021-01-21T16:01:51] Walking /project/##/########/run_wrf_371_nasaballoon_light.sh
    [2021-01-21T16:01:51] Walking /project/##/########/slurm-17933845.out
    [2021-01-21T16:01:51] Walking /project/##/########/slurm-17933846.out
    [2021-01-21T16:01:51] Walking /project/##/########/slurm-17933847.out
    [2021-01-21T16:01:51] Walking /project/##/########/slurm-17933848.out
    [2021-01-21T16:01:51] Walking /project/##/########/slurm-17934624.out
    [2021-01-21T16:01:51] Walking /project/##/########/submit_script.sh
    [2021-01-21T16:01:52] Walked 7844 items in 0.595307 secs (13176.397504 items/sec) ...
    [2021-01-21T16:01:52] Walked 7844 items in 0.595524 seconds (13171.591813 items/sec)
    [2021-01-21T16:01:52] Copying to /scratch/########/my_destination_dir
    [2021-01-21T16:01:52] Items: 7844
    [2021-01-21T16:01:52]   Directories: 189
    [2021-01-21T16:01:52]   Files: 7247
    [2021-01-21T16:01:52]   Links: 408
    [2021-01-21T16:01:52] Data: 531.085 GB (75.042 MB per file)
    [2021-01-21T16:01:52] Creating directories.
    [2021-01-21T16:01:52]   level=6 min=0 max=1 sum=1 rate=272.853500/sec secs=0.003665
    [2021-01-21T16:01:52]   level=7 min=0 max=5 sum=19 rate=515.727600/sec secs=0.036841
    [2021-01-21T16:01:52]   level=8 min=0 max=10 sum=59 rate=541.667256/sec secs=0.108923
    [2021-01-21T16:01:52]   level=9 min=1 max=6 sum=33 rate=556.079307/sec secs=0.059344
    [2021-01-21T16:01:52]   level=10 min=0 max=19 sum=60 rate=521.802914/sec secs=0.114986
    [2021-01-21T16:01:52]   level=11 min=0 max=6 sum=12 rate=542.864132/sec secs=0.022105
    [2021-01-21T16:01:52]   level=12 min=0 max=2 sum=4 rate=555.776195/sec secs=0.007197
    [2021-01-21T16:01:52]   level=13 min=0 max=1 sum=1 rate=515.207468/sec secs=0.001941
    [2021-01-21T16:01:52]   level=14 min=0 max=0 sum=0 rate=0.000000/sec secs=0.000001
    [2021-01-21T16:01:52] Created 189 directories in 0.355161 seconds (532.153096 items/sec)
    [2021-01-21T16:01:52] Creating files.
    [2021-01-21T16:01:52]   level=6 min=0 max=6 sum=15 rate=460.022813 secs=0.032607
    [2021-01-21T16:01:52]   level=7 min=0 max=7 sum=25 rate=471.742915 secs=0.052995
    [2021-01-21T16:02:01]   level=8 min=141 max=540 sum=3995 rate=434.750857 secs=9.189171
    [2021-01-21T16:02:03]   level=9 min=1 max=155 sum=516 rate=452.639110 secs=1.139981
    [2021-01-21T16:02:07]   level=10 min=4 max=382 sum=1763 rate=435.794907 secs=4.045481
    [2021-01-21T16:02:09]   level=11 min=0 max=260 sum=1039 rate=449.518504 secs=2.311362
    [2021-01-21T16:02:10]   level=12 min=9 max=66 sum=249 rate=362.368935 secs=0.687145
    [2021-01-21T16:02:10]   level=13 min=0 max=38 sum=47 rate=416.477838 secs=0.112851
    [2021-01-21T16:02:10]   level=14 min=0 max=4 sum=6 rate=392.927444 secs=0.015270
    [2021-01-21T16:02:10] Created 7655 items in 17.587330 seconds (435.256520 items/sec)
    [2021-01-21T16:02:10] Copying data.
    [2021-01-21T16:03:10] Copied 102.215 GB in 60.072 secs (1.702 GB/s) ...
    [2021-01-21T16:04:10] Copied 202.647 GB in 120.113 secs (1.687 GB/s) ...
    [2021-01-21T16:05:10] Copied 302.142 GB in 180.145 secs (1.677 GB/s) ...
    [2021-01-21T16:06:10] Copied 402.684 GB in 240.246 secs (1.676 GB/s) ...
    [2021-01-21T16:07:51] Copied 499.097 GB in 341.481 secs (1.462 GB/s) ...
    [2021-01-21T16:07:51] Copied 531.085 GB in 341.482 secs (1.555 GB/s) done
    [2021-01-21T16:07:51] Copy data: 531.085 GB (570247967642 bytes)
    [2021-01-21T16:07:51] Copy rate: 1.555 GB/s (570247967642 bytes in 341.481616 seconds)
    [2021-01-21T16:07:51] Syncing data to disk.
    [2021-01-21T16:07:52] Sync completed in 0.716662 seconds.
    [2021-01-21T16:07:52] Setting ownership, permissions, and timestamps.
    [2021-01-21T16:08:04] Updated 7844 items in 12.315612 seconds (636.915157 items/sec)
    [2021-01-21T16:08:04] Syncing directory updates to disk.
    [2021-01-21T16:08:04] Sync completed in 0.055182 seconds.
    [2021-01-21T16:08:04] Started: Jan-21-2021,16:01:52
    [2021-01-21T16:08:04] Completed: Jan-21-2021,16:08:04
    [2021-01-21T16:08:04] Seconds: 372.536
    [2021-01-21T16:08:04] Items: 7844
    [2021-01-21T16:08:04]   Directories: 189
    [2021-01-21T16:08:04]   Files: 7247
    [2021-01-21T16:08:04]   Links: 408
    [2021-01-21T16:08:04] Data: 531.085 GB (570247967642 bytes)
    [2021-01-21T16:08:04] Rate: 1.426 GB/s (570247967642 bytes in 372.536 seconds)

Benchmark
----------

As a benchmark, lets try copying 37760 CSV files each of 6.5kB (a total of 241.085 MB). 

The table below compares the baseline time taken by cp command to copy these files from /project to /scratch with that taken by dcp with different number of MPI processes:

.. list-table:: 
   :widths: 30 30 30 30
   :header-rows: 1

   * - Tool
     - MPI processes
     - Time (sec)
     - Speedup  
   * - ``cp``
     - 1 (serial)
     - 1139.75
     - 1
   * - ``dcp``
     - 4
     - 888.97
     - 1.282
   * - ``dcp``
     - 16
     - 226.07
     - 5.042
   * - ``dcp``
     - 32
     - 401.48
     - 2.83
 
Some observations
-----------------

Given large enough number of files, you can see decent gains in using dcp. Use >1 Lustre strip when writing big files. This will increase throughput on each file since dcp does not decompose the files into blocks itself. 

Throwing more MPI processes may not always give you the more speedup, as seen in the case of 32 vs 16 MPI processes in the table above. Significantly less work (i.e. files to copy) per MPI process can introduce the MPI overhead of synchronizing and slows down the whole job. Thus there is a sweet spot. 

It is possible to have variability in time give the time when your copy job runs and the load on the metadata server of Lustre filesystem.