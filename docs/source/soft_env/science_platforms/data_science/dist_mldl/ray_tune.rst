.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: HPO with Ray Tune
    :keywords: ray tune

.. _ray_tune:

=====================================================
Ray Tune for Hyperparameter Optimization experiments
=====================================================
`Ray <https://docs.ray.io/en/latest/index.html#>`_ is a powerful opensource framework to scale Python and ML/DL workloads on clusters and cloud. `Ray Tune <https://docs.ray.io/en/latest/tune/index.html>`_ is a Python library from this Ray's ecosystem that allows experiment execution of Hyperparameter tuning at any scale. It integrates with popular machine learning frameworks (PyTorch, XGBoost, TensorFlow and Keras etc) and run battle tested search algorithms for finding best combination of hyperparameters to optimize the objective value e.g. minimizing loss, maximizing accuracy. It also have accessors to various scheduling the trials of an experiments to save on the computational resources and time to best fit.  

On Shaheen III and Ibex, Ray Tune is available. This documentation mainly explains how to run the Ray Tune experiments. For more details on Ray Tune's functionality please refer to its `documentation <https://docs.ray.io/en/latest/tune/index.html>`_. 

Environment setup
==================

.. code-block::
    :caption: conda env for Ray Tune

    name: ray2_2
    channels:
        - pytorch
        - nvidia
        - conda-forge
    dependencies:
        - cmake
        - python=3.9
        - pip
        - gcc=10
        - gxx=10
        - pytorch=1.10.2=py3.9_cuda11.3_cudnn8.2.0_0
        - nccl
        - torchvision
        - grpcio=1.43.0
        - tensorboard
        - jupyterlab
        - pip:
        - ray==2.2
        - ray[tune,rllib,serve]
        - wandb
        - pydantic==1.10.13



Ibex demos
===========

Demo1
------

Helloworld with Ray Tune on CPUs example

Python file needed to run the demo `here <https://github.com/kaust-rccl/hpo-with-ray/blob/master/demo1/hello_tune.py>`_

.. code-block::
    :caption: jobscirpt to start server and worker

    #!/bin/bash
    #SBATCH --job-name=ray_tune
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=2
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=8
    #SBATCH --time=00:30:00

    source ~/miniconda3/bin/activate ray2_2

    export XDG_RUNTIME_DIR=$PWD 
    NUM_CPUS=${SLURM_CPUS_PER_TASK}

    export server_port=9121
    export dashboard_port=9122
    export redis_password=${SLURM_JOBID}


    # Getting the node names
    nodes=$(scontrol show hostnames "$SLURM_JOB_NODELIST")
    nodes_array=($nodes)
    echo "Node IDs of participating nodes ${nodes_array[*]}"

    head_node=${nodes_array[0]}
    head_node_ip=$(srun  --nodes=1 --ntasks=1  -w "$head_node" /bin/hostname -I | cut -d " " -f 1)


    ## STARTING Ray head node
    export ip_head=$head_node_ip:${server_port}
    echo "IP Head: $ip_head"

    echo "Starting HEAD at $head_node"
    cmd="srun -u -n 1 -N 1 -c ${SLURM_CPUS_PER_TASK} -w ${head_node}  \
        ray start --node-ip-address ${head_node_ip} --port ${server_port} \
                    --redis-password=${redis_password} --head --num-cpus ${NUM_CPUS}  \
                    --dashboard-port ${dashboard_port} --dashboard-host=$HOSTNAME \
                    --temp-dir=${HOME}/temp/${SLURM_JOBID} --verbose --block"
    echo $cmd
    $cmd &

    ## STARTING Ray worker nodes

    # optional, though may be useful in certain versions of Ray < 1.0.
    sleep 30

    # number of nodes other than the head node
    worker_num=$((SLURM_JOB_NUM_NODES - 1))

    for ((i = 1; i <= worker_num; i++)); do
        node_i=${nodes_array[$i]}
        echo "Starting WORKER $i at $node_i"
        cmd="srun -u -w "$node_i" -n 1 -N 1 -c ${NUM_CPUS}  \
            ray start --address "$ip_head" --redis-password=${redis_password} \
                        --num-cpus ${NUM_CPUS}  \
                        --temp-dir=${HOME}/temp/${SLURM_JOBID} --verbose --block"
        echo $cmd
        $cmd &
        
        sleep 40
    done

    ## SUBMIT workload to the Ray cluster
    ray status --address ${ip_head} --redis_password ${redis_password} 
    sleep 40
    python -u hello_tune.py --num-samples=100 --max-concurrent-trials=20
    exit 0

The jobscirpt can be submitted using the ``sbatch`` command.



Demo1 interactive
------------------

interactive Helloworld example

jupyter notebooks for this demo found `here <https://github.com/kaust-rccl/hpo-with-ray/tree/master/demo1_interactive/helloworld>`_



.. code-block::
    :caption: jobscirpt to start server

    #!/bin/bash
    #SBATCH --cpus-per-task=2
    #SBATCH --time=0:30:00
    #SBATCH --job-name=ray_server
    #SBATCH --output=%x-%J.out
    #SBATCH --error=%x-%J.out
    #SBATCH --reservation=DS-TRAINING


    module load dl
    module load pytorch
    module load ray/2.2.0

    export server_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export dashboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export redis_password=${SLURM_JOBID}


    head_node_ip=$(hostname -I | cut -d " " -f 1)
    export ip_head=${head_node_ip}:${server_port}
    echo "${ip_head} ${redis_password} ${dashboard_port}" > head_node_info


    ray start --node-ip-address ${head_node_ip} --port ${server_port} --redis-password=${redis_password} --head  \
        --dashboard-port ${dashboard_port} --dashboard-host=$HOSTNAME \
            --num-cpus ${SLURM_CPUS_PER_TASK} -vvv --block 


.. code-block::

    :caption: jobscirpt to start interactive client

    #!/bin/bash

    #SBATCH --time=00:30:00
    #SBATCH --cpus-per-task=8
    #SBATCH --job-name=ray_client
    #SBATCH --output=%x-%J.out
    #SBATCH --error=%x-%J.out
    #SBATCH --reservation=DS-TRAINING
    #SBATCH --gpus=1

    module load dl
    module load pytorch
    module load ray/2.2.0

    export jup_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export ip_head=$(cat ./head_node_info | cut -d " " -f 1)
    export head_node_ip=$(echo ${ip_head} | cut -d ":" -f 1)
    export redis_password=$(cat ./head_node_info | cut -d " " -f 2)
    export dashboard_port=$(cat ./head_node_info | cut -d " " -f 3)


    ray start --address ${ip_head}  --redis-password ${redis_password} \
        --num-cpus ${SLURM_CPUS_PER_TASK} \
        --block &
    sleep 20
    ray status --address ${ip_head} --redis_password ${redis_password}

    echo "
    For dashboard create SSH tunnel via the following \n
    ssh -L localhost:${jup_port}:$(/bin/hostname):${jup_port} -L localhost:${dashboard_port}:${head_node_ip}:${dashboard_port} ${USER}@glogin.ibex.kaust.edu.sa
    "
    jupyter-lab --no-browser --port=${jup_port} --port-retries=0  --ip=$(/bin/hostname)

    ray stop
    server_jobID=$(squeue -t r -u $USER -n ray_server -O JobID -h)
    scancel $server_jobID



Demo2
------

Python script needed to run demo `here <https://github.com/kaust-rccl/hpo-with-ray/blob/master/demo2/ray_mnist_pytorch.py>`_

.. code-block::
    :caption: jobscirpt to start head node

    #!/bin/bash
    #SBATCH --job-name=ray_head
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=4
    #SBATCH --time=00:30:00
    #SBATCH --reservation=DS-TRAINING

    module load dl
    module load pytorch
    module load ray/2.2.0


    #Requested number of workers
    if [ -z ${NUM_WORKERS} ] ; then
    NUM_WORKERS=1
    else
    NUM_WORKERS=${NUM_WORKERS}
    fi


    export server_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export dashboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export tensorboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export node=$(/bin/hostanme -s)
    echo "
    Connect to dashboard by creating SSH tunnels. Copy the following command in a new terminal
    and connect to localhost via your browser.
    ssh -L localhost:${dashboard_port}:${node}:${dashboard_port} -L localhost:${tensorboard_port}:${node}:${tensorboard_port} ${USER}@glogin.ibex.kaust.edu.sa
    "


    export TB_TMPDIR=$PWD/tboard/${SLURM_JOBID}
    mkdir -p ${TB_TMPDIR}

    export redis_password=${SLURM_JOBID}
    export head_node_ip=$(hostname -I | cut -d " " -f 2)
    export ip_head=${head_node_ip}:${server_port}
    echo "${ip_head} ${redis_password} ${dashboard_port}" > head_node_info


    ray start --node-ip-address ${head_node_ip} --port ${server_port} --redis-password=${redis_password} --head  \
        --dashboard-port ${dashboard_port} --dashboard-host=127.0.0.1 \
            --num-cpus 1 --block &
    tensorboard --logdir=${PWD}/logs/${SLURM_JOBID} --port=${tensorboard_port} & 
    sleep 20

    job_ids=()
    for (( i=1; i<=${NUM_WORKERS}; i++ ))
    do
    job_ids[$i]=$(sbatch -x $SLURM_NODELIST worker_node.slurm | cut -d " " -f 4)
    done 

    while [ ! -z $(squeue -n ray_worker -t PD -h -o %A) ]
    do
        echo "Waiting for worker(s) to start"
            sleep 20
    done


    python -u ray_mnist_pytorch.py --use-gpu \
            --cpus-per-trial=4 --gpus-per-trial=1 \
            --num-samples=200 \
            --max-concurrent-trials=32 
            


    # Shutdown workers before the head node
    touch $PWD/shutdown.txt
    sleep 20
    echo " Stopping ray on Head node: $(/bin/hostname)"
    ray stop
    rm $PWD/shutdown.txt

.. code-block::
    :caption: jobscirpt to resume head node

    #!/bin/bash
    #SBATCH --job-name=ray_head
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=4
    #SBATCH --time=00:30:00
    #SBATCH --reservation=DS-TRAINING

    module load dl
    module load pytorch
    module load ray/2.2.0

    #Requested number of workers
    if [ -z ${NUM_WORKERS} ] ; then
    NUM_WORKERS=1
    else
    NUM_WORKERS=${NUM_WORKERS}
    fi



    export server_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export dashboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export tensorboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export node=$(/bin/hostname -s)
    echo "
    Connect to dashboard by creating SSH tunnels. Copy the following command in a new terminal
    and connect to localhost via your browser.
    ssh -L localhost:${dashboard_port}:${node}:${dashboard_port} -L localhost:${tensorboard_port}:${node}:${tensorboard_port} ${USER}@glogin.ibex.kaust.edu.sa
    "


    export TB_TMPDIR=$PWD/tboard/${SLURM_JOBID}
    mkdir -p ${TB_TMPDIR}

    export redis_password=${SLURM_JOBID}
    export head_node_ip=$(hostname -I | cut -d " " -f 2)
    export ip_head=${head_node_ip}:${server_port}
    echo "${ip_head} ${redis_password} ${dashboard_port}" > head_node_info


    ray start --node-ip-address ${head_node_ip} --port ${server_port} --redis-password=${redis_password} --head  \
        --dashboard-port ${dashboard_port} --dashboard-host=127.0.0.1 \
            --num-cpus 1 --block &
    tensorboard --logdir=${PWD}/logs/${SLURM_JOBID} --port=${tensorboard_port} & 
    sleep 20

    job_ids=()
    for (( i=1; i<=${NUM_WORKERS}; i++ ))
    do
    job_ids[$i]=$(sbatch -x $SLURM_NODELIST worker_node.slurm | cut -d " " -f 4)
    done 

    while [ ! -z $(squeue -n ray_worker -t PD -h -o %A) ]
    do
        echo "Waiting for worker(s) to start"
            sleep 20
    done


    python -u ray_mnist_pytorch.py --use-gpu \
            --cpus-per-trial=4 --gpus-per-trial=1 \
            --num-samples=200 \
            --max-concurrent-trials=32 \
            --resume --logs-dir=${PWD}/logs/${RESUME_JOBID}
            


    # Shutdown workers before the head node
    touch $PWD/shutdown.txt
    sleep 20
    echo " Stopping ray on Head node: $(/bin/hostname)"
    ray stop
    rm $PWD/shutdown.txt


.. code-block::
    :caption: start worker node

    #!/bin/bash
    #SBATCH --job-name=ray_worker
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=1
    #SBATCH --tasks-per-node=1
    #SBATCH --nodes=1
    #SBATCH --cpus-per-task=16
    #SBATCH --time=00:30:00
    #SBATCH --gpus=4
    #SBATCH --reservation=DS-TRAINING

    module load dl
    module load pytorch
    module load ray/2.2.0

    export NUM_CPUS_PER_NODE=${SLURM_CPUS_PER_TASK}
    export NUM_GPUS_PER_NODE=4

    export dashboard_port=9122

    export ip_head=$(cat ./head_node_info | cut -d " " -f 1)
    export head_node_ip=$(echo ${ip_head} | cut -d ":" -f 1)
    export redis_password=$(cat ./head_node_info | cut -d " " -f 2)

    ray start --address ${ip_head}  --redis-password ${redis_password} \
        --num-cpus ${NUM_CPUS_PER_NODE} --num-gpus ${NUM_GPUS_PER_NODE} \
        --block &
    sleep 20
    ray status --address ${ip_head} --redis_password ${redis_password}
    sleep 10

    # worker shutdown strategy
    if [ -f "shutdown.txt" ] ; then
    echo " Stopping ray on Node: $(/bin/hostname)"
    ray stop
    else
    while [ ! -f "shutdown.txt" ]; 
    do
        sleep 20
    done   
    fi



Demo3
------

Python script can be found `here <https://github.com/kaust-rccl/hpo-with-ray/blob/master/demo3/ray_mnist_pytorch_pbt.py>`_

.. code-block::
    :caption: start head node

    #!/bin/bash
    #SBATCH --job-name=ray_head
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=4
    #SBATCH --time=00:30:00
    #SBATCH --reservation=DS-TRAINING
    #SBATCH --gpus=1

    module load dl
    module load pytorch
    module load ray/2.2.0


    #Requested number of workers
    if [ -z ${NUM_WORKERS} ] ; then
    NUM_WORKERS=1
    else
    NUM_WORKERS=${NUM_WORKERS}
    fi



    export server_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export dashboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export tensorboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export node=$(/bin/hostanme -s)
    echo "
    Connect to dashboard by creating SSH tunnels. Copy the following command in a new terminal
    and connect to localhost via your browser.
    ssh -L localhost:${dashboard_port}:${node}:${dashboard_port} -L localhost:${tensorboard_port}:${node}:${tensorboard_port} ${USER}@glogin.ibex.kaust.edu.sa
    "


    export TB_TMPDIR=$PWD/tboard/${SLURM_JOBID}
    mkdir -p ${TB_TMPDIR}

    export redis_password=${SLURM_JOBID}
    export head_node_ip=$(hostname -I | cut -d " " -f 2)
    export ip_head=${head_node_ip}:${server_port}
    echo "${ip_head} ${redis_password} ${dashboard_port}" > head_node_info


    ray start --node-ip-address ${head_node_ip} --port ${server_port} --redis-password=${redis_password} --head  \
        --dashboard-port ${dashboard_port} --dashboard-host=127.0.0.1 \
            --num-cpus 1 --block &
    tensorboard --logdir=${PWD}/logs/${SLURM_JOBID} --port=${tensorboard_port} & 
    sleep 20

    job_ids=()
    for (( i=1; i<=${NUM_WORKERS}; i++ ))
    do
    job_ids[$i]=$(sbatch -x $SLURM_NODELIST worker_node.slurm | cut -d " " -f 4)
    done 

    while [ ! -z $(squeue -n ray_worker -t PD -h -o %A) ]
    do
        echo "Waiting for worker(s) to start"
            sleep 20
    done


    python -u ray_mnist_pytorch_pbt.py --use-gpu \
            --cpus-per-trial=4 --gpus-per-trial=1 \
            --num-samples=100 \
            --max-concurrent-trials=32 
            


    # Shutdown workers before the head node
    touch $PWD/shutdown.txt
    sleep 20
    echo " Stopping ray on Head node: $(/bin/hostname)"
    ray stop
    rm $PWD/shutdown.txt


.. code-block::
    :caption: start worker node

    #!/bin/bash
    #SBATCH --job-name=ray_worker
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=1
    #SBATCH --tasks-per-node=1
    #SBATCH --nodes=1
    #SBATCH --cpus-per-task=16
    #SBATCH --time=00:30:00
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=4
    #SBATCH --reservation=DS-TRAINING

    module load dl
    module load pytorch
    module load ray/2.2.0

    export NUM_CPUS_PER_NODE=${SLURM_CPUS_PER_TASK}
    export NUM_GPUS_PER_NODE=${SLURM_GPUS_PER_NODE}

    export ip_head=$(cat ./head_node_info | cut -d " " -f 1)
    export head_node_ip=$(echo ${ip_head} | cut -d ":" -f 1)
    export redis_password=$(cat ./head_node_info | cut -d " " -f 2)
    export dashboard_port=$(cat ./head_node_info | cut -d " " -f 3)


    ray start --address ${ip_head}  --redis-password ${redis_password} \
        --num-cpus ${NUM_CPUS_PER_NODE} --num-gpus ${NUM_GPUS_PER_NODE} \
        --block &
    sleep 20
    ray status --address ${ip_head} --redis_password ${redis_password}
    sleep 10

    # worker shutdown strategy
    if [ -f "shutdown.txt" ] ; then
    echo " Stopping ray on Node: $(/bin/hostname)"
    ray stop
    else
    while [ ! -f "shutdown.txt" ]; 
    do
        sleep 20
    done   
    fi



Demo4
------

Python script can be found `here <https://github.com/kaust-rccl/hpo-with-ray/blob/master/demo4/ray_mnist_pytorch_wandb.py>`_

.. code-block::
    :caption: Wandb environment setup

    export WANDB_MODE=offline
    export WANDB_DIR=$PWD/logs/${EXPERIMENT}/wandb_runs
    mkdir -p $WANDB_DIR
    export WANDB_RUN_ID=ray_wb_${EXPERIMENT}


.. code-block::
    :caption: start head node

    #!/bin/bash
    #SBATCH --job-name=ray_head_demo4
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=1
    #SBATCH --tasks-per-node=1
    #SBATCH --cpus-per-task=2
    #SBATCH --time=00:30:00
    #SBATCH --reservation=DS-TRAINING
    #SBATCH --gpus=1

    module load dl
    module load pytorch
    module load ray/2.2.0


    #Requested number of workers
    if [ -z ${NUM_WORKERS} ] ; then
    NUM_WORKERS=1
    else
    NUM_WORKERS=${NUM_WORKERS}
    fi



    export server_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export dashboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export tensorboard_port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    export node=$(/bin/hostname -s)
    echo "
    Connect to dashboard by creating SSH tunnels. Copy the following command in a new terminal
    and connect to localhost via your browser.
    ssh -L localhost:${dashboard_port}:${node}:${dashboard_port} -L localhost:${tensorboard_port}:${node}:${tensorboard_port} ${USER}@glogin.ibex.kaust.edu.sa
    "


    export TB_TMPDIR=$PWD/tboard/${SLURM_JOBID}
    mkdir -p ${TB_TMPDIR}

    export redis_password=${SLURM_JOBID}
    export head_node_ip=$(hostname -I | cut -d " " -f 2)
    export ip_head=${head_node_ip}:${server_port}
    echo "${ip_head} ${redis_password} ${dashboard_port}" > head_node_info


    ray start --node-ip-address ${head_node_ip} --port ${server_port} --redis-password=${redis_password} --head  \
        --dashboard-port ${dashboard_port} --dashboard-host=127.0.0.1 \
            --num-cpus 1 --block &
    tensorboard --logdir=${PWD}/logs/${SLURM_JOBID} --port=${tensorboard_port} & 
    sleep 20

    job_ids=()
    for (( i=1; i<=${NUM_WORKERS}; i++ ))
    do
    job_ids[$i]=$(sbatch -x $SLURM_NODELIST worker_node.slurm | cut -d " " -f 4)
    done 

    while [ ! -z $(squeue -n ray_worker_demo4 -t PD -h -o %A) ]
    do
        echo "Waiting for worker(s) to start"
            sleep 20
    done

    source ./wandb_setup.sh
    python -u ray_mnist_pytorch_wandb.py --use-gpu \
            --cpus-per-trial=4 --gpus-per-trial=1 \
            --num-samples=10 \
            --max-concurrent-trials=8

            


    # Shutdown workers before the head node
    touch $PWD/shutdown.txt
    sleep 20
    echo " Stopping ray on Head node: $(/bin/hostname)"
    ray stop
    rm $PWD/shutdown.txt

    echo "Starting to sync offline results to Wandb project cloud project"
    wandb online
    cd logs/${EXPERIMENT}/wandb_runs
    echo "Now in $PWD"
    wandb sync --include-offline --sync-all


.. code-block::
    :caption: start worker node

    #!/bin/bash
    #SBATCH --job-name=ray_worker_demo4
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=1
    #SBATCH --tasks-per-node=1
    #SBATCH --nodes=1
    #SBATCH --cpus-per-task=16
    #SBATCH --time=00:30:00
    #SBATCH --gpus=4
    #SBATCH --gpus-per-node=4
    #SBATCH --reservation=DS-TRAINING

    module load dl
    module load pytorch
    module load ray/2.2.0

    source ./wandb_setup.sh

    export NUM_CPUS_PER_NODE=${SLURM_CPUS_PER_TASK}
    export NUM_GPUS_PER_NODE=${SLURM_GPUS_PER_NODE}


    export ip_head=$(cat ./head_node_info | cut -d " " -f 1)
    export head_node_ip=$(echo ${ip_head} | cut -d ":" -f 1)
    export redis_password=$(cat ./head_node_info | cut -d " " -f 2)
    export dashboard_port=$(cat ./head_node_info | cut -d " " -f 3)


    ray start --address ${ip_head}  --redis-password ${redis_password} \
        --num-cpus ${NUM_CPUS_PER_NODE} --num-gpus ${NUM_GPUS_PER_NODE} \
        --block &
    sleep 20
    ray status --address ${ip_head} --redis_password ${redis_password}
    sleep 10


    # worker shutdown strategy
    if [ -f "shutdown.txt" ] ; then
    echo " Stopping ray on Node: $(/bin/hostname)"
    ray stop
    else
    while [ ! -f "shutdown.txt" ]; 
    do
        sleep 20
    done   
    fi



Shaheen 3 demos
================

Demo1
------

Helloworld example

Python script can be found `here <https://github.com/kaust-rccl/hpo-with-ray/blob/master/shaheen3/demo1/hello_tune.py>`_

.. code-block::
    :caption: start head node and worker node

    #!/bin/bash
    #SBATCH --job-name=ray_tune
    #SBATCH --output=%x-%j.out
    #SBATCH --error=%x-%j.out
    #SBATCH --ntasks=2
    #SBATCH --cpus-per-task=8
    #SBATCH --tasks-per-node=1
    #SBATCH --partition=workq
    #SBATCH --time=00:30:00
    #SBATCH --account=k01

    module load python
    module load pytorch/2.2.1
    module list

    mkdir -p ${SCRATCH_IOPS}/temp/

    export XDG_RUNTIME_DIR=$PWD 
    NUM_CPUS=${SLURM_CPUS_PER_TASK}

    export server_port=9121
    export dashboard_port=9122
    export redis_password=${SLURM_JOBID}


    # Getting the node names
    nodes=$(scontrol show hostnames "$SLURM_JOB_NODELIST")
    nodes_array=($nodes)
    echo "Node IDs of participating nodes ${nodes_array[*]}"

    head_node=${nodes_array[0]}
    export head_node_ip=$(srun  --nodes=1 --ntasks=1  -w "$head_node" /bin/hostname -I | cut -d " " -f 2)


    ## STARTING Ray head node
    export ip_head=$head_node_ip:${server_port}
    echo "IP Head: $ip_head"

    echo "Starting HEAD at $head_node"
    cmd="srun -u -n 1 -N 1 -c ${SLURM_CPUS_PER_TASK} -w ${head_node}  \
        ray start --node-ip-address ${head_node_ip} --port ${server_port} \
                    --redis-password=${redis_password} --head --num-cpus ${NUM_CPUS}  \
                    --dashboard-port ${dashboard_port} --dashboard-host=$HOSTNAME \
                    --temp-dir=${SCRATCH_IOPS}/temp/${SLURM_JOBID} --verbose --block"
    echo $cmd
    $cmd &

    ## STARTING Ray worker nodes

    # optional, though may be useful in certain versions of Ray < 1.0.
    sleep 30

    # number of nodes other than the head node
    worker_num=$((SLURM_JOB_NUM_NODES - 1))

    for ((i = 1; i <= worker_num; i++)); do
        node_i=${nodes_array[$i]}
        echo "Starting WORKER $i at $node_i"
        cmd="srun -u -w "$node_i" -n 1 -N 1 -c ${NUM_CPUS}  \
            ray start --address "$ip_head" --redis-password=${redis_password} \
                        --num-cpus ${NUM_CPUS}  \
                --temp-dir=${SCRATCH_IOPS}/temp/${SLURM_JOBID} --verbose --block"
        echo $cmd
        $cmd &
        
        sleep 40
    done

    ## SUBMIT workload to the Ray cluster
    ray status --address ${ip_head} --redis_password ${redis_password} 
    sleep 40
    python -u hello_tune.py --num-samples=10 --max-concurrent-trials=4
    exit 0


 