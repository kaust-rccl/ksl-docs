.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Using conda in shaheen3
    :keywords: conda, shaheen3

.. _conda_shaheen3:

==========================================
Using ``conda`` on Shaheen III 
==========================================

Users can opt to maintain their own software using ``conda`` pack manager on Shaheen III. 

Installing package manager
============================
The following steps demonstrate the installation of Conda on Shaheen III Lustre. It is recommended that users install their Miniconda in high IOPS tier of Shaheen III filesystem. It is exempted from periodic purging and  is designed to keep up with large number of I/O operations d. 
**The following is a one-off step** 

.. code-block:: bash

   mkdir -p $MY_SW && cd $MY_SW
   bash /sw/sources/miniconda/conda24.1.2-python3.12.1/Miniconda3-latest-Linux-x86_64.sh -b -s -p $MY_SW/miniconda3-amd64 -u
   source $MY_SW/miniconda3-amd64/bin/activate
   conda install -y -c conda-forge mamba==1.5.8
   conda deactivate

The commands above will install ``conda`` package manager's ``base`` environment in $MY_SW/miniconda3-amd64. 

.. important:: 
  Any use of ``conda`` package from here on will require user to activate the base or target environment. The following command achieves this:

.. code-block::
  
  source $MY_SW/miniconda3-amd64/bin/activate


Optional step
--------------
Installing elaborate conda environments can be time consuming. To accelerate the installation process, ``mamba`` package manager can be used. It is a reimplementation of the conda package manager in C++. Simply install ``mamba`` in miniconda3's base environment.

.. code-block:: bash
  
  conda install -y -c conda-forge mamba=1.5.8
  

Creating new environments
===========================

Conda can be activated using the following command:

.. code-block:: bash

  source $MY_SW/miniconda3-amd64/bin/activate
 
The following example demonstrates the installation of a Conda envrionment named ``myenv`` on Shaheen III using user's own miniconda installation.
The intent is to install Python 3.9 in the environment ``myenv``.

.. code-block:: bash

   mamba  create --prefix /scratch/$USER/iops/sw/envs/myenv -c conda-forge python=3.9

The Conda environment ``myenv`` can be activated as follows:

.. code-block:: bash

  conda activate $MY_SW/envs/myenv

.. important::

   ``conda`` package cache on Shaheen III is redirected to ``$MY_SW/cache``. 
   **Clearing this cache directory is the responsibility of user** to avoid failures when creating new environments due to lack of space in ``$SCRATCH_IOPS`` directory.

.. code-block:: bash

  conda clean --all

.. _conda_package_install_batch:

Installing complex environments
=================================

``conda`` environments can sometimes come with a lot of dependencies. This causes them to take long time to install. 

One prerequisite for this is to have an ``environment.yaml`` file listing all the required software and preferred channels to search these packages. Below is an example environment file:

.. code-block:: yaml

    name: pytorch
    channels:
    - pytorch
    - conda-forge
    dependencies:
    - python=3.9
    - pytorch=2.2.0 
    - torchvision=0.17.0 
    - torchaudio=2.2.0 
    - cpuonly 
    - jupyterlab 
    - notebook 
    - ipykernel 
    - nb_conda_kernels 
    - nodejs
    - tensorboard
    - tensorboardx
    - pip
    - pip: 
        - ipython
        - ipywidgets
        - ipyparallel
        - matplotlib
        - bokeh==2.4.3
        - jupyterlab_nvdashboard
        - pytorch-lightning

The environment can be installed as follows:

.. code-block:: bash

  source $MY_SW/miniconda3-amd64/bin/activate
  mamba env create -f environment.yaml -p $MY_SW/envs/pytorch

Running jobs with ``conda`` environments
=========================================

Applications installed as ``conda`` packages can be run as batch workloads on SLURM. To do this, the jobscripts needs to activate the right environment and then launch the application. Here is an examples jobscript which queries the version and installation location of Pytorch installed the in :ref: `previous section <conda_package_install_batch>`

.. code-block:: bash

  #!/bin/bash
  #SBATCH -t 00:10:00
  #SBATCH -p workq

  source $MY_SW/miniconda3-amd64/bin/activate $MY_SW/envs/pytorch

  python -c 'import torch; print("Pytorch Version:",torch.__version__)'
  python -c 'import torch; print("Pytorch location:",torch.__file__)'

Expected output is:

.. code-block:: bash
  
  Pytorch Version: 2.2.0
  Pytorch location: </path/to/env>/lib/python3.9/site-packages/torch/__init__.py
