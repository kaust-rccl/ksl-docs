.. sectionauthor:: Didier Barradas Bautista <didier.barradasbautista@kaust.edu.sa>
.. meta::
    :description: Persistent pip installs with Singularity on Ibex
    :keywords: singularity, pip, containers, persistent storage, jupyter

.. _persistent_pip_singularity:

=================================================
Persistent ``pip`` Installs with Singularity on Ibex
=================================================

When you install Python packages inside a Singularity container, those packages are temporary—they disappear when the container exits. However, by installing packages to a directory outside the SIF image and configuring the ``PYTHONPATH``, you can make these installs permanent and reusable across multiple container runs. This guide walks through the complete workflow with a practical Jupyter Lab example.

The Challenge: Ephemeral Containers
====================================

Singularity containers are designed to be immutable and reproducible. When you run ``pip install`` inside a container, the packages are written to locations inside the SIF file's read-only layer. Once you exit the container, those changes are lost:

.. code-block:: bash

    # This is temporary - packages disappear after container exit
    singularity shell --nv python_3.12.sif
    Singularity> pip install jupyterlab
    Singularity> exit
    # jupyterlab is now gone!


The Solution: Persistent Installation Directory
================================================

The key insight is to install packages to a directory **outside** the SIF file—specifically ``/ibex/user/${USER}/software``—and then expose that directory to the container via the ``PYTHONPATH`` environment variable. This way:

- Packages persist across container sessions
- The container remains unchanged and reproducible
- You can manage multiple Python package sets independently
- The approach works with any container image


Step-by-Step Workflow
=====================

Step 1: Pull the Container Image
---------------------------------

First, convert a Docker image to a Singularity (SIF) format. This example uses the lightweight ``python:3.12-slim-bookworm`` image:

.. code-block:: bash

    # Create a directory for your container images (Ibex best practice)
    mkdir -p /ibex/user/${USER}/containers

    # Set the path for the cached SIF file
    SINGULARITY_CACHEDIR="/ibex/user/${USER}/singularity_cache"

    # Ensure the cache directory exists
    mkdir -p $SINGULARITY_CACHEDIR

    # Ensure the path is exported
    export $SINGULARITY_CACHEDIR

    # Load the Singularity module
    module load singularity
    
    # Pull the Docker image and convert to SIF
    singularity pull /ibex/user/${USER}/containers/python_3.12.sif docker://python:3.12-slim-bookworm

The ``singularity pull`` command automatically converts the Docker image to SIF format and stores it locally. This may take a few minutes depending on image size and network speed.

Expected output:

.. code-block:: text

    INFO:    Downloading docker image...
    1.47GiB / 1.47GiB [===========================] 100.0% 0.0s
    INFO:    Extracting docker image
    INFO:    Creating SIF file...
    INFO:    Build complete: /ibex/user/${USER}/containers/python_3.12.sif


Step 2: Create a Persistent Package Directory
----------------------------------------------

Create a directory where pip packages will be installed and persist:

.. code-block:: bash

    mkdir -p /ibex/user/${USER}/software


Step 3: Install Python Packages to the Persistent Directory
-------------------------------------------------------------

Install packages using ``singularity exec`` with the ``--prefix`` flag pointing to your persistent directory. This keeps packages outside the container image:

.. code-block:: bash

    # Define paths for readability
    CONTAINER=/ibex/user/${USER}/containers/python_3.12.sif
    SOFTWARE=/ibex/user/${USER}/software
    
    # Install jupyterlab
    singularity exec --nv $CONTAINER pip install --prefix=$SOFTWARE jupyterlab
    
    # Install ipykernel (required for Jupyter to use system Python)
    singularity exec --nv $CONTAINER pip install --prefix=$SOFTWARE ipykernel

Each installation writes to ``${SOFTWARE}/lib/python3.12/site-packages/``, making them reusable.


Step 4: Set the PYTHONPATH to Expose Custom Packages
-----------------------------------------------------

Before running the container, set ``SINGULARITYENV_PYTHONPATH`` to tell the container where your packages are. This environment variable is automatically injected into the container:

.. code-block:: bash

    export SINGULARITYENV_PYTHONPATH="/ibex/user/${USER}/software/lib/python3.12/site-packages:$SINGULARITYENV_PYTHONPATH"

This is **critical**—without it, the container will not find your custom packages.


Step 5: Validate the Installation
----------------------------------

Test that the container can import your packages:

.. code-block:: bash

    singularity exec --nv $CONTAINER python -c "import jupyterlab; print('✓ jupyterlab installed')"
    singularity exec --nv $CONTAINER python -c "import ipykernel; print('✓ ipykernel installed')"

Expected output:

.. code-block:: text

    ✓ jupyterlab installed
    ✓ ipykernel installed


Practical Example: Deploying Jupyter Lab on Ibex
=================================================

Now let's combine everything into a complete workflow: pull a Python container, install Jupyter, and deploy it with a SLURM jobscript.

Interactive Installation Session
---------------------------------

First, install packages interactively using an interactive SLURM job:

.. code-block:: bash

    # Request an interactive session on a compute node
    srun --gpus=1 --partition=debug --time=00:30:00 --pty /bin/bash -l
    
    # Once on the compute node, set up variables
    module load singularity
    CONTAINER=/ibex/user/${USER}/containers/python_3.12.sif
    SOFTWARE=/ibex/user/${USER}/software
    
    # Pull the container (if not already done)
    mkdir -p /ibex/user/${USER}/containers
    singularity pull $CONTAINER docker://python:3.12-slim-bookworm
    
    # Create software directory
    mkdir -p $SOFTWARE
    
    # Install packages
    singularity exec --nv $CONTAINER pip install --prefix=$SOFTWARE jupyterlab ipykernel
    
    # Validate
    export SINGULARITYENV_PYTHONPATH="$SOFTWARE/lib/python3.12/site-packages:$SINGULARITYENV_PYTHONPATH"
    singularity exec --nv $CONTAINER jupyter --version
    
    # Exit the interactive session
    exit


SLURM Jobscript for Jupyter Deployment
---------------------------------------

Save the following script as ``jupyter_persistent.slurm`` in your working directory. This script automates container pulling, package installation, and Jupyter startup with SSH tunneling:

.. code-block:: bash
    :caption: jupyter_persistent.slurm - Deploy Jupyter Lab with persistent pip packages

    #!/bin/bash -l
    #SBATCH --time=00:30:00
    #SBATCH --nodes=1
    #SBATCH --gpus-per-node=v100:1
    #SBATCH --cpus-per-gpu=6
    #SBATCH --mem=32G
    #SBATCH --partition=batch
    #SBATCH --job-name=jupyter
    
    set -euo pipefail
    
    ### Load the modules you need for your job
    module purge
    module load singularity
    
    ### Helper Functions Definitions
    checking_container_image() {
        ## 1. Define variables
    
        ## 2. Validate and pull the image if it is not available or is corrupted
        # Check if image already exists
        if [[ ! -f "${SIF_FILE_PATH}" ]]; then
            echo "[FAIL] Image not found. Pulling from ${IMAGE_NAME} ..."
            singularity pull "${SIF_FILE_PATH}" "docker://${IMAGE_NAME}"
        else
            echo "[OK] Found existing SIF file: ${SIF_FILE_PATH}"
    
            # Try running singularity inspect (safe way to check validity)
            if singularity inspect "${SIF_FILE_PATH}" > /dev/null 2>&1; then
                echo "[OK] Validation successful. Image is usable."
            else
                echo "[FAIL] Existing file is corrupted or invalid. Re-pulling..."
                rm -f "${SIF_FILE_PATH}"
                singularity pull "${SIF_FILE_PATH}" "docker://$IMAGE_NAME"
            fi
        fi
        echo "[OK] Using image: ${SIF_FILE_PATH}"
    }
    
    preparing_jupyter_environment() {
        for var in JUPYTER_CONFIG_DIR JUPYTER_DATA_DIR JUPYTER_RUNTIME_DIR IPYTHONDIR; do
            dir="${!var}"   # expand value of the variable
            if [[ ! -d "$dir" ]]; then
                echo "[FAIL] ${var} was not found. Creating $var directory at: $dir"
                mkdir -p "$dir"
            else
                echo "[OK] Found existing $var directory at: $dir"
            fi
        done
    }
    
    preparing_persistent_packages() {
        if [[ ! -d "${SOFTWARE_PATH}" ]]; then
            echo "[FAIL] Software directory not found. Creating at: ${SOFTWARE_PATH}"
            mkdir -p "${SOFTWARE_PATH}"
        else
            echo "[OK] Found existing software directory at: ${SOFTWARE_PATH}"
        fi
    }
    
    ### Define container and package paths
    echo "=== 1/4 Checking Container Image ==="
    IMAGE_NAME="python:3.12-slim-bookworm"
    SIF_FILE_NAME="python_3.12.sif"
    SIF_FILE_PATH="/ibex/user/${USER}/containers/${SIF_FILE_NAME}"
    SOFTWARE_PATH="/ibex/user/${USER}/software"
    
    # Create containers directory if needed
    mkdir -p /ibex/user/${USER}/containers
    
    checking_container_image
    
    echo "=== 2/4 Checking Persistent Package Directory ==="
    preparing_persistent_packages
    
    echo "=== 3/4 Preparing Jupyter Environment Variables ==="
    ### Define Jupyter Variables
    export SCRATCH_IOPS=/ibex/user/$USER/
    export JUPYTER_CONFIG_DIR=${SCRATCH_IOPS}/.jupyter
    export JUPYTER_DATA_DIR=${SCRATCH_IOPS}/.local/share/jupyter
    export JUPYTER_RUNTIME_DIR=${SCRATCH_IOPS}/.local/share/jupyter/runtime
    export IPYTHONDIR=${SCRATCH_IOPS}/.ipython
    export XDG_RUNTIME_DIR=/tmp
    
    # Ensure Jupyter/IPython directories exist
    preparing_jupyter_environment
    
    # Set PYTHONPATH to use custom packages
    export SINGULARITYENV_PYTHONPATH="${SOFTWARE_PATH}/lib/python3.12/site-packages:$SINGULARITYENV_PYTHONPATH"
    
    # Install packages if not already installed
    if ! singularity exec --nv "${SIF_FILE_PATH}" python -c "import jupyterlab" 2>/dev/null; then
        echo "[INFO] Installing jupyterlab and ipykernel..."
        singularity exec --nv "${SIF_FILE_PATH}" pip install --prefix="${SOFTWARE_PATH}" jupyterlab ipykernel
        echo "[OK] Packages installed successfully"
    else
        echo "[OK] Packages already installed"
    fi
    
    echo "=== 4/4 Starting Jupyter ==="
    ### Setup SSH tunneling information
    node=$(hostname -s)
    user=$(whoami)
    submit_host=${SLURM_SUBMIT_HOST}
    port=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    
    instructions="
    ============================================================
    Jupyter Lab is starting on compute node: ${node}
    ============================================================
    
    To connect from your local machine, run this in a NEW terminal:
    
        ssh -L ${port}:${node}.ibex.kaust.edu.sa:${port} ${user}@glogin.ibex.kaust.edu.sa
    
    Then copy the URL shown below (starting with http://127.0.0.1) 
    and paste it into your browser on your local machine.
    
    ============================================================
    IMPORTANT: Shutdown Jupyter gracefully
    ============================================================
    
    When finished, close your browser notebooks and click the
    'Shutdown' button in Jupyter to exit cleanly. If you do not
    shutdown Jupyter, the job will continue running until the
    time limit is reached.
    
    ============================================================
    "
    
    # Run Jupyter Lab inside the Singularity container
    singularity exec --nv \
        -B /ibex \
        ${SIF_FILE_PATH} \
        /bin/bash -lc "echo -e '${instructions}'
        jupyter lab --no-browser --port=${port} --port-retries=0 \
        --ip=${node}.ibex.kaust.edu.sa \
        --NotebookApp.custom_display_url='http://${node}.ibex.kaust.edu.sa:${port}/lab'"


Submitting the Jupyter Job
---------------------------

Submit the jobscript to SLURM:

.. code-block:: bash

    sbatch jupyter_persistent.slurm

Watch the output to find the Jupyter URL:

.. code-block:: bash

    # Check the job output
    tail -f slurm-<JOBID>.out


Example output:

.. code-block:: text

    === 1/4 Checking Container Image ===
    [OK] Found existing SIF file: /ibex/user/barradd/containers/python_3.12.sif
    [OK] Validation successful. Image is usable.
    [OK] Using image: /ibex/user/barradd/containers/python_3.12.sif
    
    === 2/4 Checking Persistent Package Directory ===
    [OK] Found existing software directory at: /ibex/user/barradd/software
    
    === 3/4 Preparing Jupyter Environment Variables ===
    [OK] Found existing .jupyter directory at: /ibex/user/barradd/.jupyter
    [OK] Found existing .ipython directory at: /ibex/user/barradd/.ipython
    
    === 4/4 Starting Jupyter ===
    [OK] Packages already installed
    
    ============================================================
    Jupyter Lab is starting on compute node: gpu510
    ============================================================
    
    To connect from your local machine, run this in a NEW terminal:
    
        ssh -L 8888:gpu510.ibex.kaust.edu.sa:8888 barradd@glogin.ibex.kaust.edu.sa
    
    Then copy the URL shown below (starting with http://127.0.0.1) 
    and paste it into your browser on your local machine.
    ============================================================
    
    [I 2025-12-09 14:32:15.123 ServerApp] Jupyter Server 4.0.6 is running at:
    [I 2025-12-09 14:32:15.123 ServerApp] http://127.0.0.1:8888/lab?token=abcdef123456...


Connecting to Your Jupyter Server
----------------------------------

Follow these steps on your **local machine** to access Jupyter:

1. **Open a terminal on your local machine** and run:

   .. code-block:: bash

       ssh -L 8888:gpu510.ibex.kaust.edu.sa:8888 <your_username>@glogin.ibex.kaust.edu.sa

   Replace ``8888`` with the port number from the job output and ``gpu510`` with the actual compute node name.

2. **Copy the Jupyter URL** from the job output (the one starting with ``http://127.0.0.1``) and paste it into your browser.

3. **When finished**, click the "Shutdown" button in Jupyter to gracefully exit the job.


Best Practices
==============

1. **Version Control Your Packages**
   Keep a ``requirements.txt`` file with your pinned package versions:

   .. code-block:: bash

       pip freeze > requirements.txt
       singularity exec --nv $CONTAINER pip install --prefix=$SOFTWARE -r requirements.txt

2. **Don't Forget SINGULARITYENV_PYTHONPATH**
   Always set this environment variable before running the container, or the packages won't be found.

3. **Use Separate Directories for Different Projects**
   Create separate software directories for different projects to avoid conflicts:

   .. code-block:: bash

       mkdir -p /ibex/user/${USER}/software/project1
       mkdir -p /ibex/user/${USER}/software/project2

4. **Check Python Version in Path**
   The path ``lib/python3.12/site-packages`` must match the Python version in your container. Verify with:

   .. code-block:: bash

       singularity exec --nv $CONTAINER python --version

5. **Clean Up Old Containers**
   Monitor disk usage and remove old SIF files when no longer needed:

   .. code-block:: bash

       ls -lh /ibex/user/${USER}/containers/
       rm /ibex/user/${USER}/containers/old_image.sif


Troubleshooting
===============

**Issue**: "ModuleNotFoundError: No module named 'jupyterlab'"
  **Solution**: Ensure ``SINGULARITYENV_PYTHONPATH`` is set before running the container. Verify the path matches your Python version (e.g., ``python3.12`` vs ``python3.10``).

**Issue**: "Permission denied" when writing to software directory
  **Solution**: Ensure the directory is owned by you: ``ls -ld /ibex/user/${USER}/software``. If needed, check file permissions within the directory.

**Issue**: Container image is corrupted or won't load
  **Solution**: The jobscript includes validation. Delete the corrupted file and let the script re-pull it automatically.

**Issue**: Jupyter doesn't start or times out
  **Solution**: Check SLURM job logs with ``scat <JOBID>``. Ensure you have GPU availability and the partition exists.

**Issue**: SSH tunnel connection refused
  **Solution**: Verify the compute node name and port are correct from the job output. Ensure your local machine can reach the login node.


Additional Resources
====================

- `Singularity Documentation <https://docs.sylabs.io/>`_
- `Python pip Documentation <https://pip.pypa.io/>`_
- `Jupyter Lab Documentation <https://jupyter-lab.readthedocs.io/>`_
- `KSL Documentation <https://docs.hpc.kaust.edu.sa/>`_
