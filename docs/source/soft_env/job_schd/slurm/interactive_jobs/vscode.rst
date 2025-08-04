.. sectionauthor:: Rana Selim <rana.selim@kaust.edu.sa>
.. meta::
    :description: Code-Server guide
    :keywords: codeserver, vscode

.. _vscode:

=========
VScode 
=========
code-server is an opensource alternative to running VS code on a remote machine. The server instantiates on a remote host and the client can run in a browser. It is recomended to create a conda environment for codeserver installation. 



Running code-server on Shaheen III
===================================
It is recommended to create a conda environment with code-server installed as a package:

.. code-block:: bash

    source ${MY_SW}/miniconda3-amd64/bin/activate
    mamba create -c conda-forge -p ${MY_SW}/envs/code-server code-server 
    conda activate ${MY_SW}/envs/code-server
    mamba install -c conda-forge -y python=3.9

Start a remote instance of code-server on compute node of Shaheen III and connect to it. This is best done as a SLURM job and connect to it via your browser. 


.. code-block:: bash

    #!/bin/bash
    #SBATCH --cpus-per-task=192
    #SBATCH --time=00:10:00
    #SBATCH --partition=ppn

    source ${MY_SW}/miniconda3-amd64/bin/activate ${MY_SW}/envs/code-server


    export CODE_SERVER_CONFIG=${SCRATCH_IOPS}/config
    export XDG_CONFIG_HOME=${SCRATCH}/.cache
    export EXTENSIONS_DIR=${SCRATCH_IOPS}/.code/extensions
    export CODE_DATADIR=${SCRATCH_IOPS}/.code/data
    mkdir -p ${EXTENSIONS_DIR} ${CODE_DATADIR}

    node=$(/bin/hostname -s)
    port=$(python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    user=$(whoami)
    submit_host=${SLURM_SUBMIT_HOST}

    if [ -f "${CODE_SERVER_CONFIG}" ] ; then
    rm ${CODE_SERVER_CONFIG}
    fi

    echo "bind-addr: ${node}:${port}" >> ${CODE_SERVER_CONFIG}
    echo "auth: password" >> ${CODE_SERVER_CONFIG}
    echo "password: 10DowningStreet" >> ${CODE_SERVER_CONFIG}
    echo "cert: false" >> ${CODE_SERVER_CONFIG}

    echo "Copy the following line in a new terminal one after another to create a secure SSH tunnel between your computer and Shaheen compute node."
    echo "ssh  -L ${port}:${node}:${port} ${user}@${submit_host}.hpc.kaust.edu.sa"


    code-server --auth=password --user-data-dir=${CODE_DATADIR} --extensions-dir=${EXTENSIONS_DIR} --verbose


Once the job starts, please open the SLURM output file ``slurm-#####.out``. A sample output is shown below:

.. code-block:: bash
    
    > cat slurm-242941.out

    Copy the following line in a new terminal one after another to create a secure SSH tunnel between your computer and Shaheen compute node.
    ssh  -L 58629:dtn1:58629 <username>@login1.hpc.kaust.edu.sa
    [2024-04-14T15:56:34.142Z] debug parent:360 spawned child process 378
    [2024-04-14T15:56:36.025Z] debug child:378 initiating handshake
    [2024-04-14T15:56:36.030Z] debug parent:360 got message {"message":{"type":"handshake"}}
    .....
    [2024-04-14T15:56:36.063Z] info  Using config file /scratch/<username>/iops/config
    [2024-04-14T15:56:36.063Z] info  HTTP server listening on http://10.148.18.60:58629/
    [2024-04-14T15:56:36.063Z] info    - Authentication is enabled
    [2024-04-14T15:56:36.064Z] info      - Using password from /scratch/<username>/iops/config
    [2024-04-14T15:56:36.064Z] info    - Not serving HTTPS
    [2024-04-14T15:56:36.064Z] info  Session server listening on /scratch/<username>/iops/.code/data/code-server-ipc.sock


Copy the ``ssh -L ...`` command, paste it in a new ssh terminal. This is to create a ssh tunnel so that your local browser can connect to the remote code-server using http protocol.

As a last step, type ``localhost:<port>`` where the port number is given in the slurm out and can also be noted from the ssh tunnel command.

Upon successful connection, your browser shall show code-server's User Interface, which is very similar to Microsoft Visual Code.
The UI will first ask for a password for authentication. This can be found in the file ``${SCRATCH_IOPS}/config``. The password is case sensitive. If unchanged, the future session will reuse the cached password, until you choose to change it in the jobscript.

.. important:: 
    It is mandatory to ``scancel`` the job to terminate the remote server. Merely closing your browser won't close the compute node allocated to your job and will be charged until the wall time reaches, and job terminates. 


Running code-server on Ibex
============================

The following has been tested on Ibex’s GPUs node and client in Google Chrome on local workstation. 

Please login to ``<username>@vscode.ibex.kaust.edu.sa`` for the steps below. This will take you to a login node dedicate for VSCode users.

This login node is useful if you only want to access the Ibex filesystem and connect it to your local VSCode installation via Remote SSH extension.

If you want to run compute while developing in an VSCode, ``code-server``, an opensource alternative to MS VSCode is recommended.

code-server can be installed as a conda environment. 

.. code-block:: bash

    source /ibex/user/${USER}/miniconda3/bin/activate
    mamba create -c conda-forge -p code-server 
    conda activate code-server
    mamba install -c conda-forge -y python=3.9 code-server

Interactive allocate a node with e.g. GPU on Ibex (assuming you are on ``vscode.ibex.kaust.edu.sa`` node):

.. code-block:: bash 

    srun --gpus=1 --time=01:00:00 --pty bash
    echo $(/bin/hostname)

Note the hostname of the node your job has been allocated. E.g. in this case I have been allocated ``dgpu501-22``

Edit ``~/.config/code-server/config.yaml`` to set a password of your choice and the port on host machine to bind to. For example, I do the following:

.. code-block:: bash 

   bind-addr: dgpu501-22:10121
   auth: password
   password: 7days7nights
   cert: false

The above password will be needed to login to the client session.

Start code-server:

.. code-block:: bash 
    
    conda activate code-server
    code-server --auth=password --verbose

This will start the server within your GPU enabled interactive job. The output will look as follows:

.. code-block:: bash 

    [2022-04-18T12:47:40.598Z] trace child:103311 got message {"message":{"type":"handshake","args":{"bind-addr":"127.0.0.1:10121","auth":"password","password":"7days7nights","config":"/home/username/.config/code-server/config.yaml","verbose":true,"extensions-dir":"/home/username/miniconda3/envs/code-server/share/code-server/extensions","user-data-dir":"/home/username/.local/share/code-server","log":"trace","host":"127.0.0.1","port":10121,"proxy-domain":[],"_":[],"usingEnvPassword":false,"usingEnvHashedPassword":false}}}
    [2022-04-18T12:47:40.602Z] info  code-server 4.2.0 693b1fac04524bb0e0cfbb93afc85702263329bb
    [2022-04-18T12:47:40.602Z] info  Using user-data-dir ~/.local/share/code-server
    [2022-04-18T12:47:40.602Z] trace Using extensions-dir ~/miniconda3/envs/code-server/share/code-server/extensions
    [2022-04-18T12:47:40.628Z] info  Using config file ~/.config/code-server/config.yaml
    [2022-04-18T12:47:40.628Z] info  HTTP server listening on http://10.109.57.127:10121/ 
    [2022-04-18T12:47:40.628Z] info    - Authentication is enabled
    [2022-04-18T12:47:40.628Z] info    - Using password from ~/.config/code-server/config.yaml
    [2022-04-18T12:47:40.628Z] info    - Not serving HTTPS 

Batch job
^^^^^^^^^
Modify the following jobscript according to your parameters:

.. code-block:: bash 

    #!/bin/bash

    #SBATCH --time=00:10:00
    #SBATCH --gpus=1

    source /ibex/user/${USER}/miniconda3/bin/activate code-server


    export CODE_SERVER_CONFIG=~/.config/code-server/config.yaml
    export XDG_CONFIG_HOME=$HOME/tmpdir
    export CODE_SERVER_EXTENSIONS=/ibex/user/$USER/code-server/extensions
    mkdir -p $CODE_SERVER_EXTENSIONS
    node=$(/bin/hostname)
    port=$(python3 -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    user=$(whoami) 
    submit_host=${SLURM_SUBMIT_HOST} 

    if [ -f ${CODE_SERVER_CONFIG} ] ; then
    rm ${CODE_SERVER_CONFIG}
    fi

    echo "bind-addr: ${node}:${port}" >> ${CODE_SERVER_CONFIG} 
    echo "auth: password" >> ${CODE_SERVER_CONFIG}
    echo "password: 10DowningStreet" >> ${CODE_SERVER_CONFIG}
    echo "cert: false" >> ${CODE_SERVER_CONFIG}

    echo "Copy the following line in a new terminal to create a secure SSH tunnel between your computer and Ibex compute node."
    echo "ssh -L localhost:${port}:${node}:${port} ${user}@${submit_host}.ibex.kaust.edu.sa"

    code-server --auth=password --verbose --extensions-dir=${CODE_SERVER_EXTENSIONS}

Port forwarding is required to bind to the listening port of the remote host (Ibex GPU node). For this, open a new terminal window and start an SSH tunnel to achieve the above:

.. code-block:: bash
    
    ssh -L localhost:<port>:dgpu501-22:<port> <username>@glogin.ibex.kaust.edu.sa

In the above command line, ``dgpu501-22`` is the hostname of the machine our job is running (server is running). Use the port your code-server is listening on, and  your <username>  in the above syntax to reverse connect to the remote machine.

In case you have submitted a batch job, please check the slurm output and copy the ssh command from there and paste it in a new terminal


Once the SSH tunnel is established, you can open the URL that code-server is listening on in the browser to access VS code/code-server

.. code-block:: bash
    
    http://localhost:<port>/

Fill the password set in your config file and your session is ready to use. 
When finished, please exit the job on Ibex.