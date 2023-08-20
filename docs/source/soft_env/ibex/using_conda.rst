Using conda on Ibex 
===================

Getting Started
---------------

To begin using Conda on an HPC cluster, you'll need to follow these general steps:

1. Install Miniconda or Anaconda: Start by installing Miniconda or Anaconda on the HPC cluster if it is not already available. These distributions of Conda provide a user-friendly installer and the `conda` command-line tool.

2. Configure Conda Channels: HPC clusters may have specific software channels or repositories. You can configure Conda to prioritize these channels when searching for packages.

3. Create Conda Environments: Use Conda to create isolated environments for your projects. This helps ensure that your software and dependencies do not interfere with the HPC cluster's system-wide packages.

4. Install Packages: Within your Conda environments, you can install packages using the `conda install` command. Conda will manage dependencies and resolve any conflicts.

Creating Conda Environments
---------------------------

In this section, we will walk you through the process of creating Conda environments tailored to your projects within an HPC environment. By creating isolated environments, you can ensure that your software dependencies do not interfere with other users or system-wide packages.

Creating a Basic Environment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When creating an environemnt on Ibex, User should allocate a compute / GPU node (Depending on whether the packages need cuda and GPUs) instead of using the login node.
Users can allocate these nodes interactively using srun command or through a job script launched with sbatch command.

Example:

.. code-block:: bash
    
    srun -N 1 --time=00:30:00 --gres=gpu:1 --pty bash

To create a new Conda environment, use the following command:

.. code-block:: bash

    conda create --name myenv python=3.8

This command creates a new environment named "myenv" and installs Python 3.8 into it. 
You can replace "myenv" with a name of your choice.

Creating an environemnt with pip
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To create a new environemnt to use pip with conda, use the following commands:

.. code-block:: bash

    conda create --name some-env pip python
    conda activate some-env
    python -m pip install numpy

These commands create a new environemnt called some-env and installs python and pip and istalls numpy using pip. 
you can replace "some-env" with a name of your choice.


Activating and Deactivating Environments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once an environment is created, you can activate it using:

.. code-block:: bash

    conda activate myenv

To deactivate the environment and return to the base environment, use:

.. code-block:: bash

    conda deactivate

Installing and Managing Packages
--------------------------------

In this section, we will explore how to install and manage packages within your Conda environments on the HPC cluster.

Installing Packages
~~~~~~~~~~~~~~~~~~~~

You can install packages using the `conda install` command. For example:

.. code-block:: bash

    conda install numpy

This installs the `numpy` package into the currently activated environment.

Specifying Dependencies
~~~~~~~~~~~~~~~~~~~~~~~

You can create a `environment.yml` file to list the packages and their versions required for your project:

.. code-block:: yaml

    name: some-env

    channels:
      - conda-forge
      - defaults
  
    dependencies:
      - python
      - pip
      - pip:
        - numpy

To create an environment from the `environment.yml` file, use:

.. code-block:: bash

    conda env create -f environment.yml

Updating and Removing Packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To update a package, use:

.. code-block:: bash

    conda update numpy

To remove a package, use:

.. code-block:: bash

    conda remove numpy

Best Practices for Conda on HPC
-------------------------------

In this section, we'll provide some best practices for effectively using Conda in an HPC environment.

Minimize System-Wide Modifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While Conda can help manage packages, minimizing system-wide modifications is important. Utilize Conda environments to encapsulate software dependencies.

Manage Environment Files
~~~~~~~~~~~~~~~~~~~~~~~~~

Use environment files (e.g., `environment.yml`) to document and share the exact dependencies needed for your projects.

How do I activate my Conda environment in my Slurm job scripts on Ibex?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
You need to run their Slurm jobs inside a Bash login shell in order to make use of the conda activate command. 
To do this you need only add the --login flag to the first line of your Slurm job script. 
Your Slurm job script should look as follows. 
You should also add a module purge command just before activating the environment to make sure that all modules are removed from you Bash environment prior to Conda environment being activated.

.. code-block:: bash

    #!/bin/bash --login
    #SBATCH ...
    .
    .
    .
    #SBATCH ...

    # define some environment variables
    PROJECT_DIR="$PWD"
    ENV_PREFIX="$PROJECT_DIR"/env

    # activate the conda environment
    module purge
    conda activate "$ENV_PREFIX"


Additional Resources
---------------------

- Conda Documentation: https://docs.conda.io/