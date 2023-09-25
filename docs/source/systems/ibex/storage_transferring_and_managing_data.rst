Storage: Transferring and Managing Data
=======================================

Mounting Directories with smb/cifs (Samba)

Access to most storage is provided via a Windows share of the filesystems. This is available on the host samba.ibex.kaust.edu.sa. Accessing this is a little different for each client Operating System. As with all Ibex resources, you authenticate with your KAUST portal username and password.

**Windows**

Open an explorer window and in the URL bar put \\samba.ibex.kaust.edu.sa. After authenticating you should see your username, which is your $HOME and a list of all available shares.

**Mac OS X**

Select Finder and either press ⌘-K or from teh menu navigate to Connect to server. In the dialog enter smb://samba.ibex.kaust.edu.sa as the URL. Once authenticated you should see a folder for your username, which is your $HOME, and a list of folders for each available share.

**Linux**

Most distributions contain a graphical File Browser, usually Nautilus. Open your File Browser of choice and in it's Location text box enter smb://samba.ibex.kaust.edu.sa. Once authenticated you shoudl see a list of shares, including your $HOME directory as a folder with your username. However, some older clients don't handle browsing that well and if this doesn't work, try adding a specific share to the Location, e.g. smb://samba.ibex.kaust.edu.sa/fscratch.


.. code-block:: default
    :caption: **A list of all available shares can be obtained with smbclient:**
    
    [username@kw60173 ~]$smbclient -L samba.ibex.kaust.edu.sa 
    Enter username's password: 
    Domain=[KAUST] OS=[Windows 6.1] Server=[Samba 4.4.4]
	Sharename       Type      Comment
	---------       ----      -------
	projects_snapdragon Disk      Snapdragon Project Directories
	data_snapdragon Disk      Snapdragon User Data Directories
	labs_snapdragon Disk      Snapdragon Lab Directories
	reference       Disk      Reference Data and Mirrors
	sequence        Disk      BCL Customer Sequence Data
	biocorelab      Disk      BCL Storage
	scratch_dragon_intel Disk      Dragon Intel Scratch Storage
	ibex_scratch    Disk      Beegfs Scratch Storage
	ibex_reference  Disk      Beegfs Reference Storage
	ibex_fscratch   Disk      Beegfs FScratch Storage
	IPC$            IPC       IPC Service (Dragon Storage Gateway)


	Server               Comment
	---------            -------
	SAMBA                Dragon Storage Gateway
	STORAGE610_14        Ibex STORAGE610_14 Samba Server

	Workgroup            Master
	---------            -------
	KAUST                STORAGE610_14


Command Line Tools for Transferring Data
----------------------------------------

There are several ways to move data into and out of the storage resources. The following table lists the different commands and methods, how well each can be expected to perform and what type of transfer problem they are appropriate for.


.. image:: ../static/storage.png
  :width: 10000
  :alt: Alternative text

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