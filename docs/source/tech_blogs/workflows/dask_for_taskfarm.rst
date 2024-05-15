.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Dask
    :keywords: Dask, ShaheenIII
    
.. _dask_for_taskfarm:

=======================================================
Running a scale out Task farm on Shaheen using Dask
=======================================================

Dask is a Python library useful to run larger than memory workloads on multiple cores and nodes of a cluster of resources. 

In this case, we want to demonstrate how Dask can be used to run a swarm of thin tasks which have load-imbalance on a compute resource which is fewer than the tasks, but can dynamically be increased if the task-farm is running at slower pace than tolerable. 


Problem statement
==================
As an example, we have a few steps in a task that needs to be done multiple times. One essential condition that the task must fulfill is that it is independent, that is, it can run exclusively without any dependency on another task of the farm.
Below is a pseudo-code with step of a representative task:

#. Create a directory
#. Copy task specific input files from a common source directory
#. Load software environment with the target application installed
#. Launch the command and its arguments and Log progress to a log file in Present Working Directory
#. When finished, copy the output in a common output director 
#. Delete the task specific directory 

Consider that you must do this a million times. Its would be useful to have an execution framework which:

* allows to express the workflow
* allows a way to map tasks to resources (i.e. number of cores for each task, etc .. )
* gives monitoring capability to keep track of e.g. progress of task farm, CPU load, memory consumption etc.
  
As a by-product, we get the benefit of:

* packing thin tasks (e.g. 1 core task) on a single Shaheen node, maximizing the node utilization
* introducing a hook to dynamically allocate more worker nodes as SLURM jobs and extend the resources available to the scheduler to run the task farm 
* possibility to resume the task farm as a new set of jobs (depending on if you have added some logic) , therefore allowing checkpoint-restart

Implementation
================
We are leveraging Dask’s execution engine on Shaheen III's compute nodes for this purpose. 

We break our workflow into three components:

A user_workflow.py script to express the steps in a workflow. It also allows expressing the parameters and passes a task and its corresponding parameter to the Dask cluster via the client API. 

A wrapper.sh is an executable bash script which does steps common to each task, e.g. setting the environment. The command line (including the options/arguments) are passes as an argument when invoking the wrapper script

Two jobscripts to interact with SLURM

* ``sched.slurm`` is a jobscript which invokes Dask scheduler and invokes the user_workflow.py when worker nodes are ready. It also submits the worker.slurm script to SLURM depending on the value of NUM_WORKERS set in the script

* ``worker.slurm`` allocates resources for a worker node which is a Shaheen compute node as a SLURM job, where Dask workers will start and will connect to an existing Dask scheduler . This jobscript also allows tuning the configuration of resources available for each Dask worker, i.e CPUs or memory

User workflow script
----------------------
The script below is the **task** each core on a Shaheen III node is expected to launch and run independently.

.. code-block:: python
    :caption: ``user_workflow.py``

    #!/usr/bin/env python

    from dask.distributed import Client,as_completed
    import os,time, subprocess as sb
    import numpy as np

    client = Client(scheduler_file='scheduler.json')  # start local workers as processes


    def params(filename='foo.txt'):
        f = open(filename,'r+')
        files = f.read().splitlines() # List with stripped line-breaks 
        f.close()
        return files

    def func(x,out_dir):
        fo=open(os.path.join(out_dir,'out.log'),'w+')
        fe=open(os.path.join(out_dir,'err.log'),'w+')
        
        srcdir=os.path.join(os.environ['PWD'],'user_case')
        EXE='FreeFem++-nw'

        # Pre-processing steps --  before launching the application
        o = sb.run(['rsync','-r','%s'%(os.path.join(srcdir,'pv_LIR_etau_IVCurve_SF.edp')),
            'pv_LIR_etau_IVCurve_SF.edp']
            ,cwd=out_dir)
        o = sb.run(['rsync','-r','%s'%(os.path.join(srcdir,'BF_RefMeshLIR_100x100x95x100.msh')),
            'BF_RefMeshLIR_100x100x95x100.msh']
            ,cwd=out_dir)
        o = sb.run(['rsync','-r','%s'%(os.path.join(os.environ['PWD'],'wrapper.sh')),
            'wrapper.sh']
            ,cwd=out_dir)

        # Launch the application along with its optinos as command line arugument to wrapper script 
        o = sb.run(['./wrapper.sh','%s'%(EXE),'pv_LIR_etau_IVCurve_SF.edp','%s'%(x)],
                    stdout=fo,stderr=fe,
                    shell=False,cwd=out_dir)
        # Post-processing steps
            # - Copy the output file and rename it to index according to the task
            # - Delete the task directory if the processing was successful
        
        return True

    base_dir=os.environ['EXP_NAME']
    os.makedirs(base_dir,exist_ok=True)

    # the logic of parameter setting is encapsulated in params function:
    x = params()

    outdirs=list()
    for i in range(len(x)):
        sample_dir=os.path.join(base_dir,'%s'%(str(i+1)))
        os.makedirs(sample_dir,exist_ok=True)
        outdirs.append(sample_dir)
    print('outdirs[%d]:: '%(len(outdirs)),outdirs)


    futures=client.map(func,x,outdirs)

    for future in as_completed(futures):
        print('result: ',future.result())

    client.close()


Wrapper script
----------------
In the wrapper script, you can set the environment to run the target application and invoke it via the arguments passed in from the ``user_workflow.py`` script where the ``wrapper.sh`` was invoked.   

.. code-block:: bash
    :caption: ``wrapper.sh``

    #!/bin/bash

    module swap PrgEnv-cray PrgEnv-gnu
    module load freefem/4.7
    module list
    echo "running $@"
    $@

In the above example, the software environment is set by loading some installed modules on Shaheen III. However, this can be replaced by another module or sourcing a ``conda`` environment.

SLURM jobscripts
==================

There are two scripts needed in this workflow:

Scheduler script
-----------------

The scheduler script will, e.g. look as below. The relevant part a user is where ``user_workflow.py`` is invoked on the head node. This will launch the tasks on the available worker nodes. There is a sleep command to wait to ensure a clean startup of tasks.

.. code-block:: bash
    :caption: ``scheduler script``

    #!/bin/bash -l
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=4
    #SBATCH --partition=shared
    #SBATCH --time=01:00:00

    module load python/3.10.13

    NUM_WORKERS=4
    WORKER_JOB_PREFIX=test_workers
    export EXP_NAME=experiment_${SLURM_JOBID}

    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

    # get tunneling info 
    export XDG_RUNTIME_DIR="" 
    node=$(hostname -s) 
    user=$(whoami) 
    submit_host=${SLURM_SUBMIT_HOST} 
    port=8889
    dask_dashboard=9000

    if [ -f 'scheduler.json' ]; then
    	rm scheduler.json
    fi

    srun -u --hint=nomultithread dask-scheduler --scheduler-file=scheduler.json --dashboard-address=${node}:${dask_dashboard} --port=6192 --interface=ipogif0 &


    echo $node on $gateway pinned to port $port
    # print tunneling instructions jupyter-log
    echo -e "
    To connect to the compute node ${node} on Shaheen running your jupyter notebook server,
    you need to run following two commands in a terminal

    1. Command to create ssh tunnel from you workstation/laptop to cdlX:
    ssh -L ${dask_dashboard}:localhost:${dask_dashboard} ${user}@${submit_host}.hpc.kaust.edu.sa

    1. Command to create ssh tunnel to run on cdlX:
    ssh -L ${dask_dashboard}:${node}:${dask_dashboard} ${user}@${gateway}

    Copy the link provided below by jupyter-server and replace the nid0XXXX with localhost before pasting it in your browser on your workstation/laptop
    "

    while [ ! -f 'scheduler.json' ] ; 
    do
    	sleep 2
    	echo "Waiting for dask scheduler to start"
    done

    for ((i=1; i< $((NUM_WORKERS + 1)); i++))
    	do
    		sbatch -J ${WORKER_JOB_PREFIX}  worker.slurm
    done

    sleep 180
    echo "Starting workload"
    python -u user_workflow.py
    scancel -n ${WORKER_JOB_PREFIX} 
    exit 0
    wait

