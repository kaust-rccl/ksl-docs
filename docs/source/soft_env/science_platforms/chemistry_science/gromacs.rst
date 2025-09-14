.. sectionauthor:: Mohamed Elgharawy <mohamed.elgharawy@kaust.edu.sa>
.. meta::
    :description: Using Gromacs on Ibex GPUs
    :keywords: Gromacs, Chemistry

====================================
Using Gromacs on Ibex GPUs
====================================

Building image from Dockerfile
================================

The image is available on Krccl DockerHub, you can pull it on ibex with the commands:

.. code-block:: bash

    module load singularity
    singularity pull gromacs_latest.sif docker://krccl/gromacs:latest

For any modifications, you can rebuild it locally with docker using following Dockerfile and push to your DockerHub.
Then, pull it on Ibex using singularity.

.. code-block:: bash

    # Use NVIDIA CUDA base image with cuDNN
    FROM nvcr.io/nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

    # Avoid interactive prompts
    ENV DEBIAN_FRONTEND=noninteractive

    # Fix permission issue in singularity
    RUN chmod 1777 /tmp

    # Update and install dependencies
    RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        wget \
        curl \
        git \
        vim \
        libssl-dev \
        software-properties-common \
        ca-certificates \
        && rm -rf /var/lib/apt/lists/*

    #Install MLNX_OFED
    RUN wget https://content.mellanox.com/ofed/MLNX_OFED-24.10-0.7.0.0/MLNX_OFED_LINUX-24.10-0.7.0.0-ubuntu22.04-x86_64.tgz
    RUN tar xfz MLNX_OFED_LINUX-24.10-0.7.0.0-ubuntu22.04-x86_64.tgz
    RUN echo "deb file:/MLNX_OFED_LINUX-24.10-0.7.0.0-ubuntu22.04-x86_64/DEBS/ ./" > /etc/apt/sources.list.d/mlnx_ofed.list
    RUN curl -L http://www.mellanox.com/downloads/ofed/RPM-GPG-KEY-Mellanox | apt-key add -
    RUN apt-get update
    RUN apt-get install -y mlnx-ofed-basic-user-only



    # Install CMake
    RUN wget https://github.com/Kitware/CMake/releases/download/v4.1.0/cmake-4.1.0.tar.gz
    RUN tar xfz cmake-4.1.0.tar.gz
    WORKDIR /cmake-4.1.0
    RUN bash bootstrap
    RUN gmake
    RUN make install
    WORKDIR /

    #Install Gfortran
    RUN apt-get update && apt-get install -y --no-install-recommends gfortran \
        && rm -rf /var/lib/apt/lists/*

    # Build OpenMPI
    RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.gz && \
        tar xfz openmpi-4.1.4.tar.gz && cd openmpi-4.1.4 && \
        ./configure --prefix=/usr/local \
            --with-verbs \
            --with-cuda \
            --enable-mpi-fortran=all \
            --enable-mpirun-prefix-by-default && \
        make -j$(nproc) && make install && ldconfig && \
        cd / && rm -rf /tmp/openmpi-4.1.4*


    # Build Gromacs
    RUN wget https://ftp.gromacs.org/gromacs/gromacs-2025.2.tar.gz
    RUN tar xfz /gromacs-2025.2.tar.gz
    WORKDIR /gromacs-2025.2
    RUN mkdir build
    WORKDIR /gromacs-2025.2/build
    RUN cmake /gromacs-2025.2 -DGMX_GPU=CUDA -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda -DGMX_GPU_FFT_LIBRARY=cufft -DGMX_MPI=ON -DGMX_BUILD_OWN_FFTW=ON
    RUN make
    # RUN make check
    RUN make install

    # Default workdir
    WORKDIR /workspace

    # Entrypoint script
    COPY entrypoint.sh /workspace/entrypoint.sh
    RUN chmod +x /workspace/entrypoint.sh
    ENTRYPOINT ["/workspace/entrypoint.sh"]


Create the following entrypoint script loacally in same directory as Dockerfile.

.. code-block:: bash

    #!/bin/bash
    source /usr/local/gromacs/bin/GMXRC
    exec "$@"


Single node example
=======================

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name="gromacs_gpu"
    #SBATCH --ntasks=2
    #SBATCH --ntasks-per-node=2
    #SBATCH --output=%J.out
    #SBATCH --error=%J.err
    #SBATCH --time=0:10:0
    #SBATCH --gpus=2
    #SBATCH --cpus-per-task=16
    #SBATCH --mem=80G
    #----------------------------------------------------------#
    module load singularity
    module load openmpi/4.1.4/gnu11.2.1-cuda11.8
    #----------------------------------------------------------#
    echo "The job "${SLURM_JOB_ID}" is running on "${SLURM_JOB_NODELIST}
    #----------------------------------------------------------#
    export GMX_ENABLE_DIRECT_GPU_COMM=1
    export GMX_GPU_PME_DECOMPOSITION=1
    #----------------------------------------------------------#

    mpirun -np 2 singularity run --nv -B /ibex/user/$USER gromacs_latest.sif gmx_mpi mdrun -deffnm topol -s topol.tpr -nb gpu -pme gpu -npme 1 -update gpu -bonded gpu -nsteps 100000 -resetstep 90000 -noconfout -dlb no -nstlist 300 -pin on


Multi node example
=====================

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name="gromacs_gpu"
    #SBATCH --ntasks=2
    #SBATCH --ntasks-per-node=1
    #SBATCH --output=%J.out
    #SBATCH --error=%J.err
    #SBATCH --time=0:10:0
    #SBATCH --gpus=2
    #SBATCH --cpus-per-task=16
    #SBATCH --mem=80G
    #----------------------------------------------------------#
    module load singularity
    module load openmpi/4.1.4/gnu11.2.1-cuda11.8
    #----------------------------------------------------------#
    echo "The job "${SLURM_JOB_ID}" is running on "${SLURM_JOB_NODELIST}
    #----------------------------------------------------------#
    export GMX_ENABLE_DIRECT_GPU_COMM=1
    export GMX_GPU_PME_DECOMPOSITION=1
    #----------------------------------------------------------#

    mpirun -np 2 singularity run --nv -B /ibex/user/$USER gromacs_latest.sif gmx_mpi mdrun -deffnm topol -s topol.tpr -nb gpu -pme gpu -npme 1 -update gpu -bonded gpu -nsteps 100000 -resetstep 90000 -noconfout -dlb no -nstlist 300 -pin on