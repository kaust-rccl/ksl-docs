Container runtime examples
==========================

Gromacs (CPU) - Jobscript (Ibex) 
----------------------------------------------------------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name="gromacs"
    #SBATCH --ntasks=32
    #SBATCH --tasks-per-node=32
    #SBATCH --time=4:00:00
    #----------------------------------------------------------#
    module load singularity openmpi
    export OMPI_MCA_btl=openib
    export OMPI_MCA_btl_openib_allow_ib=1
    export SINGUALRITYENV_GROMACS_USE=""
    export SINGULARITYENV_OMP_NUM_THREADS=1
    export IMAGE=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/images/gromacs_cpu_latest.sif
    export GROMACS_HOME=/usr/local/gromacs
    ............
    ............ 
    # Step Six: Equilibration
    mpirun -np 1 singularity exec ${IMAGE} ${GROMACS_HOME}/bin/gmx_mpi grompp -f nvt.mdp -c em.gro -r 
    em.gro -p topol.top -o nvt.tpr
    mpirun -np 32 singularity exec ${IMAGE} ${GROMACS_HOME}/bin/gmx_mpi mdrun -deffnm nvt

Gromacs (Multi CPU) - Jobscript (Ibex) 
----------------------------------------------------------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name="gromacs"
    #SBATCH --ntasks=32
    #SBATCH --tasks-per-node=16
    #SBATCH --time=4:00:00
    #----------------------------------------------------------#
    module load singularity openmpi
    export OMPI_MCA_btl=openib
    export OMPI_MCA_btl_openib_allow_ib=1
    export SINGUALRITYENV_GROMACS_USE=""
    export SINGULARITYENV_OMP_NUM_THREADS=1
    export IMAGE=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/images/gromacs_cpu_latest.sif
    export GROMACS_HOME=/usr/local/gromacs
    ............
    ............ 
    # Step Six: Equilibration
    mpirun -np 1 singularity exec ${IMAGE} ${GROMACS_HOME}/bin/gmx_mpi grompp -f nvt.mdp -c em.gro -r 
    em.gro -p topol.top -o nvt.tpr
    mpirun -np 32 singularity exec ${IMAGE} ${GROMACS_HOME}/bin/gmx_mpi mdrun -deffnm nvt

Gromacs (CPU) - Jobscript (Shaheen)
-----------------------------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name="gromacs"
    #SBATCH --ntasks=32
    #SBATCH --time=4:00:00
    #----------------------------------------------------------#
    module swap PrgEnv-cray PrgEnv-gnu
    module load openmpi
    module load singularity
    #----------------------------------------------------------#
    export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
    export SINGULARITYENV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cray/………………………:/usr/lib
    export SINGULARITYENV_APPEND_PATH=$PATH
    export BIND_MOUNT="-B /sw,/usr/lib64,/opt,/etc"
    export SINGUALRITYENV_GROMACS_USE=""
    export SINGULARITYENV_OMP_NUM_THREADS=1
    export IMAGE=/project/k01/shaima0d/singularity_test/images/gromacs_cpu_latest.sif
    export GROMACS_HOME=/usr/local/gromacs
    ............
    ............ 
    # Step Six: Equilibration
    mpirun -np 1 singularity exec ${BIND_MOUNT} ${IMAGE} ${GROMACS_HOME}/bin/gmx_mpi grompp -f nvt.mdp -c 
    em.gro -r em.gro -p topol.top -o nvt.tpr
    mpirun -np 32 singularity exec ${BIND_MOUNT} ${IMAGE} ${GROMACS_HOME}/bin/gmx_mpi mdrun -deffnm nvt

Gromacs (Multi CPU) - Jobscript (Shaheen)
-----------------------------------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name="gromacs"
    #SBATCH --ntasks=32
    #SBATCH --tasks-per-node=16
    #SBATCH --time=4:00:00
    #----------------------------------------------------------#
    module swap PrgEnv-cray PrgEnv-gnu
    module load openmpi
    module load singularity
    #----------------------------------------------------------#
    export LD_LIBRARY_PATH=$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH
    export SINGULARITYENV_LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cray/………………………:/usr/lib
    export SINGULARITYENV_APPEND_PATH=$PATH
    export BIND_MOUNT="-B /sw,/usr/lib64,/opt,/etc"
    export SINGUALRITYENV_GROMACS_USE=""
    export SINGULARITYENV_OMP_NUM_THREADS=1
    export IMAGE=/project/k01/shaima0d/singularity_test/images/gromacs_cpu_latest.sif
    export GROMACS_HOME=/usr/local/gromacs
    ............
    ............ 
    # Step Six: Equilibration
    mpirun -np 1 singularity exec ${BIND_MOUNT} ${IMAGE} ${GROMACS_HOME}/bin/gmx_mpi grompp -f nvt.mdp -c 
    em.gro -r em.gro -p topol.top -o nvt.tpr
    mpirun -np 32 singularity exec ${BIND_MOUNT} ${IMAGE} ${GROMACS_HOME}/bin/gmx_mpi mdrun -deffnm nvt

DL training on Ibex GPUs - Jobscript Single GPU
-----------------------------------------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --gres=gpu:1
    #SBATCH --constraint=v100
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=6
    #SBATCH --mem=64G
    #SBATCH --time=00:30:00
    module load openmpi
    module load singularity
    export IMAGE=horovod_gpu_0192.sif
    echo "PyTorch with Horovod”
    mpirun -np 1 singularity exec --nv $IMAGE python ./pytorch_synthetic_benchmark.py --model 
    resnet50 --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10

DL training on Ibex GPUs - Jobscript Multi-GPU on same node
-----------------------------------------------------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --gres=gpu:8
    #SBATCH --constraint=v100
    #SBATCH --ntasks=8
    #SBATCH --tasks-per-node=8
    #SBATCH --cpus-per-task=6
    #SBATCH --mem=64G
    #SBATCH --time=00:30:00
    module load openmpi
    module load singularity
    export IMAGE=horovod_gpu_0192.sif
    echo "PyTorch with Horovod"
    mpirun -np 8 singularity exec --nv $IMAGE python ./pytorch_synthetic_benchmark.py --model 
    resnet50 --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10

DL training on Ibex GPUs - Jobscript Multi-GPUs on multi node
-------------------------------------------------------------

.. code-block:: bash

    #!/bin/bash
    #SBATCH --gres=gpu:8
    #SBATCH --constraint=v100
    #SBATCH --ntasks=8
    #SBATCH --tasks-per-node=4
    #SBATCH --cpus-per-task=6
    #SBATCH --mem=64G
    #SBATCH --time=00:30:00
    module load openmpi
    module load singularity
    export IMAGE=horovod_gpu_0192.sif
    echo "PyTorch with Horovod"
    mpirun -np 8 -N 4 singularity exec --nv $IMAGE python ./pytorch_synthetic_benchmark.py --model 
    resnet50 --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10

Horovod container
-----------------

KAUST Supercomputing Lab maintains a docker image with Horovod/0.19.2. If you wish to modify the image, here is the `Dockerfile <https://github.com/kaust-rccl/singularity_workshop2020/blob/master/horovod/Dockerfile.gpu>`_ you can use to recreate an image with desired modification (download Mellanox OFED tarball MLNX_OFED_LINUX-5.0-2.1.8.0-ubuntu18.04-x86_64.tgz) On Ibex you can use this image to run a container with Singularity platform.

Here is an example:

On the glogin node you can pull the image from DockerHub:

.. code-block:: bash 

    module load singularity
    cd $HOME
    export SINGULARITY_TMPDIR=$HOME
    singularity pull docker://krccl/horovod_gpu:0192

Once you end up pulling the image successfully, singularity will convert it into a Singularity Image File or SIF , which is a monolithic and static binary file (you can copy it in /ibex/scratch if you wish).

Here is an example Jobscript launching a horovod training job as singularity container:

Single node single GPU
~~~~~~~~~~~~~~~~~~~~~~

You may possibly want to run a single GPU job for debugging:

.. code-block:: bash 

    #!/bin/bash
    #SBATCH --gpus=1
    #SBATCH --gpus-per-node=1
    #SBATCH --constraint=v100
    #SBATCH --ntasks=1
    #SBATCH --cpus-per-task=4
    #SBATCH --mem=64G
    #SBATCH --time=00:30:00

    module load openmpi
    module load singularity

    export IMAGE=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/images/horovod_gpu_0192.sif

    echo "PyTorch with Horovod"
    mpirun -np 1  singularity exec --nv $IMAGE python ./pytorch_synthetic_benchmark.py --model resnet50 --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10 >>pytorch_1GPU.log

    echo "Tensorflow2 with Horovod"
    mpirun -np 1  singularity exec --nv $IMAGE python ./tensorflow2_synthetic_benchmark.py --model ResNet50  --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10 >> TF2_1GPU.log

Single node Multi GPU
~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash 

    #!/bin/bash
    #SBATCH --gpus=8
    #SBATCH --gpus-per-node=8
    #SBATCH --constraint=v100
    #SBATCH --ntasks=8
    #SBATCH --cpus-per-task=4
    #SBATCH --mem=64G
    #SBATCH --time=00:30:00

    module load openmpi
    module load singularity

    export IMAGE=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/images/horovod_gpu_0192.sif

    echo "PyTorch with Horovod"
    mpirun -np 8  singularity exec --nv $IMAGE python ./pytorch_synthetic_benchmark.py --model resnet50 --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10 >>pytorch_1node.log

    echo "Tensorflow2 with Horovod"
    mpirun -np 8  singularity exec --nv $IMAGE python ./tensorflow2_synthetic_benchmark.py --model ResNet50  --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10 >> TF2_1node.log

Multi-node Multi-gpu
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash 

    #!/bin/bash
    #SBATCH --gpus=8
    #SBATCH --gpus-per-node=4
    #SBATCH --constraint=v100
    #SBATCH --ntasks=8
    #SBATCH --cpus-per-task=4
    #SBATCH --mem=64G
    #SBATCH --time=00:30:00

    module load openmpi
    module load singularity

    export IMAGE=/ibex/scratch/shaima0d/scratch/singularity_mpi_testing/images/horovod_gpu_0192.sif

    echo "PyTorch with Horovod"
    mpirun -np 8 -N 4 singularity exec --nv $IMAGE python ./pytorch_synthetic_benchmark.py --model resnet50 --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10 >>pytorch_multiGPU.log

    echo "Tensorflow2 with Horovod"
    mpirun -np 8 -N 4 singularity exec --nv $IMAGE python ./tensorflow2_synthetic_benchmark.py --model ResNet50  --batch-size 128 --num-warmup-batches 10 --num-batches-per-iter 10 --num-iters 10 >> TF2_multiGPU.log

