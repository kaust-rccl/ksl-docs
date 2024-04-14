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
    mkdir -p EXTENSIONS_DIR
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


    code-server --auth=password --user-data-dir=${PWD}/data --extensions-dir=${EXTENSIONS_DIR} --verbose


Running code-server on Ibex
============================

The following has been tested on Ibex’s GPUs node and client in Google Chrome on local workstation. 

Please login to ``username@vscode.ibex.kaust.edu.sa`` for the steps below. This is to isolate the processes invoked by VSCode.

It applies to those who are only interested to use Ibex’s filesystem in your local VS Code installation.

You can run code-server remote server either interactively or in a batch job. Batch jobs are preferred

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

    source $HOME/miniconda3/bin/activate ./codeserver


    export CODE_SERVER_CONFIG=~/.config/code-server/config.yaml
    export XDG_CONFIG_HOME=$HOME/tmpdir
    node=$(/bin/hostname)
    port=10121
    user=$(whoami) 
    submit_host=${SLURM_SUBMIT_HOST} 

    if [ -f ${CODE_SERVER_CONFIG} ] ; then
    rm ${CODE_SERVER_CONFIG}
    fi

    echo "bind-addr: ${node}:${port}" >> $CODE_SERVER_CONFIG 
    echo "auth: password" >> config
    echo "password: 10DowningStreet" >> $CODE_SERVER_CONFIG
    echo "cert: false" >> config

    echo "Copy the following line in a new terminal to create a secure SSH tunnel between your computer and Ibex compute node."
    echo "ssh -L localhost:${port}:${node}:${port} ${user}@${submit_host}.ibex.kaust.edu.sa"

    code-server --auth=password --verbose

Step 3
^^^^^^^
Port forwarding is required to bind to the listening port of the remote host (Ibex GPU node). For this, open a new terminal window and start an SSH tunnel to achieve the above:



``ssh -L localhost:10121:dgpu501-22:10121 username@glogin.ibex.kaust.edu.sa``

In the above command line, ``dgpu501-22`` is the hostname of the machine our job is running (server is running). Use you username instead of username  and the jump server/node is glogin login node.

In case you have submitted a batch job, please see the slurm output and copy the ssh command from there and paste it in a new terminal


Step 4
^^^^^^^^
Once the SSH tunnel is established, you can open the URL that code-server is listening on in the browser to access VS code/code-server

``http://localhost:10121/``

Fill the password and your session is ready to use. 
When finished, please exit the job on Ibex.