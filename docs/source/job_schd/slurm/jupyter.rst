Jupyter Notebooks
====================

Here We explain how to launch Jupyter Notebooks on compute node on Ibex as a server and run the Jupyter client in the local browser on your laptop/workstation.

The steps are as follows:
---------------------------

* The Jupyter server instance will be submitted to the SLURM scheduler as a jobscript requesting resource allocation and launching Jupyter when the allocation is available for your job. Note that all the required modules should have been loaded in your jobscript before submitting.

* Reverse connect to the compute node(s) running the Jupyter server

* Launching the Jupyter client in your local browser

* Terminating/ending the session

Jupyter server Jobscript
---------------------------
Let’s first look at how to launch a Jupyter server on the Ibex GPU node and connect to it.

Ibex compute node
^^^^^^^^^^^^^^^^^

.. code-block:: bash 
    :caption: For example, the following is a jobscript requesting GPU resources on Ibex.
    
    #!/bin/bash --login
    #SBATCH --time=00:30:00
    #SBATCH --nodes=1
    #SBATCH --gpus-per-node=v100:1
    #SBATCH --cpus-per-gpu=6  
    #SBATCH --mem=32G
    #SBATCH --partition=batch 
    #SBATCH --job-name=demo
    #SBATCH --mail-type=ALL
    #SBATCH --output=%x-%j-slurm.out
    #SBATCH --error=%x-%j-slurm.err 
 
    # use srun to launch Jupyter server in order to reserve a port

   
     make srun launch-jupyter-server.srun

.. code-block:: bash 
    :caption: This is the launch-jupyter-server.srun script: 
    
    # Load environment which has Jupyter installed. It can be one of the following:
    # - Machine Learning module installed on the system (module load machine_learning)
    # - your own conda environment on Ibex
    # - a singularity container with python environment (conda or otherwise)  

    # setup the environment
    module purge

    # You can use the machine learning module 
    module load machine_learning/2022.11
    # or you can activate the conda environment directly by uncommenting the following lines
    #export ENV_PREFIX=$PWD/env
    #conda activate $ENV_PREFIX

    # setup ssh tunneling
    # get tunneling info 
    export XDG_RUNTIME_DIR=/tmp node=$(hostname -s) 
    user=$(whoami) 
    submit_host=${SLURM_SUBMIT_HOST} 
    port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    echo ${node} pinned to port ${port} on ${submit_host} 

    # print tunneling instructions  
    echo -e " 
    ${node} pinned to port ${port} on ${submit_host} 
    To connect to the compute node ${node} on IBEX running your jupyter notebook server, you need to run following two commands in a terminal 1. 
    Command to create ssh tunnel from you workstation/laptop to glogin: 
 
    ssh -L ${port}:${node}.ibex.kaust.edu.sa:${port} ${user}@glogin.ibex.kaust.edu.sa 
 
    Copy the link provided below by jupyter-server and replace the NODENAME with localhost before pasting it in your browser on your workstation/laptop.
    " >&2 
 
    # Run Jupyter 
    #jupyter notebook --no-browser --port=${port} --port-retries=0 --ip=${node}

    # launch jupyter server
    jupyter ${1:-lab} --no-browser --port=${port} --port-retries=0  --ip=${node}.ibex.kaust.edu.sa
    
    This is the launch-jupyter-server.srun script: 


Once the job starts, the SLURM output file created in the directory you submitted the job from will have the instructions on how to reverse connect. 

check the following output in  SLURM output will look something like this:

.. code-block:: bash 
   
     To access the server, open this file in a browser:
        file:///home/barradd/.local/share/jupyter/runtime/jpserver-44653-open.html
     Or copy and paste one of these URLs:
        http://gpu214-06.ibex.kaust.edu.sa:55479/lab?token=8a998b0772313ce6e5cca9aca1f13f2faff18d950d78c776
     or http://127.0.0.1:55479/lab?token=8a998b0772313ce6e5cca9aca1f13f2faff18d950d78c776

* Open a new terminal on your local machine and copy and paste the ssh tunnel command from the ``%x-%j-slurm.err``

``ssh -L 57162:gpu214-02.ibex.kaust.edu.sa:57162 your-username@glogin.ibex.kaust.edu.sa``

* This has created an SSH tunnel between the compute node your Jupyter server is launched on Ibex and your local machine on IP address localhost and port 57162. 

* Now we are ready to launch our Jupyter client. Copy one of the two last lines in the ``%x-%j-slurm.err`` file  and paste it into your browser address bar:

``http://gpu214-02.ibex.kaust.edu.sa:57162/lab?token=ce300e312eb05df3616f8d4329677635750da4818b26da7``

* Be aware that the root directory in your Jupyter file browser is the directory you submitted the job from. 

* We can now do some computations. Since this Jupyter job asked for, let’s test the GPU. Note that all the required modules should have been loaded in your jobscript before submitting.

