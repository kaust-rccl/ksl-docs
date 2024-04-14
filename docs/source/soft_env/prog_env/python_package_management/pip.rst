.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: pip installer from managed Python module
    :keywords: conda, shaheen3

.. _pip_installations:

============================================
Installing packages using ``pip``   
============================================
``pip`` is a powerful package manager to install packages in a Python environment. ``pip`` can either be used to install precompiled binaries or python packages in the form of ``pip`` wheels or build Python software from source (uses ``setup.py`` file which comes included in source).

By default ``pip`` pulls the pre-compiled wheels from a public repository called ``pypi.org``.  

On KSL systems, managed Python is installed as a Linux module and has ``pip`` already installed. Users can use this installer to installed packages of choice in their own software directory. 

By default, ``pip`` installs packages in the root directory of the Python in ${PYTHON_HOME}/python``x.y``/site-packages (``x.y`` is major.minor version of python e.g. ``python3.10``).
Since normal users are not the owner of the installed Python, simple ``pip install <package_name>`` command will not allow the package to be installed in the default location. For this, users must use an additional command line option to indicate the destination directory where the package must be installed. Depending on the KSL system, the recommended directories differ. Please refer to the relevant KSL system for instructions.  


``pip`` installer on Shaheen III
=================================
On Shaheen III, the best place to install Python packages using ``pip`` installer is the directory ``$MY_SW`` which points to ``/scratch/${USER}/iops/sw``. The following shows an example of installing a python package called PyBLAS (a BLAS implementation in Python)

.. code-block:: bash

     module load python
     mkdir -p ${MY_SW}
     pip install --prefix=${MY_SW} PyBLAS

If you see ``pip`` wants to upgrade or downgrade a dependency packages which is pre-installed in the root directory of the Python module, you can force the whole dependency tree to be installed in your ``${MY_SW}`` directory:

.. code-block:: bash

    pip install --prefix=${MY_SW} --ignore-installed  PyBLAS

Using the installed packages
-----------------------------
To use the Python packages from ${MY_SW}, you will need to first update the environment so Python can find them. Below is a jobscript running a python script which uses the installed PyBLAS package we just installed.

.. code-block:: 

    #!/bin/bash

    #SBATCH -n 1 
    #SBATCH -c 8 

    module load python

    export PYTHONPATH=${MY_SW}/python${PYTHON_MAJ_MIN_VER}/site-packages:$PYTHONPATH

    srun -n 1 -c 8 python myscript.py



``pip`` installer on Ibex
==========================
On Ibex, the best place to install Python packages using ``pip`` installer is the directory ``/ibex/user/${USER}/software`` directory. 
On Ibex, there are more than one managed Python modulefiles. The Python you choose for installing the target package will be required everytime you want to use the package during runtime. 

The following shows an example of installing a python package called PyBLAS (a BLAS implementation in Python)

.. code-block:: bash

     module load python
     mkdir -p /ibex/user/${USER}/software
     pip install --prefix=/ibex/user/${USER}/software PyBLAS

If you see ``pip`` wants to upgrade or downgrade a dependency packages which is pre-installed in the root directory of the Python module, you can force the whole dependency tree to be installed in your ``${MY_SW}`` directory:

.. code-block:: bash

    pip install --prefix=/ibex/user/${USER}/software --ignore-installed  PyBLAS


Using the installed packages
-----------------------------
Same as in Shaheen III, for Ibex, you will need to update the shell environment so that the Python will find the package your python script attempts to ``import``.

.. code-block:: 

    #!/bin/bash

    #SBATCH -n 1 
    #SBATCH -c 8 

    module load python

    export PYTHONPATH=/ibex/user/${USER}/software/python${PYTHON_MAJ_MIN_VER}/site-packages:$PYTHONPATH

    srun -n 1 -c 8 python myscript.py


 
