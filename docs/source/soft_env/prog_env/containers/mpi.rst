.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: mpi container examples
    :keywords: krccl, container, mpi

.. _mpi_container_example:

==============================================
Singularity MPI containers on Shaheen and Ibex
==============================================

On this page we demonstrate how to run a containerized MPI application with singularity container platform on Shaheen and Ibex. Both KSL system are different in supporting the MPI environment. 

Shaheen
=======

Shaheen has MPICH compatible :code:`cray-mpich` installed which leverages the advanced features of :code:`cray-arise` interconnect. For corner cases we have also installed :code:`openmpi-4.x` on Shaheen compute nodes.

MPICH container
---------------

Here is an example to launch an image with MPICH on Shaheen. :code:`srun` launches two MPI processes on two Shaheen compute nodes:

.. code-block:: bash

    #!/bin/bash 
    #SBATCH -p haswell
    #SBATCH -N 2
    #SBATCH -n 4
    #SBATCH -t 00:05:00

    module load singularity/3.5.1

    export IMAGE=mpich_psc_latest.sif
    BIND="-B /opt,/var,/usr/lib64,/etc,/sw"
    srun  -n 2 -N 2 --mpi=pmi2 singularity exec ${BIND} ${IMAGE} /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

OpenMPI container
-----------------

The following is an example to run an image with :code:`openmpi` to launch an MPI job. Here we bind mount the host OpenMPI. We use :code:`mpirun` to launch the jobs because of the unavailability of :code:`pmix` integration of :code:`SLURM` on host.

.. code-block:: bash

    #!/bin/bash 
    #SBATCH -p haswell
    #SBATCH -N 2
    #SBATCH -n 4
    #SBATCH -t 00:05:00

    module swap PrgEnv-$(echo $PE_ENV | tr [:upper:] [:lower:]) PrgEnv-gnu
    module load openmpi/4.0.3
    module load singularity


    export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
    export SINGULARITYENV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cray/wlm_detect/default/lib64:/etc/alternatives:/usr/lib64:/usr/lib
    export SINGULARITENV_APPEND_PATH=$PATH

    export IMAGE=/project/k01/shaima0d/singularity_test/images/openmpi401_latest.sif
    export BIND_MOUNT="-B /sw,/usr/lib64,/opt,/etc,/var"

    echo "On same node"
    mpirun -n 2 -N 2 hostname
    mpirun -n 2 -N 2 singularity exec ${BIND_MOUNT} ${IMAGE} /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

    echo "Now trying inside a singularity container"
    mpirun -n 2 -N 1 hostname
    mpirun -n 2 -N 1 singularity exec ${BIND_MOUNT} ${IMAGE} /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency 

IBEX
====

CPU job
-------

On Ibex :code:`openmpi` is installed on host. It is generally suited to launch the :code:`singularity` MPI jobs with :code:`mpirun` due to the unavailability of :code:`pmix` integration of :code:`SLURM` on host. 

.. code-block:: bash

    #!/bin/bash 
    #SBATCH --ntasks=4
    #SBATCH --nodes=2
    #SBATCH --gres=gpu:v100:2
    #SBATCH --time=00:05:00

    module load singularity
    module load openmpi/4.0.3-cuda10.2
    module list

    export OMPI_MCA_btl=openib
    export OMPI_MCA_btl_openib_allow_ib=1
    export IMAGE=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/images/osu_cuda_openmpi403_563.sif

    export EXE_lat=/usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
    export EXE_bw=/usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw


    echo "On same node"
    mpirun -n 2 --map-by ppr:2:node hostname
    mpirun -n 2 --map-by ppr:2:node singularity exec ${IMAGE} ${EXE_lat}
    mpirun -n 2 --map-by ppr:2:node singularity exec --nv ${IMAGE} ${EXE_bw}



    echo "On two nodes"
    mpirun -n 2 --map-by ppr:1:node hostname
    mpirun -n 2 --map-by ppr:1:node singularity exec ${IMAGE} ${EXE_lat}
    mpirun -n 2 --map-by ppr:1:node singularity exec ${IMAGE} ${EXE_bw}

GPU job
-------

The following SLURM jobscript demonstrates run a container with MPI application running on Ibex GPUs leveraging GPU Direct RDMA feature to get close to maximum theoretical bandwidth available from a Host Channel Adapter(HCA).

.. code-block:: bash

    #!/bin/bash 
    #SBATCH --ntasks=4
    #SBATCH --ntasks-per-node=2
    #SBATCH --gres=gpu:v100:2
    #SBATCH --time=00:05:00

    module load singularity
    module load openmpi/4.0.3-cuda10.2
    module list

    export OMPI_MCA_btl=openib
    export OMPI_MCA_btl_openib_allow_ib=1
    export IMAGE=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/images/osu_cuda_openmpi403_563.sif

    export EXE_lat=/usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
    export EXE_bw=/usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw


    echo "On same node"
    mpirun -n 2 --map-by ppr:2:node hostname
    mpirun -n 2 --map-by ppr:2:node singularity exec --nv ${IMAGE} ${EXE_lat} D D
    mpirun -n 2 --map-by ppr:2:node singularity exec --nv ${IMAGE} ${EXE_bw} D D



    echo "On two nodes"
    mpirun -n 2 --map-by ppr:1:node hostname
    mpirun -n 2 --map-by ppr:1:node singularity exec --nv ${IMAGE} ${EXE_lat} D D
    mpirun -n 2 --map-by ppr:1:node singularity exec --nv ${IMAGE} ${EXE_bw} D D