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
Since unprivileged users are not the owner of the installed Python, simple ``pip install <package_name>`` command will not allow the package to be installed in the default location. For this, users must use an additional command line option to indicate the destination directory where the package must be installed. Depending on the KSL system, the recommended directories differ. Please refer to the relevant KSL system for instructions.  


``pip`` installer on Shaheen III
=================================
On Shaheen III, the best place to install Python packages using ``pip`` installer is the directory ``$MY_SW`` which points to ``/scratch/${USER}/iops/sw``. It is important to note that installing python packages using ``pip`` with ``-u`` flag is **not recommended** on Shaheen III. The `u` flag sets the home directory as installation directory which is not mounted on Shaheen III compute nodes and your python workload will complain about not finding the packages when running as a job. 

The following shows an example of installing a python package called PyBLAS (a BLAS implementation in Python)

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
    module load mysw

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

    srun -n 1 -c 8 python myscript.py


Persistent ``pip`` installs with Singularity on Ibex
-------------------------------------------------------

When you install packages **inside** a Singularity container, they disappear once the container exits unless you write them to a persistent path outside the SIF. On Ibex, the recommended persistent location is ``/ibex/user/${USER}/software``. The workflow below keeps installs permanent and discoverable by the container.

.. code-block:: bash

        # 1) Create a persistent directory for custom Python packages (Ibex best practice)
        mkdir -p /ibex/user/${USER}/software

        # 2) Start an interactive session (recommended while testing)
        srun --gpus=1 --partition=debug --time=00:30:00 --resv-ports=1 --pty /bin/bash -l

        # 3) Load the container modules
        module load dl
        module load jax/23.10-sif

        # 3.1) Install a single package directly into your persistent path
        singularity exec --nv $JAX_IMAGE pip install --prefix=/ibex/user/${USER}/software <package_name>
        # Example: jupyterlab-nvdashboard
        singularity exec --nv $JAX_IMAGE pip install --prefix=/ibex/user/${USER}/software jupyterlab-nvdashboard

        # 3.2) Or install from a requirements file
        singularity exec --nv $JAX_IMAGE pip install --prefix=/ibex/user/${USER}/software -r requirements.txt

        # 4) Expose your custom site-packages to the container via PYTHONPATH
        export SINGULARITYENV_PYTHONPATH="/ibex/user/${USER}/software/local/lib/python3.10/dist-packages:$SINGULARITYENV_PYTHONPATH"

        # 5) Validate the install from inside the container
        singularity exec --nv $JAX_IMAGE python my_unit_test.py
        singularity exec --nv $JAX_IMAGE python -c "import <package>; print('Success')"

Notes and tips
^^^^^^^^^^^^^^

- Steps 3.1 or 3.2 write packages to ``/ibex/user/${USER}/software`` so they persist across container restarts.
- Step 4 is essential: without exporting ``SINGULARITYENV_PYTHONPATH``, the container will not see your custom installs.
- You can set ``SINGULARITYENV_PYTHONPATH`` before ``srun`` to propagate it into the job environment.
- Replace ``<package_name>`` and ``<package>`` with what you need; keep the Python version segment (``python3.10``) in the path matched to the container's Python.

Example validation output
^^^^^^^^^^^^^^^^^^^^^^^^^

Below is a shortened example showing custom ``jupyterlab-nvdashboard`` coming from the persistent path while ``jax`` is provided by the SIF image:

.. code-block:: text

        Python version: 3.10.12 (main, Jun 11 2023, 05:26:28) [GCC 11.4.0]

        Testing jupyterlab-nvdashboard import...
        ✓ Successfully imported jupyterlab_nvdashboard
            Location: /ibex/user/${USER}/software/local/lib/python3.10/dist-packages/jupyterlab_nvdashboard/__init__.py

        Testing JAX (from SIF image)...
        ✓ Successfully imported jax
            Location: /opt/jax-source/jax/__init__.py


 
