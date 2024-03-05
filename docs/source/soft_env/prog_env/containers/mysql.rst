.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: mysql container example
    :keywords: krccl, container, mysql

.. _mysql_container_example:

=========================================
MySQL container using Singularity on Ibex
=========================================

Overview
========

This is a reproduction of Iowa State University image and according to their instructions. There was a slight quark to allow external mysql client to connect to mysql server on a compute node of Ibex.

Where the image comes from?
===========================

.. code-block:: bash

     singularity pull --name mysql.simg shub://ISU-HPC/mysql


Server launch
=============

Before launching the server, a couple of configuration files need to be created in $HOME directory:

.. code-block:: bash

    -bash-4.2$ cat ~/.my.cnf
    [mysqld]
    innodb_use_native_aio=0
    init-file=${HOME}/.mysqlrootpw
    socket=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/lims/test/mysql/var/lib/mysql/mysql.sock
    [client]
    user=root
    password='ksl'
    socket=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/lims/test/mysql/var/lib/mysql/mysql.sock

and

.. code-block:: bash

    -bash-4.2$ cat ~/.mysqlrootpw
    SET PASSWORD FOR 'root'@'localhost' = PASSWORD('ksl');

Now we are ready to submit the following jobscript on a compute node of Ibex.

.. code-block:: bash

    #SBATCH --ntasks=1
    #SBATCH --time=01:00:00
    #SBATCH --cpus-per-task=1

    module load singularity
    mkdir -p ${PWD}/mysql/var/lib/mysql ${PWD}/mysql/run/mysqld

    singularity instance start --bind ${HOME} --bind ${PWD}/mysql/var/lib/mysql/:/var/lib/mysql --bind ${PWD}/mysql/run/mysqld:/run/mysqld /ibex/scratch/shaima0d/scratch/singularity_mpi_testing/lims/mysql/mysql.simg mysql
    singularity run instance://mysql
    sleep 60

    singularity exec instance://mysql create_remote_admin_user.sh
    echo HOSTNAME=$(hostname)

    sleep 1200

The resulting SLURM output was as follows:

.. code-block:: bash

    -bash-4.2$ cat slurm-11242206.out
    Loading module for Singularity
    Singularity 3.5 modules now loaded
    INFO:    instance started successfully
    /home/shaima0d/.my.cnf already exists.  Using that version.
    /home/shaima0d/.mysqlrootpw already exists.  Using that version.
    Initializing mysqld
    2020-07-15T19:54:39.311440Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
    2020-07-15T19:54:40.917293Z 0 [Warning] InnoDB: New log files created, LSN=45790
    2020-07-15T19:54:41.375875Z 0 [Warning] InnoDB: Creating foreign key constraint system tables.
    2020-07-15T19:54:41.599987Z 0 [Warning] No existing UUID has been found, so we assume that this is the first time that this server has been started. Generating a new UUID: 05cee2a9-c6d5-11ea-a41d-a4bf015cf3b9.
    2020-07-15T19:54:41.757909Z 0 [Warning] Gtid table is not ready to be used. Table 'mysql.gtid_executed' cannot be opened.
    2020-07-15T19:54:41.759890Z 1 [Note] A temporary password is generated for root@localhost: 4ajhqiL-thq&
    2020-07-15T19:55:12.234631Z 1 [Warning] 'user' entry 'root@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:12.234865Z 1 [Warning] 'user' entry 'mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:12.235037Z 1 [Warning] 'user' entry 'mysql.sys@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:12.235508Z 1 [Warning] 'db' entry 'performance_schema mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:12.235664Z 1 [Warning] 'db' entry 'sys mysql.sys@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:12.236001Z 1 [Warning] 'proxies_priv' entry '@ root@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:12.236415Z 1 [Warning] 'tables_priv' entry 'user mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:12.236586Z 1 [Warning] 'tables_priv' entry 'sys_config mysql.sys@localhost' ignored in --skip-name-resolve mode.

    Start mysqld
    2020-07-15T19:55:28.556409Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
    2020-07-15T19:55:28.559310Z 0 [Note] mysqld (mysqld 5.7.21) starting as process 50 ...
    2020-07-15T19:55:28.565300Z 0 [Note] InnoDB: PUNCH HOLE support available
    2020-07-15T19:55:28.565584Z 0 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
    2020-07-15T19:55:28.565941Z 0 [Note] InnoDB: Uses event mutexes
    2020-07-15T19:55:28.566351Z 0 [Note] InnoDB: GCC builtin __atomic_thread_fence() is used for memory barrier
    2020-07-15T19:55:28.566732Z 0 [Note] InnoDB: Compressed tables use zlib 1.2.3
    2020-07-15T19:55:28.567791Z 0 [Note] InnoDB: Number of pools: 1
    2020-07-15T19:55:28.568139Z 0 [Note] InnoDB: Using CPU crc32 instructions
    2020-07-15T19:55:28.570252Z 0 [Note] InnoDB: Initializing buffer pool, total size = 128M, instances = 1, chunk size = 128M
    2020-07-15T19:55:28.579515Z 0 [Note] InnoDB: Completed initialization of buffer pool
    2020-07-15T19:55:28.583538Z 0 [Note] InnoDB: If the mysqld execution user is authorized, page cleaner thread priority can be changed. See the man page of setpriority().
    2020-07-15T19:55:28.606500Z 0 [Note] InnoDB: Highest supported file format is Barracuda.
    2020-07-15T19:55:28.727934Z 0 [Note] InnoDB: Creating shared tablespace for temporary tables
    2020-07-15T19:55:28.728727Z 0 [Note] InnoDB: Setting file './ibtmp1' size to 12 MB. Physically writing the file full; Please wait ...
    2020-07-15T19:55:28.884002Z 0 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
    2020-07-15T19:55:28.886752Z 0 [Note] InnoDB: 96 redo rollback segment(s) found. 96 redo rollback segment(s) are active.
    2020-07-15T19:55:28.887172Z 0 [Note] InnoDB: 32 non-redo rollback segment(s) are active.
    2020-07-15T19:55:28.887905Z 0 [Note] InnoDB: Waiting for purge to start
    2020-07-15T19:55:28.939183Z 0 [Note] InnoDB: 5.7.21 started; log sequence number 2555363
    2020-07-15T19:55:28.940467Z 0 [Note] Plugin 'FEDERATED' is disabled.
    2020-07-15T19:55:28.956609Z 0 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
    2020-07-15T19:55:28.961057Z 0 [Warning] Failed to set up SSL because of the following SSL library error: SSL context is not usable without certificate and private key
    2020-07-15T19:55:28.965105Z 0 [Note] Server hostname (bind-address): '*'; port: 3306
    2020-07-15T19:55:28.965925Z 0 [Note] IPv6 is available.
    2020-07-15T19:55:28.966556Z 0 [Note]   - '::' resolves to '::';
    2020-07-15T19:55:28.967693Z 0 [Note] Server socket created on IP: '::'.
    2020-07-15T19:55:28.972582Z 0 [Note] InnoDB: Buffer pool(s) load completed at 200715 22:55:28
    2020-07-15T19:55:29.162982Z 0 [Warning] 'user' entry 'root@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:29.163207Z 0 [Warning] 'user' entry 'mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:29.163383Z 0 [Warning] 'user' entry 'mysql.sys@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:29.163748Z 0 [Warning] 'db' entry 'performance_schema mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:29.163913Z 0 [Warning] 'db' entry 'sys mysql.sys@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:29.164240Z 0 [Warning] 'proxies_priv' entry '@ root@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:29.181513Z 0 [Warning] 'tables_priv' entry 'user mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:29.181705Z 0 [Warning] 'tables_priv' entry 'sys_config mysql.sys@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:55:29.251106Z 0 [Note] Event Scheduler: Loaded 0 events
    2020-07-15T19:55:29.251419Z 0 [Note] Execution of init_file '/home/shaima0d/.mysqlrootpw' started.
    2020-07-15T19:55:29.254954Z 0 [Note] Execution of init_file '/home/shaima0d/.mysqlrootpw' ended.
    2020-07-15T19:55:29.255239Z 0 [Note] mysqld: ready for connections.
    Version: '5.7.21'  socket: '/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/lims/test/mysql/var/lib/mysql/mysql.sock'  port: 3306  MySQL Community Server (GPL)
    2020-07-15T19:56:28.535225Z 4 [Warning] 'user' entry 'root@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:56:28.535454Z 4 [Warning] 'user' entry 'mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:56:28.535623Z 4 [Warning] 'user' entry 'mysql.sys@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:56:28.535942Z 4 [Warning] 'db' entry 'performance_schema mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:56:28.536089Z 4 [Warning] 'db' entry 'sys mysql.sys@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:56:28.536383Z 4 [Warning] 'proxies_priv' entry '@ root@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:56:28.541828Z 4 [Warning] 'tables_priv' entry 'user mysql.session@localhost' ignored in --skip-name-resolve mode.
    2020-07-15T19:56:28.542069Z 4 [Warning] 'tables_priv' entry 'sys_config mysql.sys@localhost' ignored in --skip-name-resolve mode.

        Random password for remote user 'remote_usr': lBS7hOFT
        
    HOSTNAME=cn512-15-l


Client tests
============

The two clients tested were running a mysql client on a different host:

Test 1: mysql client in a container on a different host
-------------------------------------------------------

.. code-block:: bash

    -bash-4.2$ module load singularity
    Loading module for Singularity
    Singularity 3.5 modules now loaded
    -bash-4.2$ singularity shell mysql/mysql.simg
    Singularity> mysql --version
    mysql  Ver 14.14 Distrib 5.7.21, for Linux (x86_64) using  EditLine wrapper
    Singularity> mysql -h cn512-15-l.ibex.kaust.edu.sa -u remote_usr -plBS7hOFT
    mysql: [Warning] Using a password on the command line interface can be insecure.
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 6
    Server version: 5.7.21 MySQL Community Server (GPL)

    Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql>


Test 2: mysql client on a remote workstation (my laptop)
--------------------------------------------------------

.. code-block:: bash

    [10:45 PM, 7/15/2020] Mohsin Ahmed Shaikh: $ mysql --version
    mysql  Ver 8.0.19 for osx10.13 on x86_64 (Homebrew)
    [10:46 PM, 7/15/2020] Mohsin Ahmed Shaikh: (base) kw-17241:dl shaima0d$ mysql -h cn512-15-l.ibex.kaust.edu.sa -u remote_usr -plBS7hOFT
    mysql: [Warning] Using a password on the command line interface can be insecure.
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 6
    Server version: 5.7.21 MySQL Community Server (GPL)

    Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

    Oracle is a registered trademark of Oracle Corporation and/or its
    affiliates. Other names may be trademarks of their respective
    owners.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

    mysql>


