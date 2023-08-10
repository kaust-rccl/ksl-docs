Storage Tour
============

**$HOME**


.. code-block:: default
    :caption: Upon login the current working directory (cwd) of the session is the $HOME directory. The full path is /home/$USER where $USER == your KAUST Portal Username. Have a look at what is in the $HOME directory with the ls command, ssh to a login host and try it:

    [username@kw60011 ~]$ ssh username@ilogin.ibex.kaust.edu.sa
    username@ilogin.ibex.kaust.edu.sa's password: 
    Last login: Wed Sep 24 10:44:46 2014 from 10.75.106.36
    [username@loginhost:~]$ ls
    [username@loginhost:~]$ 

|

.. code-block:: bash
    :caption: It looks empty, but it's not really empty. Unix/Linux operating systems have a convention for "hidden" files. Any file whose name begins with "." does not show up in the directory listing by default. These files can be viewed with the -a flag to ls, for example in a newly created $HOME there are these files:

    [username@loginhost:~]$ ls -a
    .   .bash_history  .bash_profile  .emacs       .gnome2   .slurm  .subversion  .vimrc       .zshrc
    ..  .bash_logout   .bashrc        .fontconfig  .mozilla  .ssh    .viminfo     .Xauthority
    [username@loginhost:~]$

|

.. code-block:: bash
    :caption: Just knowing the names identifies what is here, but not the size of each item or the difference between files and directories. Adding -l to the ls command gives the "long" display:

    [username@loginhost:~]$ ls -al
    total 255
    drwx------  8 username g-username   17 Sep 24 11:01 .
    drwxr-xr-x 11 root   root         11 Sep 23 15:02 ..
    -rw-------  1 username g-username   1033 Sep 24 11:01 .bash_history
    -rw-------  1 username g-username     18 Sep 16 15:33 .bash_logout
    -rw-------  1 username g-username    176 Sep 16 15:33 .bash_profile
    -rw-------  1 username g-username    413 Sep 16 21:43 .bashrc
    -rw-------  1 username g-username    500 Sep 16 15:33 .emacs
    drwxr-xr-x  2 username g-username      8 Sep 16 16:19 .fontconfig
    drwx------  2 username g-username      2 Sep 16 15:33 .gnome2
    drwx------  4 username g-username      4 Sep 16 15:33 .mozilla
    drwxr-x---  2 username g-username      3 Sep 16 16:20 .slurm
    drwx------  2 username g-username      7 Sep 22 09:01 .ssh
    drwx------  3 username g-username      6 Sep 16 15:33 .subversion
    -rw-------  1 username g-username   2046 Sep 18 22:30 .viminfo
    -rw-------  1 username g-username   2780 Sep 16 20:34 .vimrc
    -rw-------  1 username g-username    627 Sep 24 11:01 .Xauthority
    -rw-------  1 username g-username    658 Sep 16 15:33 .zshrc

|

In that output we see the total number of blocks (255) followed by columns for:

#. Permissions and type. The leading "d" indicates a directory. r == read, w == write and x == execute. Directories aren't executable, so when a directory has the x set it means permission to list files within the directory.
#. owner. In this case, me: username
#. group owner. The group the file belongs to, for me this is my default primary group "g-username".
#. size (bytes). The size of the file in bytes. Adding -h will convert these to kmgt as appropriate to make size more readable.
#. last modified date. The date and time the file was last modified.
#. name. Name of the file, directory or symlink.

Some other useful file and directory related commands are:

.. hlist::
   :columns: 1
   
   * cd - change working directory
   * pwd - display working directory
   * rm - remove a file, or files and directories recursively with -r
   * rmdir - remove an empty directory
   * mkdir - create a new directory
   * chmod - change the permissions on a file or directory.
   * ln - create a soft or hard link to a file or directory.


Try man cmdname for each command to get a full description of what it does.

A full explanation of Unix/Linux file and directory permissions is beyond the scope of this tutorial. For more detail see `Wikipedia: File System Permissions <https://en.wikipedia.org/wiki/File-system_permissions>`_  

Local Node Scratch Directories
------------------------------

.. code-block:: bash
    :caption: Each compute node will have mounted a directory at /local/scratch. This space can be used for smaller temp files. The amount of space per node varies, so it's important to check available space before using it. Let's grab a command from later in the tutorial, submit an interactive job request and have a look at a nodes local scratch space:
    
    # Get an interactive session on a compute node.
    [username@loginhost:~]$ srun --pty --time=10:00 --mem=8G --nodes=1 --ntasks-per-node=1 bash -l

    # Change directory 
    [username@computenode:~]$ cd /local/scratch

    # What is here?
    [username@computenode:scratch]$ ls -al
    total 0
    drwxrwxrwt 2 root root 40 Sep 16 13:45 .
    drwxr-xr-x 3 root root 60 Sep 16 13:45 ..
 
    # How large is this volume?
    [username@computenode:scratch]$ df -h /local/scratch
    Filesystem      Size  Used Avail Use% Mounted on
    tmpfs          1017G     0 1017G   0% /local/scratch

    # Exit the interactive job session.
    [username@computenode:scratch]$ exit
    logout
    [username@loginhost:~]$ 

In this example the the node has approximately 1 TB of local scratch space available. Please handle cleaning up your temp files in the job script and don't count on files left in the local scratch spaces to remain there as they may be removed at any future point when a files owner does not have a job running on the node.