.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Using conda in shaheen3
    :keywords: conda, shaheen3

.. _conda_shaheen3:

==========================================
Installation of Conda on Shaheen III 
==========================================

The following steps demonstrate the installation of Conda on Shaheen III Lustre:

.. code-block:: bash

   cd /scratch/$USER/iops
   mkdir miniconda3
   cd miniconda3
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   bash Miniconda3-latest-Linux-x86_64.sh -u

After accpeting the license terms, enter ``/scratch/$USER/iops/miniconda3/`` as installation directory of Conda:

.. code-block:: bash

  Do you accept the license terms? [yes|no]
  >>> yes
  
  Miniconda3 will now be installed into this location:
  /home/akbudak/miniconda3

    - Press ENTER to confirm the location
    - Press CTRL-C to abort the installation
    - Or specify a different location below

  [/home/akbudak/miniconda3] >>> /scratch/$USER/iops/miniconda3/


Conda can be activated using the following command:

.. code-block:: bash

   eval "$(/scratch/$USER/iops/miniconda3/bin/conda shell.bash hook)"

 
The following step demonstrates the installation of a Conda envrionment named ``myenv`` on Shaheen III Lustre:

.. code-block:: bash

   conda  create --prefix /scratch/$USER/iops/envs/myenv 

The Conda environment ``myenv`` can be activated as follows:

.. code-block:: bash

  conda activate /scratch/$USER/iops/envs/myenv

The following SLURM script named ``job.slurm`` can be used as a template for using Conda-installed packages:

.. code-block:: bash

  #!/bin/bash
  #SBATCH --time 5:0
  eval "$(/scratch/$USER/iops/miniconda3/bin/conda shell.bash hook)"
  conda activate /scratch/$USER/iops/envs/myenv
  which conda
  which python
  conda list

The above-mentioned SLURM script can be submitted as follows:

.. code-block:: bash

  sbatch job.slurm
