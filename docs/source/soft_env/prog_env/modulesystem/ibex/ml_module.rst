.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Machine learning module on Ibex
    :keywords: Ibex, ml, machine, conda, pip, environment

.. _ml_on_ibex:

============================
Ibex Machine Learning Module
============================

Ibex offers a dedicated machine learning module that simplifies the process of using popular machine learning packages on the cluster.

This module contains the following widely used machine learning packages:

- Dask
- Jax
- Jupyter
- Keras
- Pandas
- PyTorch
- Rapids
- Scikit-Learn
- TensorFlow

Key Information
---------------

Here are some important details about the Ibex machine learning module:

- To view all the installed packages in the module, you can run the following command:
  
  .. code-block:: shell
  
     pip list

- Conda is not available within this module. Users are encouraged to manage their own software stacks using Conda (+Pip) if needed (Install Miniconda in your user directory).

- The machine learning module is only available on the `glogin` nodes and is part of the GPU software stack. This is important to note for users who require GPU support for their machine learning tasks.

- The module is typically updated bi-annually, usually prior to the start of a new semester. This ensures that users have access to the latest versions of the included machine learning packages.

Getting Started
----------------

The Ibex machine learning module is intended to help new users quickly get started with running machine learning jobs on the cluster. It provides a pre-configured environment with essential packages. However, more experienced users or those with specific version requirements for particular packages, or those who need additional packages, should consider using Conda (+Pip) to manage their own software stacks.

By using the Ibex machine learning module, you can streamline your workflow and leverage the power of the HPC cluster for your machine learning tasks.

To load the machine_learning module simply run:

.. code-block::

    module load machine_learning

.. note::

   Remember to check for updated versions of the module by running:

   .. code-block:: bash 

        module av machine_learning

.. warning::

   If you have specific package version requirements or need additional packages not included in the module, consider using Conda to create a custom environment.

