.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Using conda in shaheen3
    :keywords: conda, shaheen3

.. _conda_shaheen3:

===============================
Installation of ``conda`` on Shaheen 3 
===============================

The following steps demonstrate the installation of conda on Shaheen 3 Lustre:

.. code-block:: bash

   cd /scratch/$USER/iops
   mkdir miniconda3
   cd miniconda3
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   bash Miniconda3-latest-Linux-x86_64.sh -u

The conda can be activated using the following command:

.. code-block:: bash

   eval "$(/scratch/$USER/iops/miniconda3/bin/conda shell.bash hook)"

 
The following steps demonstrate the installation of a conda envrionment on Shaheen 3 Lustre:

.. code-block:: bash

   conda  create --prefix /scratch/$USER/iops/envs/myenv 
