==========
Shaheen 3
==========

Users can benefit from many software packages and scientific libraries available as modules. Users can also compile their source code using various compiler toolchains in the Cray Programming Environment.

*******************
Environment Modules
*******************

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

 module help xxxx
 module show xxxx

* To display Cray Scientific Libraries:

.. code-block:: bash

 module avail –L

* To load a module:

.. code-block:: bash

 module load xxxxx

.. toctree::
   :maxdepth: 1
   :titlesonly:

*******************
Compiler Toolchains
*******************

Cray, AMD, and GCC compiler toolchains are provided through modules.
The module ``PrgEnv-<compiler>`` is used to activate the respective toolchain.
Regardless of the underlying compiler, the user must use the following compiler wrappers:

+--------+-------------------------+-----------------+----------+-------------------+---------------------------------+
| Vendor | Programming Environment | Compiler Module | Language | Compiler Wrapper  | Compiler                        |
+========+=========================+=================+==========+===================+=================================+
| Cray   | ``PrgEnv-cray``         | ``cce``         | C        | ``cc``            | ``craycc``                      |
|        |                         |                 +----------+-------------------+---------------------------------+
|        |                         |                 | C++      | ``CC``            | ``craycxx`` or ``crayCC``       |
|        |                         |                 +----------+-------------------+---------------------------------+
|        |                         |                 | Fortran  | ``ftn``           | ``crayftn``                     |
+--------+-------------------------+-----------------+----------+-------------------+---------------------------------+
| GCC    | ``PrgEnv-gnu``          | ``gcc``         | C        | ``cc``            | ``gcc``                         |
|        |                         |                 +----------+-------------------+---------------------------------+
|        |                         |                 | C++      | ``CC``            | ``g++``                         |
|        |                         |                 +----------+-------------------+---------------------------------+
|        |                         |                 | Fortran  | ``ftn``           | ``gfortran``                    |
+--------+-------------------------+-----------------+----------+-------------------+---------------------------------+
| AMD    | ``PrgEnv-amd``          | ``amd``         | C        | ``cc``            | ``amdclang``                    |
|        |                         |                 +----------+-------------------+---------------------------------+
|        |                         |                 | C++      | ``CC``            | ``amdclang++``                  |
|        |                         |                 +----------+-------------------+---------------------------------+
|        |                         |                 | Fortran  | ``ftn``           | ``amdflang``                    |
+--------+-------------------------+-----------------+----------+-------------------+---------------------------------+

As seen above, the compiler wrappers do not change according to different compilers.
However, one can directly call the underlying compiler under some circumstances.

The documentation (e.g., flags) for the underlying compiler can be obtained via the following command:

.. code-block:: bash

 man <compiler>

The default flags passed by the wrapper can be obtained via the following command:

.. code-block:: bash

 cc -craype-verbose

The whole compiler invocation can be seen via the following command:

.. code-block:: bash

 cc --cray-print-opts=all

Cray Programming Environment and Compiler Wrappers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Cray provides ``PrgEnv-<compiler>`` modules (e.g., ``PrgEnv-cray``) to load the compiler toolchains.

.. code-block:: bash

 module load PrgEnv-gnu

The ``PrgEnv-cray`` module is loaded by default. The following command can be used to switch between compilers toolchains:

.. code-block:: bash

 module switch PrgEnv-cray PrgEnv-gnu

MPI
^^^

Cray MPICH is provided by default. It is also linked when the compiler wrappers ``cc``, ``CC``, and ``ftn`` are used.
