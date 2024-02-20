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


Shaheen III 
-----------------------
Below is an example jobscript to launch a jupyter server. The output of this job will have instruction to follow steps to connect to the running jupyter server session.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --cpus-per-task=4
    #SBATCH --partition=shared
    #SBATCH --time=00:30:00 
    #SBATCH --job-name=demo

    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

    ### Load the modules you need for your job

    module load python

    
    export JUPYTER_CONFIG_DIR=/scratch/shaima0d/iops/.jupyter
    export JUPYTER_DATA_DIR=/scratch/shaima0d/iops/.local/share/jupyter
    export JUPYTER_RUNTIME_DIR=/scratch/shaima0d/iops/.local/share/jupyter/runtime
    export IPYTHONDIR=/scratch/shaima0d/iops/.ipython

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
    echo ${node} pinned to port ${port} on ${SLURM_SUBMIT_HOST}

    # print tunneling instructions jupyter-log
    echo -e "
    To connect to the compute node ${node} on Shaheen III running your jupyter notebook server,
    you need to run following commnad in a new terminal on you workstation/laptop
    1. Command to create ssh tunnel from you workstation/laptop to cdlX:
    ssh -L ${port}:${node}:${port} ${user}@${submit_host}.hpc.kaust.edu.sa

    Copy the link provided below by jupyter-server and replace the nid0XXXX with localhost before pasting it in your browser on your workstation/laptop. Do not forget to close the notebooks you open in you browser and shutdown the jupyter client in your browser for gracefully exiting this job or else you will have to mannually cancel this job running your jupyter server.
    "

    echo "Starting jupyter server in background with requested resouce"

    # Run Jupyter
    jupyter ${1:-lab} --no-browser --port=${port} --port-retries=0  --ip=${node}
    


Ibex
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
    
    


Once the job starts, the SLURM output file created in the directory you submitted the job from will have the instructions on how to reverse connect. 

check the following output in  SLURM output will look something like this:

.. code-block:: bash 
   
     To access the server, open this file in a browser:
        file:///home/username/.local/share/jupyter/runtime/jpserver-44653-open.html
     Or copy and paste one of these URLs:
        http://gpu214-06.ibex.kaust.edu.sa:55479/lab?token=8a998b0772313ce6e5cca9aca1f13f2faff18d950d78c776
     or http://127.0.0.1:55479/lab?token=8a998b0772313ce6e5cca9aca1f13f2faff18d950d78c776

- Open a new terminal on your local machine and copy and paste the ssh tunnel command from the ``%x-%j-slurm.err``

``ssh -L 57162:gpu214-02.ibex.kaust.edu.sa:57162 username@glogin.ibex.kaust.edu.sa``

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