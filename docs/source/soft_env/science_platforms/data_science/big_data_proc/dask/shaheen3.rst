.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Dask
    :keywords: dask, dask_mpi, dask_array, xarray

.. _dask_on_shaheen3:

==========================================
Dask on Shaheen III
==========================================

Accessing Dask on Shaheen III
===============================
Dask on Shaheen III can be accessed in multiple ways. You can either use the system installed dask by loading a modulefile or create your own python environment to manage yourself without KSL staffs' assistance.

Dask from modulefile
---------------------

To use dask from the pre-installed module, you can do the following:

.. code-block::
    
    module swap PrgEnv-cray PrgEnv-gnu
    module load python/3.10.13

How to Install your own
------------------------
Users can either install in a conda environment or via ```pip```.  

Using ```conda``` package
**************************

If you haven't installed ```miniconda``` already, please refer to :ref:`_conda_shaheen3`.
A new environment can be created as follows, with Dask installed: 

.. code-block::

    mamba env create -f dask_env.yaml -p $MY_SW/envs/dask
    
An example ```dask_env.yaml``` is as shown below:

.. code-block::

    name: dask-env
    channels:
    - conda-forge
    dependencies:
    - python=3.9
    - jupyterlab 
    - notebook 
    - ipykernel 
    - nb_conda_kernels 
    - nodejs
    - tensorboard
    - tensorboardx
    - dask[complete]=2024.5.0
    - pip
    - pip: 
        - dask-mpi==2022.4.0
        - dask-jobqueue
        - mpi4py==3.1.4
  
Once installed, you can activate the environment either for interactive use on a batch jobscript:

.. code-block::

    source $MY_SW/miniconda3-amd64/bin/activate $MY_SW/envs/dask

 
Running Distributed Dask cluster on Shaheen III
===============================================

 Dask can run on Shaheen III in two modes. For developing your data pipelines dask can be used in Jupyter Lab on compute nodes of Shaheen III over multiple nodes and increase the available memory.

Interactive job
----------------
The following jobscript first launches a distributed dask cluster using ```dask-mpi``` launcher and then starts a Jupyter lab server. The dask cluster has both dask scheduler and workers. After appropriately setting the ```ssh``` forward connection, the Jupyter lab can connect to the running dask scheduler to access the cluster and launch tasks. The instructions on these steps are printed in the slurm output file onces both servers have started.  
Dask comes with a useful dashboard to monitor the activity of the tasks on workers. Using the assigned port as instructed in the slurm output file, typing ```localhost:<dashboard_port>``` address in the browser opens the Dask dashboard related to the job.

.. code-block::
    
    :caption: Jobscript to launch a Jupyterlab server and Dask scheduler in on jobscript. The resulting slurm output file prints the subsequent steps to establish to ```ssh``` tunnel to connect to the Jupyterlab and Dask dashboard.  

    #!/bin/bash -l 
    #SBATCH --time=01:0:0
    #SBATCH --ntasks=16
    #SBATCH --ntasks-per-node=8
    #SBATCH --cpus-per-task=1
    #SBATCH --hint=nomultithread
    #SBATCH --mem=376G
    #SBATCH --job-name=dask
    #SBATCH --partition=workq


    ### Load the modules you need for your job
    #
    module swap PrgEnv-cray PrgEnv-gnu
    module load python

    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8


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
    #source $MY_SW/miniconda3-amd64/bin/activate $MY_SW/envs/dask

    # setup ssh tunneling
    # get tunneling info
    node=$(hostname -s)
    user=$(whoami)
    submit_host=${SLURM_SUBMIT_HOST}
    jupyter_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    dashboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    sched_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

    	
    srun -c $SLURM_CPUS_PER_TASK -n $SLURM_NTASKS -N ${SLURM_NNODES} \
    --cpu-bind=cores --hint=nomultithread \
    dask-mpi  --nthreads ${SLURM_CPUS_PER_TASK} \
    		--memory-limit="94GiB" \
    		--local-directory=${PWD}/workers${SLURM_JOBID} \
    		--scheduler-file=scheduler_${SLURM_JOBID}.json --interface=hsn0 \
    		--scheduler-port=${sched_port} --dashboard-address=${dashboard_port} \
    		--worker-class distributed.Worker &
    sleep 10

    echo -e "
    To connect to the compute node ${node} on Shaheen III running your jupyter notebook server,
    you need to run following command in a new terminal on you workstation/laptop
    1. Command to create ssh tunnel from you workstation/laptop to cdlX:
    ssh -L ${jupyter_port}:${node}:${jupyter_port} -L ${dashboard_port}:${node}:${dashboard_port} ${user}@${submit_host}.hpc.kaust.edu.sa

    Copy the link provided below by jupyter-server and replace the nid0XXXX with localhost before pasting it in your browser on your workstation/laptop. Do not forget to close the notebooks you open in you browser and shutdown the jupyter client in your browser for gracefully exiting this job or else you will have to manually cancel this job running your jupyter server.
    "

    echo "Starting jupyter server in background with requested resources"

    # Run Jupyter
    jupyter ${1:-lab} --no-browser --port=${jupyter_port} --port-retries=0  --ip=${node}

Batch job
----------
For production and large scale runs, it is advisable to convert the notebook into a python script and run it as a batch job using SLURM. The jobscript below demonstrates how to launch a multicore and multinode job on Shaheen III compute nodes.

.. code-block:: bash
   :caption: 

   #!/bin/bash -l 
   #SBATCH --time=01:0:0
   #SBATCH --ntasks=32
   #SBATCH --ntasks-per-node=4
   #SBATCH --cpus-per-task=48
   #SBATCH --hint=nomultithread
   #SBATCH --mem=376G
   #SBATCH --job-name=dask_batch

   module swap PrgEnv-cray PrgEnv-gnu
   module load python


   #source $MY_SW/miniconda3-amd64/bin/activate $MY_SW/envs/dask

   export LC_ALL=C.UTF-8
   export LANG=C.UTF-8

   # setup ssh tunneling
   # get tunneling info
   node=$(hostname -s)
   user=$(whoami)
   submit_host=${SLURM_SUBMIT_HOST}
   dashboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
   sched_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

   srun -c $SLURM_CPUS_PER_TASK -n $SLURM_NTASKS -N ${SLURM_NNODES} \
   --cpu-bind=cores --hint=nomultithread \
   dask-mpi  --nthreads ${SLURM_CPUS_PER_TASK} \
   		--memory-limit="94GiB" \
   		--local-directory=${PWD}/workers${SLURM_JOBID} \
   		--scheduler-file=scheduler_${SLURM_JOBID}.json --interface=hsn0 \
   		--scheduler-port=${sched_port} --dashboard-address=${dashboard_port} \
   		--worker-class distributed.Worker &

   echo "
   To connect to the Dask Dashboard, copy the following line and paste in new termial, then using URL in a browser : localhost:10001 

   ssh -L {dashboard_port}:${node}:${dashboard_port} ${user}@${submit_host}.hpc.kaust.edu.sa
   "
   sleep 10
   time -p  python dask_futures_xarray.py



The above are example templates and the users are expected to modify them based on the type of parallelism their workflows exhibit to run the task farms in Dask. In some cases multithreading may give better performance compared to multiple isolated processes on the workers. In such case ```--cpus-per-task``` and ```--ntasks-per-node``` attributes of the jobscripts need to be adjusted.  