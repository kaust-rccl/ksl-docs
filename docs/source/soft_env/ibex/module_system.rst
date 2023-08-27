Module system
=============

Introduction
------------

A comprehensive set of software has already been optimally compiled on Ibex and made available to users via modules.

The modules system is used to alter the environment by exporting/adding a set of predefined environment variables to your shell upon the module load, and reverses these changes upon the unload.

Listing Available Modules
-------------------------

To view the available modules on your HPC cluster, use the following command:

.. code-block:: bash

    module avail

This command will display a list of available modules, along with their names and descriptions.

Loading and Unloading Modules
-----------------------------

To load a module, use the `module load` command:

.. code-block:: bash

    module load package-name

For example, to load the Python module, use:

.. code-block:: bash

    module load python

To unload a module and revert to the default environment, use the `module unload` command:

.. code-block:: bash

    module unload package-name

Swapping Modules
----------------

To switch between different versions of a loaded module.

.. code-block:: bash

    module swap/switch <module1> <module2>


Listing Loaded Modules
-----------------------

To see the modules currently loaded in your environment, use:

.. code-block:: bash

    module list

Managing Dependencies
---------------------

Modules automatically handle dependencies by adjusting the environment variables, paths, and other settings required by the loaded software package. This ensures that you can use a specific software tool without worrying about conflicting dependencies.

Mega Modules
------------------------

There are further mega modules that can be loaded to add different stacks than the already available one in your environemnt

For example:

You can use the CPU stack on the glogin nodes by:

.. code-block:: bash

    module load intelstack-default

Also, you can check out the GPU stack on the ilogin nodes by:

.. code-block:: bash

    module load gpustack

For applications that are specifically built and optimized to work on AVX-512 intel architectures. Use:

.. code-block:: bash

    module load intelstack-optimized
