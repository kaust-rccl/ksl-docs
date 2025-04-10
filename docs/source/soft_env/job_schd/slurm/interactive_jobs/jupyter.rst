.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Launching jupyter
    :keywords: jupyter

.. _using_jupyter:

====================
Jupyter Notebooks
====================

Here We explain how to launch Jupyter Notebooks on compute node on Ibex as a server and run the Jupyter client in the local browser on your laptop/workstation.

The steps are as follows:

- The Jupyter server instance will be submitted to the SLURM scheduler as a jobscript requesting resource allocation and launching Jupyter when the allocation is available for your job. Note that all the required modules should have been loaded in your jobscript before submitting.

- Connect to the compute node(s) running the Jupyter server using port forwarding

- Launch the Jupyter client in your local browser

- Terminate/end the session to cancel the SLURM job

Jupyter server Jobscript
==========================

Though all KSL system run SLURM there are few subtle differences in how to launch Jupyter sessions on their compute nodes.
Below are sample jobscripts for launching the JupyterLab server on Shaheen III and Ibex compute nodes. Once the job starts the steps to connecting to the running Jupyter Lab session is common for both KSL systems

Job on Shaheen III 
-------------------
Below is an example jobscript to launch a jupyter server. The output of this job will have instruction to follow steps to connect to the running jupyter server session.

.. code-block:: bash
    :caption: A batch job to launch the Jupyter Lab server on a compute node of Shaheen III in ``shared`` partition. To get more compute resources on a node, please set the partition ``workq``

    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --cpus-per-task=4
    #SBATCH --partition=shared
    #SBATCH --time=00:30:00 
    #SBATCH --job-name=jupyter

    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

    ### Load the modules you need for your job

    module load python

    export JUPYTER_CONFIG_DIR=${SCRATCH_IOPS}/.jupyter
    export JUPYTER_DATA_DIR=${SCRATCH_IOPS}/.local/share/jupyter
    export JUPYTER_RUNTIME_DIR=${SCRATCH_IOPS}/.local/share/jupyter/runtime
    export IPYTHONDIR=${SCRATCH_IOPS}/.ipython

    ############################################################
    ## Load the conda base and activate the conda environment ##
    ############################################################
    ############################################################
    ## activate conda base from the command line
    ############################################################
    #source $MY_SW/miniconda3/bin/activate myenv



    # setup ssh tunneling
    # get tunneling info
    node=$(hostname -s)
    user=$(whoami)
    submit_host=${SLURM_SUBMIT_HOST}
    port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    tb_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    echo ${node} pinned to port ${port} on ${SLURM_SUBMIT_HOST}

    # print tunneling instructions jupyter-log
    echo -e "
    To connect to the compute node ${node} on Shaheen III running your jupyter notebook server,
    you need to run following command in a new terminal on you workstation/laptop

    ssh -L ${port}:${node}:${port} -L ${tb_port}:${node}:${tb_port} ${user}@${submit_host}.hpc.kaust.edu.sa

    Copy the URL provided below by jupyter-server (one starting with http://127.0.0.1/...) and paste it in your browser on your workstation/laptop.

    Do not forget to close the notebooks you open in you browser and shutdown the jupyter client in your browser for gracefully exiting this job or else you will have to manually cancel this job running your jupyter server.
    "

    echo "Starting jupyter server in background with requested resources"

    LOGS_DIR="./logs"
    tensorboard --logdir=${LOGS_DIR} --port=${tb_port} --host=${node} &
    # Run Jupyter

    jupyter ${1:-lab} --no-browser --port=${port} --port-retries=0  --ip=${node}

    
Steps after job starts
***********************

* Open the ``slurm-#####.out`` file and copy the command to establish ``ssh`` tunnel. For example:

.. code-block:: bash

    ssh -L 12345:nid00121:12345 -L -L 67890:nid00121:67890 <username>@login2.hpc.kaust.edu.sa

* Paste the copied command in a new terminal. Note that the first port being forwarded is for Jupyter and the second for Tensorboard. 

* Now copy the URL from the end of the slurm output file. It starts with 

.. code-block:: bash
    
    http://127.0.0.1:<port-number>/<secret-token-auth>
    
Please copy the full URL, the hash at the end is the secret token and Jupyter Lab uses it to authenticate you as the owner of the session. 
For Tensorboard, you can write http://127.0.0.1:<second_port> from the SSH line in your SLURM output to connect to the ``tensorboard`` server running on the compute node. Please make sure that the path to the logs directory is correct.

* Once you are finished with your work, please navigate to the file menu of Jupyter Lab and select "Shutdown" and this will terminate the Jupyter Lab server on the compute node and conclude the job. 



Job on Ibex
-------------------

Compute nodes on Ibex are heterogeneous and it is necessary to describe the request for resources in more granularity than in Shaheen III above.

Below is an example jobscript to launch a jupyter server with GPU resources. 

.. code-block:: bash 
    
    #!/bin/bash
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
 

    # Load environment which has Jupyter installed. It can be one of the following:
    # - Machine Learning module installed on the system (module load machine_learning)
    # - your own conda environment on Ibex
    # - a singularity container with python environment (conda or otherwise)  

    # setup the environment
    module purge

    # You can use the machine learning module 
    module load machine_learning/2024.01
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

    # launch jupyter server
    jupyter ${1:-lab} --no-browser --port=${port} --port-retries=0  --ip=${node}.ibex.kaust.edu.sa
    
    

Steps to do after Job starts
=============================

Once the job starts, the SLURM output file created in the directory you submitted the job from will have the instructions on how to connect. 
Check the following output in  SLURM output will look something like this:

.. code-block:: bash 
   
     To access the server, open this file in a browser:
        file:///home/username/.local/share/jupyter/runtime/jpserver-44653-open.html
     Or copy and paste one of these URLs:
        http://gpu214-06.ibex.kaust.edu.sa:55479/lab?token=8a998b0772313ce6e5cca9aca1f13f2faff18d950d78c776
     or http://127.0.0.1:55479/lab?token=8a998b0772313ce6e5cca9aca1f13f2faff18d950d78c776

- Open a new terminal on your local machine and copy and paste the ssh tunnel command from the ``%x-%j-slurm.err``

.. code-block:: bash

    ssh -L 57162:gpu214-02.ibex.kaust.edu.sa:57162 username@glogin.ibex.kaust.edu.sa

- This has created an SSH tunnel between the compute node your Jupyter server is launched on Ibex and your local machine on IP address localhost and port 57162. 

- Now we are ready to launch our Jupyter client. Copy one of the two last lines in the ``%x-%j-slurm.err`` file  and paste it into your browser address bar:

``http://gpu214-02.ibex.kaust.edu.sa:57162/lab?token=ce300e312eb05df3616f8d4329677635750da4818b26da7``

- Be aware that the root directory in your Jupyter file browser is the directory you submitted the job from. 

- We can now do some computations. Since this Jupyter job asked for, let’s test the GPU. Note that all the required modules should have been loaded in your jobscript before submitting.

Ibex - launch jupyter-one-line
--------------------------------------

To run a specific command on a computing cluster using Slurm job management, follow these steps:

1. Open a terminal window.

2. Use the following command to submit a job using the `srun` command and specify the desired resource allocation options:
    
.. code-block:: bash 
    
        srun --gpus=1 --mem=32G --cpus-per-task=16 -C v100 --time=00:30:00 --resv-ports=1 --pty /bin/bash -l launch-jupyter-one-line.sh
    

Here's a breakdown of the options used:

- `--gpus=1`: Request 1 GPU for the job.
- `--mem=32G`: Request 32GB of memory.
- `--cpus-per-task=16`: Request 16 CPU cores per task.
- `-C v100`: Request a compute node with NVIDIA V100 GPUs.
- `--time=00:30:00`: Request a maximum job runtime of 30 minutes.
- `--resv-ports=1`: Reserve a port for the job.
- `--pty`: Allocate a pseudo terminal for the job.
- `/bin/bash -l launch-jupyter-one-line.sh`: Run the `launch-jupyter-one-line.sh` script in a Bash shell with the login environment.

3. After executing the command, the job will be submitted to the cluster and will run according to the specified resource allocation and script instructions. The job will be assigned a job ID, which will be displayed in the terminal window. You can use this job ID to monitor the job's progress and check its status.

4. Now on your terminal you will see the same kind of message from jupyter

.. code-block:: bash 
   
     To access the server, open this file in a browser:
        file:///home/username/.local/share/jupyter/runtime/jpserver-44653-open.html
     Or copy and paste one of these URLs:
        http://gpu214-06.ibex.kaust.edu.sa:55479/lab?token=8a998b0772313ce6e5cca9aca1f13f2faff18d950d78c776
     or http://127.0.0.1:55479/lab?token=8a998b0772313ce6e5cca9aca1f13f2faff18d950d78c776

5. Copy one of the line of that start with `gpuXXX-XX` into your browser. We can now do some computations


This is the content of the `launch-jupyter-one-line.sh` file. 

.. code-block:: bash

    #!/bin/bash
    # Activate the environment and execute the commands within a subshell
    (
        eval "$(conda shell.bash hook)"
        # Load and run packages
        module load machine_learning
        # or activate the conda environment 
        #export ENV_PREFIX=$PWD/env
        #conda activate $ENV_PREFIX

        jupyter lab --no-browser --ip="$(hostname)".ibex.kaust.edu.sa
    )