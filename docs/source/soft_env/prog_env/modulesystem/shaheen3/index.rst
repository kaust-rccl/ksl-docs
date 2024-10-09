.. sectionauthor:: Kadir Akbudak <kadir.akbudak@kaust.edu.sa>
.. meta::
    :description: Applications catalogue on KSL systems
    :keywords: Install software, Shaheen, Ibex


=============
Shaheen III
=============

Users can benefit from many software packages and scientific libraries available as modules. Users can also compile their source code using various compiler toolchains in the Cray Programming Environment.


Environment Modules
=====================

Before requesting the installation of new packages or
libraries, please check if the desired package is already
installed on the system.

* To find the list of all the packages installed:

.. code-block:: bash

 module avail

* To find a specific package:

.. code-block:: bash

 module avail -S name

* To get information on the package usage:

.. code-block:: bash

 module help <package-name>
 module show <package-name>

* To display Cray Scientific Libraries:

.. code-block:: bash

 module avail –L

* To load a module:

.. code-block:: bash

 module load <package-name>

.. toctree::
   :maxdepth: 1
   :titlesonly:


Compiler Toolchains
====================

Cray, AMD, and GCC compiler toolchains are provided through modules.
The module ``PrgEnv-<compiler>`` is used to activate the respective toolchain.
Regardless of the underlying compiler, the user must use the compiler wrappers ``cc``, ``CC``, and ``ftn`` depending on the programming language as seen in the table below:

.. _shaheen3_prgenv:

.. list-table:: **Programming environment on Shaheen III**
   :widths: 30 30 30 30 30 30
   :header-rows: 1

   * - Vendor
     - Programming environment
     - Module
     - Language
     - Compiler wrapper
     - Compiler
   * - Cray
     - ``PrgEnv-cray``
     - ``cce``
     - ``C``
     - ``cc``
     - ``craycc``
   * -
     -
     -
     - ``C++``
     - ``CC``
     - ``crayCC``
   * -
     -
     -
     - ``Fortran``
     - ``ftn``
     - ``crayftn``
   * - GNU
     - ``PrgEnv-gnu``
     - ``gcc``
     - ``C``
     - ``cc``
     - ``gcc``
   * -
     -
     -
     - ``C++``
     - ``CC``
     - ``g++``
   * -
     -
     -
     - ``Fortran``
     - ``ftn``
     - ``gfortran``
   * - AMD
     - ``PrgEnv-aocc``
     - ``aocc``
     - ``C``
     - ``cc``
     - ``amdclang``
   * -
     -
     -
     - ``C++``
     - ``CC``
     - ``amdclang++``
   * -
     -
     -
     - ``Fortran``
     - ``ftn``
     - ``amdflang``
   * - Intel
     - ``PrgEnv-intel``
     - ``intel``
     - ``C``
     - ``cc``
     - ``icx``
   * -
     -
     -
     - ``C++``
     - ``CC``
     - ``icpx``
   * -
     -
     -
     - ``Fortran``
     - ``ftn``
     - ``ifort``

PrgEnv-cray: Uses the Cray Compiling Environment (CCE) for compiling Fortran, C, and C++ code. It provides Cray-specific optimizations.

PrgEnv-gnu: Uses the standard GNU Compiler Collection (GCC) for compiling applications.

PrgEnv-aocc: Uses the AMD Optimizing C/C++ Compiler (AOCC), which is designed to deliver specific optimizations for AMD processors, focusing on enhancing performance for compute-intensive workloads.
 
PrgEnv-intel: Uses the standard Intel Compiler Collection for compiling applications.

PrgEnv-gnu-amd: This environment is useful when you want to utilize GCC for Fortran code but need AMD's Clang C/C++ compiler for better optimization of C and C++ code. It is particularly helpful in situations where specific C/C++ code optimization is crucial.  

PrgEnv-cray-amd: This is used when you prefer using the Cray Compiling Environment for its advanced optimization capabilities for Fortran code, but also want to leverage the AMD Clang compiler for C/C++ code. It is beneficial when working with mixed-language applications that need specific optimizations provided by both Cray and AMD. 

For the latest programming environment modules, the default versions are available here: :ref:`2024-10-prgenv-modules`


In the programming environment, the compiler wrappers do not change according to different compilers.
However, one can directly call the underlying compiler under some circumstances.

The documentation (e.g., flags) for the underlying compiler can be obtained via the following command:

.. code-block:: bash

 man <compiler>

The compiler specific flags can be directly passed to the compiler wrappers.


The default flags passed by the wrapper can be obtained via the following command:

.. code-block:: bash

 cc -craype-verbose

The whole compiler invocation can be seen via the following command:

.. code-block:: bash

 cc --cray-print-opts=all

Cray Programming Environment and Compiler Wrappers
===================================================


Cray provides ``PrgEnv-<compiler>`` modules (e.g., ``PrgEnv-cray``) to load the compiler toolchains.
The ``PrgEnv-cray`` module is loaded by default. The following command can be used to switch between compiler toolchains:

.. code-block:: bash

 module switch PrgEnv-cray PrgEnv-gnu

The modules for different versions of the compiler can be listed and changed.
The following example shows how to change the compiler for ``PrgEnv-cray``:

.. code-block:: bash

 $ module av cce
 cce/16.0.1          cce/17.0.0          cce/17.0.1          cce/18.0.0(default)

 $ module switch cce cce/17.0.1

MPI
----

Cray MPICH is provided by default. It is also linked when the compiler wrappers ``cc``, ``CC``, and ``ftn`` are used.
