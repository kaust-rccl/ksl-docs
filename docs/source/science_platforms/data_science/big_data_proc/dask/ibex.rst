.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Dask
    :keywords: dask, dask_mpi, dask_array, xarray

.. _dask_on_ibex:

==========================================
Dask on Ibex
==========================================

Accessing Dask on Ibex
======================
Dask on Ibex can be accessed in multiple ways. You can either use the system installed dask by loading a modulefile or create your own python environment to manage yourself without KSL staffs' assistance.

Dask from modulefile
---------------------

On Ibex you can install dask in your own directory or opt to use the pre-installed module. 

To use dask from the pre-installed module, you can do the following:

.. code-block::

    module load dl
    module load dask

How to Install your own
------------------------
Users can either install in a conda environment or via pip  in there own directories whether ``/home`` or ``/ibex/user/$USER``. 

Using conda package
--------------------
Here we assume that you have installed miniconda in your /home directory on Ibex. Installation instructions can be found on this GitHub page

While in you base environment create a new conda environment:

.. code-block::

    conda create -n dask python=3.7
    conda activate dask

Once ready, you can install via pip installer:

.. code-block::
    pip install --no-cache-dir dask[complete] dask-mpi dask-jobqueue dask-ml jupyter notebook jupyter_server jupyter_tensorboard ipyparallel

This will bring the whole kitchen sinks. It includes dask-core, dask-distributed, dask-mpi launcher, and dask-jobqueue for high throughput task farm, amongst other things.

Using pip to install
----------------------
If you don’t use conda package management and depend on the system installed python modules, you can install via pip.

.. code-block::
    module load python

    export INSTALL_DIR=/ibex/scratch/shaima0d/dask
    pip install --no-cache-dir --ignore-installed \
    --prefix=${INSTALL_DIR} dask[complete] dask-mpi dask-jobqueue dask-ml jupyter jupyter_server jupyter_tensorboard ipyparallel

The above should install all the dependencies in the prescribed install directory referenced by the --prefix flag. 
Once installed, you will need to maintain some environment variables to enable your runtime to find dask and related executables.

.. code-block::
    
    export PYTHONPATH=${INSTALL_DIR}/lib/python3.7/site-packages:$PYTHONPATH
    export PATH=${INSTALL_DIR}/bin:$PATH
 
This should allow you to find both dask python modules and ``dask-mpi`` etc.

.. code-block::

    -bash-4.2$ python
    Python 3.7.0 (default, Oct 29 2019, 12:43:29) 
    [GCC 6.4.0] on linux
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import dask
    >>> dask.__version__
    '2021.09.1'
    >>> import numpy as np
    >>> np.__version__
    '1.21.2'
    >>> np.__file__
    '/ibex/user/$USER/dask/lib/python3.7/site-packages/numpy/__init__.py'

In the above you can see that even though we are using python from Ibex modulefile, we are loading dask and related dependencies e.g. numpy from INSTALL_DIR.

 

For dask-mpi which depends on mpi4py we recommend installing it with openmpi/4.0.3 modulefile loaded in the environment from Ibex. It has all the middleware integration e.g. Mellanox drivers and UCX. The following step applies to both conda and non-conda build. If using conda environment, we assume you already have loaded the right environment:



module load openmpi/4.0.3
env MPICC=$(which mpicc) mpi4py==3.0.1
 

 

Running Dask on Ibex
Dask can be run in a jupyter notebook. The following is an example of how to start a dask-distributed cluster and connect to it from a notebook.



#!/bin/bash -l
#SBATCH --ntasks=3
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=01:00:00
#SBATCH --account=ibex-cs

module load dl
module load gcc/11.1.0
module load dask
module list

mkdir workers${SLURM_JOBID}


# get tunneling info
export XDG_RUNTIME_DIR=""
node=$(hostname -I  | cut -d ' ' -f 2)
user=$(whoami)
submit_host=${SLURM_SUBMIT_HOST}
sched_port=10021
jupyter_port=10022
dask_dashboard=10023

srun -n ${SLURM_NTASKS} -c ${SLURM_CPUS_PER_TASK} dask-mpi --worker-class distributed.Worker --local-directory=workers${SLURM_JOBID} --interface=ib0 --nthreads=${SLURM_CPUS_PER_TASK} --scheduler-port=${sched_port} \
    --scheduler-file=scheduler_${SLURM_JOBID}.json --dashboard-address=${node}:${dask_dashboard} &

sleep 20


echo $node pinned to port $port
# print tunneling instructions jupyter-log
echo -e "
To connect to the compute node ${node} on IBEX running your jupyter notebook server,
you need to run following two commands in a terminal

1. Command to create ssh tunnel from you workstation/laptop to cs-login:
ssh -L ${jupyter_port}:${node}:${jupyter_port} -L ${dask_dashboard}:${node}:${dask_dashboard} ${user}@${submit_host}.ibex.kaust.edu.sa


Copy the link provided below by jupyter-server and replace the NODENAME with localhost before pasting it in your browser on your workstation/laptop

use localhost:${dask_dashboard} to view dask dashboard
"

jupyter lab  --no-browser --port=${jupyter_port} --ip=${node}
For the rest of the example please refer to Using Dask on Shaheen example details.