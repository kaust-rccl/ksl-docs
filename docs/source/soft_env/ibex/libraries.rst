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

Once you have the required libraries loaded, you can parallelize your code using the appropriate APIs and directives provided by the libraries.

For example, you can use OpenMP directives to parallelize loops or use MPI to distribute tasks across multiple nodes.

Utilizing CPU/GPU libraries and parallel libraries is essential for achieving maximum performance and efficiency in HPC applications.

By leveraging these libraries, you can harness the computational power of CPUs and GPUs, as well as achieve effective parallelization to take full advantage of the resources available on the cluster.

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