CPU/GPU and Parallel Libraries
===============================

Introduction
------------

Ibex provides a wide range of specialized libraries that enable developers to accelerate their applications, leverage hardware capabilities, and achieve optimal performance.

CPU/GPU Libraries
-----------------

HPC clusters often offer a variety of libraries optimized for specific hardware architectures, such as CPUs and GPUs. Some of the common CPU/GPU libraries include:

- BLAS (Basic Linear Algebra Subprograms): A library for linear algebra operations like matrix multiplications and vector operations.

- cuBLAS: A GPU-accelerated version of BLAS, designed for NVIDIA GPUs and CUDA programming.

- FFTW (Fastest Fourier Transform in the West): A library for computing discrete Fourier transforms efficiently.

- cuFFT: The GPU-accelerated counterpart of FFTW, optimized for CUDA programming.

- LAPACK (Linear Algebra PACKage): A library for solving linear systems, eigenvalue problems, and singular value decomposition.

Parallel Libraries
------------------

Parallel libraries enable developers to efficiently distribute tasks across multiple processing units, such as CPU cores or GPUs, to achieve improved performance. Some widely used parallel libraries include:

- OpenMP (Open Multi-Processing): A popular API for shared-memory parallel programming, commonly used to parallelize loops and sections of code.

- MPI (Message Passing Interface): A standard for distributed-memory parallel programming, enabling communication and synchronization between processes.

- CUDA: A parallel computing platform and programming model for NVIDIA GPUs, allowing developers to leverage the power of parallel processing.

- OpenACC: A directive-based approach to parallel programming, designed for GPU acceleration of CPU-bound applications.

Loading Libraries as Modules
-----------------------------

To use these libraries, you can load them as modules using the module system:

.. code-block:: bash

    module load library-name

For example, to load the CUDA library, use:

.. code-block:: bash

    module load cuda

Parallel Programming with Libraries
-----------------------------------

On Ibex there various version of **OpenMPI**, **MPICH**, and **CUDA** are installed for users to compile with. 

Loading the modules for these libraries updates the environments so that build tools such as ``cmake`` or ``autoconf`` can discover their existence.
If the discovery failes, preset environment variables can be used to point to the installation paths of these libraries. For example, for an MPI code to compiled:

.. code-block:: bash

    module load openmpi
    module load gcc

    mpicc -c my_app.c -I${OPENMPI_HOME}/include 
    mpicc -o my_app my_app.o -L${OPENMPI_HOME}/lib -lmpi

The above code compiles and links the ``openmpi`` library and make availabe the compiler headers needed by the soure code during the process. 
Once compiled, the executable ``my_app`` can be launched in a SLURM batch script either with ``mpirun`` or ``srun``, the later is recomended.

For source codes requiring **CUDA Toolkit** for compiling NVIDIA GPU enabled binaries, load the ``cuda`` module and use the ``nvcc`` compiler to build the device code.
It is recomended to allocate a GPU node and compile your source either as interactive session or in batch jobscript. 

.. code-block:: bash

    srun --gpus=1 --time==0:10:0 --pty bash
    module load cuda
    module load gcc

    nvcc -c device_code.cu -I${CUDATOOLKIT_HOME}/include
    gcc -o my_gpu_app device_code.o -L${CUDATOOLKIT_HOME}/lib -lcudart -lcublas 


When building your CUDA code on login node and the intent is the it runs on multiple NVIDIA GPU microarchitectures, the following ``nvcc`` flags will help:

.. code-block:: bash
    
    module load cuda
    
    nvcc -c device_code.cu -I${CUDATOOLKIT_HOME}/include \
    -gencode=arch=compute_80,code=sm_80 \
    -gencode=arch=compute_75,code=compute_75 \
    -gencode=arch=compute_70,code=compute_70 \
    -gencode=arch=compute_61,code=compute_61  

     gcc -o my_gpu_app device_code.o -L${CUDATOOLKIT_HOME}/lib -lcudart -lcublas 





Additional Resources
---------------------

- `BLAS Library Documentation <http://www.netlib.org/blas/>`_
- `cuBLAS Library Documentation <https://docs.nvidia.com/cuda/cublas/index.html>`_
- `FFTW Library Documentation <https://www.fftw.org/#documentation>`_
- `cuFFT Library Documentation <https://docs.nvidia.com/cuda/cufft/index.html>`_
- `LAPACK Library Documentation <http://www.netlib.org/lapack/>`_
- `OpenMP Documentation <https://www.openmp.org/resources/>`_
- `MPI Documentation <https://www.mpi-forum.org/docs/>`_
- `CUDA Documentation <https://docs.nvidia.com/cuda/>`_
- `OpenACC Documentation <https://www.openacc.org/resources/>`_