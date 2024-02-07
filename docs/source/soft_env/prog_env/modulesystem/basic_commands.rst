
.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Software environment of KSL systems
    :keywords: Software environment, Shaheen, Ibex

.. _modulesystem_basics:

================================
Basic commands 
================================

Listing available modules
==========================

To view the available modules on your HPC cluster, use the following command:

.. code-block:: bash

    module avail

This command will display a list of available modules, along with their names and descriptions.

Check information about a module
==================================

To check the information related to installed package, use this command:

.. code-block:: bash

    module whatis 


Check contents of modulefile
==============================

To see what a module does and in which order, this command is useful:

.. code-block:: bash

    module display 


Loading and unloading modules
=================================

To load a module, use the `module load` command:

.. code-block:: bash

    module load package-name

When loading a specific version of the package:

.. code-block:: bash

    module load package-name/version

For example, to load the Python module, use:

.. code-block:: bash

    module load python

To unload a module and revert to the default environment, use the `module unload` command:

.. code-block:: bash

    module unload package-name

Swapping modules
==========================

To switch between different versions of a loaded module.

.. code-block:: bash

    module swap/switch <module1> <module2>


Listing loaded modules
==========================

To see the modules currently loaded in your environment, use:

.. code-block:: bash

    module list

Managing Dependencies
==========================

Modules automatically handle dependencies by adjusting the environment variables, paths, and other settings required by the loaded software package. This ensures that you can use a specific software tool without worrying about conflicting dependencies.

Mega Modules 
==========================

Mega modules are a collection of libraries and applications related to same science domain, or used together in common workflows. 

As a example, to load a collection of common machine learning libraries on KSL systems, the following can be loaded:

.. code-block:: bash

    module load machine_learning 

