.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Utilizing remote filesystems
    :keywords: remote, filesystem, smb

.. _remote_filesystems:

=============================================
Mounting remote filesystems on workstations
=============================================
SMB or ``cifs`` (a dialect of SMB) is a protocol to mount remote filesystems on workstation/laptops.
Access to remote filesystems on Ibex cluster is provided through a Windows share of the filesystems. This is available on the host samba.ibex.kaust.edu.sa. Accessing this is a little different for each client Operating System. As with all Ibex resources, you authenticate with your KAUST portal username and password.

Windows
--------

Open an explorer window and in the URL bar enter ``\\samba.ibex.kaust.edu.sa``. 
After authenticating you should see your ``username``, which is your $HOME and a list of all available shares.

Mac OSX
--------

Select Finder or web browser and enter the URL ``smb://samba.ibex.kaust.edu.sa`` in the address bar. Once authenticated you should see a folder for your ``username``, which is your $HOME, and a list of folders for each available share.

Linux
-------

Most distributions contain a graphical File Browser, usually Nautilus. Open your File Browser of choice and in it's Location text box enter smb://samba.ibex.kaust.edu.sa. Once authenticated you should see a list of shares, including your $HOME directory as a folder with your username. However, some older clients don't handle browsing that well and if this doesn't work, try adding a specific share to the Location, e.g. ``smb://samba.ibex.kaust.edu.sa/<target_filesystem_root_path>``.

A list of all available shares can be obtained with smbclient:

.. code-block:: default
    :caption: Listing SMB clients with smbclient
    
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
