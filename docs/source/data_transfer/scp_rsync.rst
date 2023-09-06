Scp and Rsync
-------------
Command Line Tools for Transferring Data
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are several ways to move data into and out of the storage resources. The following table lists the different commands and methods, how well each can be expected to perform and what type of transfer problem they are appropriate for.

+---------------------+--------------------------------------+----------------------------------+
|Command              |Performance Notes                     |Transfer types                    | 
+=====================+======================================+==================================+
|scp                  |Performs very well, up to line speed  |single files, small directories,  |
|                     |of network if the underlying storage  |anything under 10 GB              |
|                     |is fast enough                        |                                  |
+---------------------+--------------------------------------+----------------------------------+
|rsync                |Performs  well, can take a long       |Any size transfer, but especially |
|                     |time to start with a lot of files.    |useful for large files(--partial) |
|                     |can be manually parallelized by       |and resuming failed transfers of  |
|                     |partitioning data to be transferred   |any size for many files           |
+---------------------+--------------------------------------+----------------------------------+

|

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


