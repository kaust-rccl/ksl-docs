Compiler suites
===============

Introduction
------------

Compiler suites are collections of compilers and tools that enable you to compile, optimize, and build software applications. 

Each compiler suite brings its own set of features, optimizations, and compatibility considerations.

Understanding and utilizing different compiler suites can significantly impact the performance and efficiency of your code on the cluster.

Available Compiler Suites
-------------------------

Ibex provides multiple compiler suites, each catering to different programming languages and optimization goals.

Some common compiler suites you might encounter include:

- GCC (GNU Compiler Collection): A popular open-source compiler suite that supports multiple programming languages, including C, C++, and Fortran.

- Intel Compiler Suite: Developed by Intel, this suite offers advanced optimizations and features tailored for Intel processors.

- PGI : A suite optimized for high-performance computing and parallel programming, offering Fortran, C, and C++ compilers.

- NVIDIA HPC SDK: Designed for GPU-accelerated computing, this suite provides compilers and libraries for CUDA programming.

Selecting a Compiler Suite
--------------------------

Choosing the right compiler suite depends on factors such as:

- Your programming language (C, C++, Fortran, CUDA, etc.).
- Compatibility with your application's dependencies and libraries.
- Target hardware architecture (CPU, GPU, etc.).
- Desired performance optimizations (vectorization, parallelization, etc.).
- Available features and debugging tools.

It's often beneficial to experiment with different compiler suites and optimizations to find the best performance for your specific use case.

Loading Compiler Suites as Modules
-----------------------------------

On most HPC clusters, compiler suites are managed using the module system. To load a specific compiler suite, use:

.. code-block:: bash

    module load compiler-suite-name

For example, to load the GCC compiler suite, use:

.. code-block:: bash

    module load gcc

A compiler can have multiple versions installed on the system. To query which version are availble e.g. cuda version installed on Ibex:

.. code-block:: bash

    moudle avail cuda

Utilizing Optimizations
-----------------------

Compiler suites offer a range of optimizations to enhance code performance. These optimizations include:

- Loop vectorization: Utilizing vector instructions for parallel processing.
- Auto-parallelization: Automatically parallelizing loops for multi-core processors.
- Optimization levels: Adjusting the optimization trade-offs between execution speed and compilation time.

Compile-time Flags
------------------

Users can fine-tune compilation options using flags. For instance:

.. code-block:: bash

    gcc -O3 -march=native -o my_program my_program.c

This compiles "my_program.c" with high optimization (``-O3``) and architecture-specific settings (``-march=native``). 

``-march=native`` pools together a set of complier flags which targets the host architucture.
It is advised that users compile such optimizations on the target comput node either in an interactive job or a batch job. 

A detailed list of compiler options can be explored in manpages of the said compilers e.g. for gcc, ``man gcc`` with the desired module version loaded. 

Additional Resources
--------------------

- `GCC Compiler Documentation <https://gcc.gnu.org/onlinedocs/>`_
- `Intel Compiler Documentation <https://software.intel.com/content/www/us/en/develop/documentation/fortran-compiler-oneapi-dev-guide-and-reference/top.html>`_
- `PGI Compiler Documentation <https://docs.nvidia.com/hpc-sdk/pgi-compilers/>`_
- `NVIDIA HPC SDK Documentation <https://docs.nvidia.com/hpc-sdk/archive/>`_
