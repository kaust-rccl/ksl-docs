Running Jobs with Singularity
=============================

Running Applications Interactively Inside Singularity Containers
----------------------------------------------------------------

Singularity allows you to interactively run applications within containers. This is useful for debugging, testing, and exploring your containerized environment. To run an application interactively, use the following command::

.. code-block:: bash

    singularity shell my_container.sif

Replace ``my_container.sif`` with the path to your Singularity container image. This opens a shell within the container, enabling you to execute commands as if you were inside the container itself.

Executing Containerized Batch Jobs in an HPC Environment
--------------------------------------------------------

In an HPC environment, you often need to run applications as batch jobs. Singularity seamlessly integrates with popular batch schedulers like Slurm and PBS, enabling you to run containerized jobs without hassle.

To run a containerized batch job, use the ``singularity exec`` command followed by the image and the command to be executed::

.. code-block:: bash

    singularity exec my_container.sif python my_script.py

Mapping Filesystems, Directories, and Data into Containers
----------------------------------------------------------

Singularity allows you to map host filesystems, directories, and data into the container environment. This enables applications inside the container to access external data seamlessly. Use the ``--bind`` or ``-B`` option to specify the paths to be mapped::

.. code-block:: bash

    singularity exec --bind /path/on/host:/path/in/container my_container.sif my_command

Handling Input and Output Files Between Host and Container
----------------------------------------------------------

When running batch jobs, data exchange between the host and the container is essential. Use the ``--pwd`` option to set the current working directory inside the container to the directory where the batch job script resides. This ensures that input and output files are accessed correctly::

.. code-block:: bash

    singularity exec --pwd /path/to/job/directory my_container.sif python my_script.py input.txt output.txt

Leveraging Singularity in HPC Job Scripts and Workflows
-------------------------------------------------------

Integrating Singularity into HPC job scripts and workflows enhances reproducibility and simplifies job management. Use the ``singularity exec`` command to encapsulate commands in your job script

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name=my_job
    #SBATCH --output=output.log
    #SBATCH -N 1
    #SBATCH --time=00:30:00


    singularity exec my_container.sif python my_script.py

By incorporating Singularity into your HPC job scripts and workflows, you ensure that your applications are executed consistently across various environments.
