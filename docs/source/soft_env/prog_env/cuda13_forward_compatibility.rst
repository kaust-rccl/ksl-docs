.. sectionauthor:: Mohsin Ahmed Shaikh <mohsin.shaikh@kaust.edu.sa>
.. meta::
    :description: Forward Compatibility for Newer CUDA Toolkits
    :keywords: Software environment, Shaheen, Ibex

.. _forward_compatibility_newer_cuda_toolkits:

============================================
Forward Compatibility for Newer CUDA Toolkits
============================================

Overview
========

Some Python packages are built against newer CUDA toolkits than those
available in the system CUDA driver. In such cases, the CUDA Forward
Compatibility package (``cuda-compat``) allows applications to use newer
CUDA runtime libraries without requiring a system-wide driver upgrade.

On Ibex, this can be installed inside a Conda environment without
administrator privileges.

Prerequisites
=============

Before proceeding, ensure that **Miniforge (Conda)** is installed on Ibex.

For installation instructions, refer to :ref:`How to Setup Conda on Ibex Guide <conda_ibex_>` to get started.

Installation
============

1. Allocate a GPU node and start an interactive session:

.. code-block:: bash

   srun -N1 --gres=gpu:a100:1 --ntasks=4 --time=1:0:0 --pty bash

2. Activate your Miniforge installation:

.. code-block:: bash

   source /ibex/user/$USER/miniforge/bin/activate

3. Create a new Conda environment:

.. code-block:: bash

   conda create --name envcuda13

4. Activate the environment:

.. code-block:: bash

   conda activate /ibex/user/$USER/miniforge/envs/envcuda13

5. Install the CUDA Forward Compatibility package together with Python and pip:

.. code-block:: bash

   conda install conda-forge::cuda-compat==13.0.0 python pip

6. Add the CUDA compatibility libraries to ``LD_LIBRARY_PATH``:

.. code-block:: bash

   export LD_LIBRARY_PATH=/ibex/user/$USER/miniforge/envs/envcuda13/cuda-compat/:$LD_LIBRARY_PATH

7. Install PyTorch:

.. code-block:: bash

   pip install torch torchvision

Verification
============

Verify that PyTorch detects the GPU and is using the expected CUDA toolkit:

.. code-block:: bash

   python -c "import torch; print(torch.cuda.is_available(), torch.version.cuda)"

Expected output:

.. code-block:: text

   True 13.0

Notes
=====

* The ``cuda-compat`` package provides forward compatibility libraries for
  newer CUDA toolkits.
* This installation is isolated within the Conda environment and does not
  modify the system CUDA installation.
* The ``LD_LIBRARY_PATH`` environment variable must include the
  ``cuda-compat`` directory before launching CUDA applications.